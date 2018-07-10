----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    08:37:33 07/07/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    link - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
-- This entity controls the DATA level of the GTX.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.types_pkg.all;

entity gtx_link is
port(

    -- Clocks
    ref_clk_i       : in std_logic; 
    tx_clk_i        : in std_logic;
    rx_clk_i        : in std_logic;
    reset_i         : in std_logic;    
    
    -- GTX lanes
    gtx_tx_kchar_o  : out std_logic_vector(1 downto 0);
    gtx_tx_data_o   : out std_logic_vector(15 downto 0);
    gtx_rx_kchar_i  : in std_logic_vector(1 downto 0);
    gtx_rx_data_i   : in std_logic_vector(15 downto 0);
    gtx_rx_error_i  : in std_logic_vector(0 downto 0);
    
    -- Ports
    wb_mst_req_o    : out wb_req_t;
    wb_mst_res_i    : in wb_res_t;
    
    vfat2_tk_data_i : in tk_data_array_t(23 downto 0);
    vfat2_tk_mask_i : in std_logic_vector(23 downto 0);
    zero_suppress_i : in std_logic;
    
    vfat2_t1_i      : in t1_t;
    vfat2_t1_o      : out t1_t;
    
    tk_error_o      : out std_logic;
    tr_error_o      : out std_logic;
    evt_sent_o      : out std_logic
    
);
end gtx_link;

architecture Behavioral of gtx_link is      
    
    --== GTX requests ==--
    
    signal g2o_req_en       : std_logic;
    signal g2o_req_data     : std_logic_vector(64 downto 0);    
    
    signal o2g_req_en       : std_logic;
    signal o2g_req_valid    : std_logic;
    signal o2g_req_data     : std_logic_vector(31 downto 0);
    
    --== VFAT2 event data ==--
    
    signal evt_en           : std_logic;
    signal evt_valid        : std_logic;
    signal evt_data         : std_logic_vector(223 downto 0);
    
begin    
    
    evt_sent_o <= evt_valid;
           
    --==========================--
    --== SFP RX Tracking link ==--
    --==========================--
       
    gtx_rx_tracking_inst : entity work.gtx_rx_tracking
    port map(
        gtx_clk_i   => rx_clk_i,
        reset_i     => reset_i,     
        vfat2_t1_o  => vfat2_t1_o,      
        req_en_o    => g2o_req_en,   
        req_data_o  => g2o_req_data,  
        tk_error_o  => tk_error_o,         
        rx_kchar_i  => gtx_rx_kchar_i(1 downto 0),   
        rx_data_i   => gtx_rx_data_i(15 downto 0)
    );
    
    --==========================--
    --== SFP TX Tracking link ==--
    --==========================--
       
    gtx_tx_tracking_inst : entity work.gtx_tx_tracking
    port map(
        gtx_clk_i   => tx_clk_i,
        reset_i     => reset_i,       
		req_en_o    => o2g_req_en,
		req_valid_i => o2g_req_valid,
		req_data_i  => o2g_req_data,
		evt_en_o    => evt_en,
		evt_valid_i => evt_valid,
		evt_data_i  => evt_data,
		tx_kchar_o  => gtx_tx_kchar_o(1 downto 0),  
		tx_data_o   => gtx_tx_data_o(15 downto 0)
	);
    
    --========================--
    --== Request forwarding ==--
    --========================--
    
    link_request_inst : entity work.link_request
    port map(
        ref_clk_i       => ref_clk_i,
        gtx_tx_clk_i    => tx_clk_i,
        gtx_rx_clk_i    => rx_clk_i,
        reset_i         => reset_i,
        wb_mst_req_o    => wb_mst_req_o,
        wb_mst_res_i    => wb_mst_res_i,       
        rx_en_i         => g2o_req_en,
        rx_data_i       => g2o_req_data,          
        tx_en_i         => o2g_req_en,
        tx_valid_o      => o2g_req_valid,
        tx_data_o       => o2g_req_data      
    );  
    
    --======================================--
    --== VFAT2 tracking data concentrator ==--
    --======================================--	
    
    link_tracking_inst : entity work.link_tracking 
    port map(
		ref_clk_i       => ref_clk_i,
		link_clk_i      => tx_clk_i,
		reset_i         => reset_i,
        vfat2_t1_i      => vfat2_t1_i,
		vfat2_tk_data_i => vfat2_tk_data_i,
        vfat2_tk_mask_i => vfat2_tk_mask_i,
        zero_suppress_i => zero_suppress_i,
		evt_en_i        => evt_en,
		evt_valid_o     => evt_valid,
		evt_data_o      => evt_data
	);  
    
end Behavioral;
