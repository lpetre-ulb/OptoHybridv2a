----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
--
-- Create Date:    08:37:33 07/07/2015
-- Design Name:    OptoHybrid v2
-- Module Name:    gtx - Behavioral
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description:
--
-- This entity controls the PHY level of the GTX.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.types_pkg.all;

entity gtx is
port(

    -- Controls
    ref_clk_i       : in std_logic;
    reset_i         : in std_logic;

    -- Clocks
    mgt_refclk_n_i  : in std_logic;
    mgt_refclk_p_i  : in std_logic;

    tx_clk_o        : out std_logic;
    rx_clk_o        : out std_logic; 

    -- Data
    rx_n_i          : in  std_logic_vector(0 downto 0);
    rx_p_i          : in  std_logic_vector(0 downto 0);
    tx_n_o          : out std_logic_vector(0 downto 0);
    tx_p_o          : out std_logic_vector(0 downto 0);
    
    tx_kchar_i      : in std_logic_vector(1 downto 0);
    tx_data_i       : in std_logic_vector(15 downto 0);
    rx_kchar_o      : out std_logic_vector(1 downto 0);
    rx_data_o       : out std_logic_vector(15 downto 0);
    rx_error_o      : out std_logic_vector(0 downto 0)
    
);
end gtx;

architecture Behavioral of gtx is

    -- Controls
    signal mgt_reset        : std_logic;
    signal mgt_rst_cnt      : integer range 0 to 67_108_863;
    
    -- Clocks
    signal mgt_refclk       : std_logic;
    signal tx_clk, tx_clk_b : std_logic;
    signal rx_clk, rx_clk_b : std_logic;
    
    signal rx_disperr       : std_logic_vector(1 downto 0);
    signal rx_notintable    : std_logic_vector(1 downto 0);

begin

    ibufds_gtxe1_inst : IBUFDS_GTXE1
    port map(
        o       => mgt_refclk,
        odiv2   => open,
        ceb     => '0',
        i       => mgt_refclk_p_i,
        ib      => mgt_refclk_n_i
    );

    tx_clk_bufg : BUFG
    port map(
        i => tx_clk,
        o => tx_clk_b
    );
    tx_clk_o <= tx_clk_b;
    
    rx_clk_bufg : BUFG
    port map(
        i => rx_clk,
        o => rx_clk_b
    );
    rx_clk_o <= rx_clk_b;

    sfp_gtx_inst : entity work.sfp_gtx
    port map(
        GTX0_RXCHARISK_OUT          => rx_kchar_o(1 downto 0),
        GTX0_RXDISPERR_OUT          => rx_disperr(1 downto 0),
        GTX0_RXNOTINTABLE_OUT       => rx_notintable(1 downto 0),
        GTX0_RXBYTEISALIGNED_OUT    => open,
        GTX0_RXCOMMADET_OUT         => open,
        GTX0_RXENMCOMMAALIGN_IN     => '1',
        GTX0_RXENPCOMMAALIGN_IN     => '1',
        GTX0_RXDATA_OUT             => rx_data_o(15 downto 0),
        GTX0_RXRECCLK_OUT           => rx_clk,
        GTX0_RXUSRCLK2_IN           => rx_clk_b,
        GTX0_RXN_IN                 => rx_n_i(0),
        GTX0_RXP_IN                 => rx_p_i(0),
        GTX0_GTXRXRESET_IN          => (mgt_reset or reset_i),
        GTX0_MGTREFCLKRX_IN         => mgt_refclk,
        GTX0_PLLRXRESET_IN          => reset_i,
        GTX0_RXPLLLKDET_OUT         => open,
        GTX0_RXRESETDONE_OUT        => open,
        GTX0_TXCHARISK_IN           => tx_kchar_i(1 downto 0),
        GTX0_TXDATA_IN              => tx_data_i(15 downto 0),
        GTX0_TXOUTCLK_OUT           => tx_clk,
        GTX0_TXUSRCLK2_IN           => tx_clk_b,
        GTX0_TXN_OUT                => tx_n_o(0),
        GTX0_TXP_OUT                => tx_p_o(0),
        GTX0_GTXTXRESET_IN          => (mgt_reset or reset_i),
        GTX0_TXRESETDONE_OUT        => open
    );
    
    rx_error_o(0) <= rx_disperr(0) or rx_disperr(1) or rx_notintable(0) or rx_notintable(1);
    
    --== Control Reset signal ==--
    
    process(ref_clk_i)
    begin
        if (rising_edge(ref_clk_i)) then
            if (mgt_rst_cnt = 60_000_000) then
              mgt_reset <= '0';
              mgt_rst_cnt <= 60_000_000;
            else
              mgt_reset <= '1';
              mgt_rst_cnt <= mgt_rst_cnt + 1;
            end if;
        end if;
    end process;
        
end Behavioral;
