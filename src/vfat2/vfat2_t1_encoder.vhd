----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    11:22:49 06/30/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    vfat2_t1_encoder - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
-- Encodes the T1 commands for the VFAT2s on 3 consecutive bits. If two signals 
-- arrive with a delay less than 3 clock cycles, the second operation is ignored.
-- The priority is as follows: LV1A, Calpulse, Resync, BC0.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity vfat2_t1_encoder is
port(

    ref_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    -- Input T1 commands
    vfat2_t1_i      : in t1_t;
    
    -- VFAT2 T1 line
    vfat2_t1_o      : out std_logic
    
);
end vfat2_t1_encoder;

architecture Behavioral of vfat2_t1_encoder is
   
    type state_t is (IDLE, BIT_1, BIT_0);
    
    signal state    : state_t;
    
    -- Data to send
    signal t1_data  : std_logic_vector(1 downto 0);

begin

    process(ref_clk_i)
    begin    
        if (rising_edge(ref_clk_i)) then
            -- Reset & default values
            if (reset_i = '1') then
                vfat2_t1_o <= '0';
                state <= IDLE;
                t1_data <= (others => '0');
            else
                case state is
                    -- Wait for strobe
                    when IDLE =>
                        -- Set the line to 0
                        vfat2_t1_o <= '0';
                        -- LV1A
                        if (vfat2_t1_i.lv1a = '1') then
                            vfat2_t1_o <= '1';
                            state <= BIT_1;
                            t1_data <= "00";
                        -- Calibration pulse
                        elsif (vfat2_t1_i.calpulse = '1') then 
                            vfat2_t1_o <= '1';
                            state <= BIT_1;
                            t1_data <= "11";
                        -- Resync signal
                        elsif (vfat2_t1_i.resync = '1') then  
                            vfat2_t1_o <= '1';
                            state <= BIT_1;
                            t1_data <= "10";
                        -- BC0 reset
                        elsif (vfat2_t1_i.bc0 = '1') then 
                            vfat2_t1_o <= '1';
                            state <= BIT_1;
                            t1_data <= "01";
                        end if;  
                    -- Send bit 1
                    when BIT_1 =>
                        vfat2_t1_o <= t1_data(1);
                        state <= BIT_0;
                    -- Send bit 0
                    when BIT_0 =>
                        vfat2_t1_o <= t1_data(0);
                        state <= IDLE;
                    --
                    when others => 
                        vfat2_t1_o <= '0';
                        state <= IDLE;
                        t1_data <= (others => '0');
                end case;  
            end if;
        end if;
    end process;
    
end Behavioral;