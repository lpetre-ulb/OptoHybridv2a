----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    12:59:03 09/30/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    external - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity external is
port(

    ref_clk_i           : in std_logic;
    reset_i             : in std_logic;
    
    -- Trigger
    ext_trigger_i       : in std_logic;
    vfat2_t1_o          : out t1_t;

    -- Sbits
    vfat2_sbits_i       : in sbits_array_t(23 downto 0);
    vfat2_sbit_mask_i   : in std_logic_vector(23 downto 0);
    sys_sbit_mode_i     : in std_logic_vector(1 downto 0);
    sys_sbit_sel_i      : in std_logic_vector(29 downto 0);
    ext_sbits_o         : out std_logic_vector(5 downto 0)
    
);
end external;

architecture Behavioral of external is

    signal last_trigger : std_logic;

    signal ors          : std_logic_vector(23 downto 0);
    signal eta_row      : std_logic_vector(7 downto 0);
    signal sector_row   : std_logic_vector(5 downto 0);

    signal sbits_sel    : int_array_t(5 downto 0);

begin

    --== Trigger ==--

    process(ref_clk_i)         
    begin
        if (rising_edge(ref_clk_i)) then
            if (reset_i = '1') then
                vfat2_t1_o <= (lv1a => '0', calpulse => '0', resync => '0', bc0 => '0');
            else
                vfat2_t1_o <= (lv1a => ((not last_trigger) and ext_trigger_i), calpulse => '0', resync => '0', bc0 => '0');
                last_trigger <= ext_trigger_i;
            end if;
        end if;
    end process;
    
    --== SBits output ==--
    
    or_loop : for I in 0 to 23 generate
    begin
        ors(I) <= (not vfat2_sbit_mask_i(I)) and (vfat2_sbits_i(I)(0) or vfat2_sbits_i(I)(1) or vfat2_sbits_i(I)(2) or vfat2_sbits_i(I)(3) or vfat2_sbits_i(I)(4) or vfat2_sbits_i(I)(5) or vfat2_sbits_i(I)(6) or vfat2_sbits_i(I)(7));
    end generate;
    
    eta_loop : for I in 0 to 7 generate
    begin
        eta_row(I) <= ors(I) or ors(8 + I) or ors(16 + I);
    end generate;
    
    sector_loop : for I in 0 to 5 generate
    begin
        sector_row(I) <= ors(I * 4) or ors(I * 4 + 1) or ors(I * 4 + 2) or ors(I * 4 + 3);
    end generate;
    
    sbits_sel_loop : for I in 0 to 5 generate
    begin
        sbits_sel(I) <= to_integer(unsigned(sys_sbit_sel_i((I * 5 + 4) downto (I * 5))));    
    end generate;
    
    ext_sel_loop : for I in 0 to 5 generate
    begin
        with sys_sbit_mode_i select ext_sbits_o(I) <=
            ors(sbits_sel(I)) when "00",
            eta_row(sbits_sel(I)) when "01",
            sector_row(I) when "10",
            '0' when "11";
    end generate;    
                   
end Behavioral;

