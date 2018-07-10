----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    13:13:21 03/12/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    vfat2_data_decoder - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
-- This module deserializes the tracking data coming from a single VFAT2 and checks the CRC.
-- Data is constantly checked in order to make abstraction of the data_valid line. 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;

entity vfat2_data_decoder is
port(

    ref_clk_i           : in std_logic;
    clk_4x_i            : in std_logic;
    reset_i             : in std_logic;
    
    remove_bad_crc_i    : in std_logic;
    
    -- VFAT2 data out
    vfat2_data_out_i    : in std_logic;
    
    -- Output packet
    tk_data_o           : out tk_data_t
    
);
end vfat2_data_decoder;

architecture Behavioral of vfat2_data_decoder is

    -- The data packet is 192 bits wide but we include the two required IDLE bits in front of each packet         
    signal bits             : std_logic_vector(4 downto 0);
    signal data_bit         : std_logic;
    signal data             : std_logic_vector(199 downto 0); 
    
    -- Time lapse to prevent fake events
    signal lapse            : integer range 0 to 255;
    
    -- Holds the results of the tests
    signal tests            : std_logic_vector(3 downto 0);     
    -- Check if the strips are hit
    signal hit              : std_logic;
    
    signal empty_128bits    : std_logic_vector(127 downto 0);
    
begin

    empty_128bits <= (others => '0');
    
    --==================--
    --== Oversampling ==--
    --==================--
    
    process(clk_4x_i)   
    begin
        if (rising_edge(clk_4x_i)) then 
            if (reset_i = '1') then
                bits <= (others => '0');
            else
                bits <= bits(3 downto 0) & vfat2_data_out_i;
            end if;
        end if;
    end process;

    --=======================--
    --== Data deserializer ==--
    --=======================--

    process(ref_clk_i)    
        variable d : std_logic;
    begin
        if (rising_edge(ref_clk_i)) then
            -- Reset & default value
            if (reset_i = '1') then
                d := '0';
                data <= (others => '0');
            else
                case bits is
                    when "00000" | "00001" | "00010" | "00100" | "01000" | "10000" => d := '0';
                    when "11111" | "11110" | "11101" | "11011" | "10111" | "01111" => d := '1';
                    when "00011" | "00101" | "01001" | "10001" | "00110" | "01010" | "10010" | "01100" | "10100" | "11000" => d := '0';
                    when "11100" | "11010" | "10110" | "01110" | "11001" | "10101" | "01101" | "10011" | "01011" | "00111" => d := '1';
                    when others => d := '0';
                end case;
                -- Shift the data in the register
                data <= data(198 downto 0) & d;
            end if;
        end if;
    end process;
    
    --================--
    --== Validation ==--
    --================--
    
    process(ref_clk_i)       
        variable crc    : std_logic_vector(15 downto 0);  
    begin
        if (rising_edge(ref_clk_i)) then
            -- Reset & default values
            if (reset_i = '1') then
                hit <= '0';
                tests <= (others => '0');
                crc := (others => '0');
            else
                -- Check the 6 fixed bits 
                case data(193 downto 188) is
                    when "001010" => tests(0) <= '1';
                    when others => tests(0) <= '0';
                end case;
                -- Check the 4 next fixed bits
                case data(175 downto 172) is
                    when "1100" => tests(1) <= '1';
                    when others => tests(1) <= '0';
                end case;
                -- Check the 4 next fixed bits
                case data(159 downto 156) is
                    when "1110" => tests(2) <= '1';
                    when others => tests(2) <= '0';
                end case;
                -- Compute CRC
                crc := x"FFFF";
                for I in 11 downto 1 loop
                    for J in 0 to 15 loop
                        if (data((I * 16) + J) = crc(0)) then
                            crc := '0' & crc(15 downto 1);
                        else
                            crc := '0' & crc(15 downto 1);
                            crc := crc xor x"8408";
                        end if;
                    end loop;
                end loop; 
                -- Check CRC
                if (crc = data(15 downto 0)) then
                    tests(3) <= '1';
                else
                    tests(3) <= '0';
                end if;
                -- Check if the strips are hit
                if (data(143 downto 16) /= empty_128bits) then
                    hit <= '1';
                else
                    hit <= '0';
                end if;          
            end if;
        end if;
    end process;
    
    --================--
    --== Encoding ==--
    --================--             
    
    process(ref_clk_i)    
    begin
        if (rising_edge(ref_clk_i)) then 
            -- Reset & default values
            if (reset_i = '1') then
                tk_data_o <= (valid => '0', bc => (others => '0'), ec => (others => '0'), flags => (others => '0'), chip_id => (others => '0'), strips => (others => '0'), crc => (others => '0'), crc_ok => '0', hit => '0');
                lapse <= 0;
            else
                if (lapse = 0) then
                    -- Combine the tests and assert the packet if they are valid
                    case tests is
                        -- Valid CRC
                        when "1111" => 
                            tk_data_o <= (valid => '1', bc => data(188 downto 177), ec => data(172 downto 165), flags => data(164 downto 161), chip_id => data(156 downto 145), strips => data(144 downto 17), crc => data(16 downto 1), crc_ok => '1', hit => hit);
                            lapse <= 192;
                        -- Invalid CRC
                        when "0111" => 
                            -- Return data according to the system register
                            tk_data_o <= (valid => not remove_bad_crc_i, bc => data(188 downto 177), ec => data(172 downto 165), flags => data(164 downto 161), chip_id => data(156 downto 145), strips => data(144 downto 17), crc => data(16 downto 1), crc_ok => '0', hit => hit);
                            lapse <= 192;
                        -- No data
                        when others => 
                            tk_data_o.valid <= '0';
                    end case;   
                else
                    lapse <= lapse - 1;
                    tk_data_o.valid <= '0';
                end if;
            end if;
        end if;
    end process;
   
end Behavioral;