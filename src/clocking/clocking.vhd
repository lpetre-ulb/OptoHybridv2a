----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    09:10:11 09/15/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    clocking - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.types_pkg.all;

entity clocking is
port(

    -- Controls
    reset_i             : in std_logic;
    clk_source_i        : in std_logic;
    cdce_pll_locked_i   : in std_logic;
    
    fpga_pll_locked_o   : out std_logic;
    rec_pll_locked_o    : out std_logic;
    switch_mode_o       : out std_logic;

    -- Input clocks
    clk_50MHz_i         : in std_logic;
    clk_gtx_rec_i       : in std_logic;

    -- Output clocks
    ref_clk_o           : out std_logic;
    clk_1x_o            : out std_logic;
    clk_2x_o            : out std_logic;
    clk_4x_o            : out std_logic;
	clk_8x_o            : out std_logic );

end clocking;

architecture Behavioral of clocking is

    signal clk_onboard      : std_logic;
    signal clk_rec          : std_logic;
    
    signal rec_pll_locked   : std_logic;

begin    
    
    --== Onboard PLL ==-- 
    
    pll_50MHz_inst : entity work.pll_50MHz
    port map(
        CLK_IN1  => clk_50MHz_i, 
        CLK_OUT1 => open,
        CLK_OUT2 => clk_onboard,
        LOCKED   => fpga_pll_locked_o );
    
    --== GTX PLL ==--
    
    gtx_rec_pll_inst : entity work.gtx_rec_pll
    port map(
        CLK_IN1     => clk_gtx_rec_i,
        CLK_OUT1    => clk_1x_o,
        CLK_OUT2    => clk_2x_o,
        CLK_OUT3    => clk_4x_o,
		CLK_OUT4    => clk_8x_o,
        CLK_OUT5    => clk_rec,
        LOCKED      => rec_pll_locked
    );
    rec_pll_locked_o <= rec_pll_locked;
    
    --== Clock mux ==--
    
    ref_clk_mux_inst : BUFGMUX_CTRL
    port map(
        I0 => clk_onboard,
        I1 => clk_rec,
        S  => rec_pll_locked,
        O  => ref_clk_o
    );
    switch_mode_o <= rec_pll_locked;
    
end Behavioral;
