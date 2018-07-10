----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    13:13:21 03/12/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    optohybrid_top - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
-- Top Level of the design
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;
use work.wb_pkg.all;

entity optohybrid_top is
port(

    --== VFAT2s Control ==--
    
    vfat2_mclk_p_o          : out std_logic_vector(2 downto 0);
    vfat2_mclk_n_o          : out std_logic_vector(2 downto 0);
    
    vfat2_resb_o            : out std_logic_vector(2 downto 0);
    vfat2_resh_o            : out std_logic_vector(2 downto 0);
    
    vfat2_t1_p_o            : out std_logic_vector(2 downto 0);
    vfat2_t1_n_o            : out std_logic_vector(2 downto 0);
    
    vfat2_scl_o             : out std_logic_vector(5 downto 0);
    vfat2_sda_io            : inout std_logic_vector(5 downto 0);
    
    -- vfat2_daco_v_i          : in std_logic_vector(2 downto 0);
    -- vfat2_daco_i_i          : in std_logic_vector(2 downto 0);
    
    vfat2_data_valid_p_i    : in std_logic_vector(5 downto 0);
    vfat2_data_valid_n_i    : in std_logic_vector(5 downto 0);
    
    --== VFAT2s Data ==--
    
    vfat2_0_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_0_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_0_data_out_p_i    : in std_logic;
    vfat2_0_data_out_n_i    : in std_logic;

    vfat2_1_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_1_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_1_data_out_p_i    : in std_logic;
    vfat2_1_data_out_n_i    : in std_logic;

    vfat2_2_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_2_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_2_data_out_p_i    : in std_logic;
    vfat2_2_data_out_n_i    : in std_logic;

    vfat2_3_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_3_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_3_data_out_p_i    : in std_logic;
    vfat2_3_data_out_n_i    : in std_logic;

    vfat2_4_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_4_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_4_data_out_p_i    : in std_logic;
    vfat2_4_data_out_n_i    : in std_logic;

    vfat2_5_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_5_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_5_data_out_p_i    : in std_logic;
    vfat2_5_data_out_n_i    : in std_logic;

    vfat2_6_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_6_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_6_data_out_p_i    : in std_logic;
    vfat2_6_data_out_n_i    : in std_logic;

    vfat2_7_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_7_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_7_data_out_p_i    : in std_logic;
    vfat2_7_data_out_n_i    : in std_logic;

    vfat2_8_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_8_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_8_data_out_p_i    : in std_logic;
    vfat2_8_data_out_n_i    : in std_logic;

    vfat2_9_sbits_p_i       : in std_logic_vector(7 downto 0);
    vfat2_9_sbits_n_i       : in std_logic_vector(7 downto 0);
    vfat2_9_data_out_p_i    : in std_logic;
    vfat2_9_data_out_n_i    : in std_logic;

    vfat2_10_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_10_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_10_data_out_p_i   : in std_logic;
    vfat2_10_data_out_n_i   : in std_logic;
    
    vfat2_11_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_11_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_11_data_out_p_i   : in std_logic;
    vfat2_11_data_out_n_i   : in std_logic;

    vfat2_12_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_12_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_12_data_out_p_i   : in std_logic;
    vfat2_12_data_out_n_i   : in std_logic;

    vfat2_13_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_13_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_13_data_out_p_i   : in std_logic;
    vfat2_13_data_out_n_i   : in std_logic;

    vfat2_14_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_14_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_14_data_out_p_i   : in std_logic;
    vfat2_14_data_out_n_i   : in std_logic;

    vfat2_15_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_15_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_15_data_out_p_i   : in std_logic;
    vfat2_15_data_out_n_i   : in std_logic;

    vfat2_16_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_16_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_16_data_out_p_i   : in std_logic;
    vfat2_16_data_out_n_i   : in std_logic;

    vfat2_17_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_17_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_17_data_out_p_i   : in std_logic;
    vfat2_17_data_out_n_i   : in std_logic;

    vfat2_18_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_18_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_18_data_out_p_i   : in std_logic;
    vfat2_18_data_out_n_i   : in std_logic;

    vfat2_19_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_19_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_19_data_out_p_i   : in std_logic;
    vfat2_19_data_out_n_i   : in std_logic;

    vfat2_20_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_20_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_20_data_out_p_i   : in std_logic;
    vfat2_20_data_out_n_i   : in std_logic;

    vfat2_21_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_21_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_21_data_out_p_i   : in std_logic;
    vfat2_21_data_out_n_i   : in std_logic;

    vfat2_22_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_22_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_22_data_out_p_i   : in std_logic;
    vfat2_22_data_out_n_i   : in std_logic;

    vfat2_23_sbits_p_i      : in std_logic_vector(7 downto 0);
    vfat2_23_sbits_n_i      : in std_logic_vector(7 downto 0);
    vfat2_23_data_out_p_i   : in std_logic;
    vfat2_23_data_out_n_i   : in std_logic;
    
    --== Memory ==--
    
--    multiboot_rs_o          : out std_logic_vector(1 downto 0);
    
--    flash_address_o         : out std_logic_vector(22 downto 0);
--    flash_data_io           : inout std_logic_vector(15 downto 0);
--    flash_chip_enable_b_o   : out std_logic;
--    flash_out_enable_b_o    : out std_logic;
--    flash_write_enable_b_o  : out std_logic;
--    flash_latch_enable_b_o  : out std_logic;
    
    --== Clocking ==--
    
    clk_50MHz_i             : in std_logic;

    qpll_ref_40MHz_o        : out std_logic;
    qpll_reset_o            : out std_logic;
    qpll_locked_i           : in std_logic;
    qpll_error_i            : in std_logic;
    qpll_clk_p_i            : in std_logic;
    qpll_clk_n_i            : in std_logic;
    
    cdce_clk_p_i            : in std_logic;
    cdce_clk_n_i            : in std_logic;
    cdce_clk_pri_p_o        : out std_logic;
    cdce_clk_pri_n_o        : out std_logic;
    cdce_aux_out_o          : out std_logic;
    cdce_aux_in_i           : in std_logic;
    cdce_ref_o              : out std_logic;
    cdce_pwrdown_o          : out std_logic;
    cdce_sync_o             : out std_logic;
    cdce_locked_i           : in std_logic;
    cdce_sck_o              : out std_logic;
    cdce_mosi_o             : out std_logic;
    cdce_le_o               : out std_logic;
    cdce_miso_i             : in std_logic;
    
    --== Miscellaneous ==--
    
    ext_clk_i               : in std_logic;
    ext_trigger_i           : in std_logic;
    ext_sbits_o             : out std_logic_vector(5 downto 0);
    
    --== GTX ==--
    
    mgt_clk_p_i             : in std_logic;
    mgt_clk_n_i             : in std_logic;

    mgt_rx_p_i              : in std_logic_vector(0 downto 0); -- 0 = Tracking and control
    mgt_rx_n_i              : in std_logic_vector(0 downto 0); -- 1 to 4 = trigger links
    mgt_tx_p_o              : out std_logic_vector(0 downto 0);
    mgt_tx_n_o              : out std_logic_vector(0 downto 0)

);
end optohybrid_top;

architecture Behavioral of optohybrid_top is

    --== Buffers ==--
    
    signal vfat2_mclk_b         : std_logic; 
    signal vfat2_reset_b        : std_logic;
    signal vfat2_t1_b           : std_logic;
    signal vfat2_scl_b          : std_logic_vector(5 downto 0); 
    signal vfat2_sda_mosi_b     : std_logic_vector(5 downto 0); 
    signal vfat2_sda_miso_b     : std_logic_vector(5 downto 0); 
    signal vfat2_sda_tri_b      : std_logic_vector(5 downto 0); 
    signal vfat2_data_valid_b   : std_logic_vector(5 downto 0);
    signal vfat2_data_out_b     : std_logic_vector(23 downto 0);
    signal vfat2_sbits_b        : sbits_array_t(23 downto 0);    
    
    signal qpll_ref_40MHz_b     : std_logic;
    signal qpll_reset_b         : std_logic;
    signal qpll_locked_b        : std_logic;
    signal qpll_error_b         : std_logic;
    signal qpll_clk_b           : std_logic;
 
    signal cdce_clk_b           : std_logic;
    signal cdce_clk_pri_b       : std_logic;
    signal cdce_aux_out_b       : std_logic;
    signal cdce_aux_in_b        : std_logic;
    signal cdce_ref_b           : std_logic;
    signal cdce_pwrdown_b       : std_logic;
    signal cdce_sync_b          : std_logic;
    signal cdce_locked_b        : std_logic;
    signal cdce_sck_b           : std_logic;
    signal cdce_mosi_b          : std_logic;
    signal cdce_le_b            : std_logic;
    signal cdce_miso_b          : std_logic;  
    
    --== Global signals ==--

    signal ref_clk              : std_logic;
    signal clk_1x               : std_logic;
    signal clk_2x               : std_logic;
    signal clk_4x               : std_logic;
    signal clk_8x               : std_logic;

    signal reset                : std_logic;    

    signal rec_pll_locked       : std_logic;    
    signal fpga_pll_locked      : std_logic;    
    signal clk_switch_mode      : std_logic;    

    --== GTX ==--
    
    signal gtx_tx_clk           : std_logic;
    signal gtx_rx_clk           : std_logic;
    signal gtx_tk_error         : std_logic;
    signal gtx_tr_error         : std_logic;
    signal gtx_evt_sent         : std_logic;
    
    signal gtx_tx_kchar         : std_logic_vector(1 downto 0);
    signal gtx_tx_data          : std_logic_vector(15 downto 0);
    signal gtx_rx_kchar         : std_logic_vector(1 downto 0);
    signal gtx_rx_data          : std_logic_vector(15 downto 0);
    signal gtx_rx_error         : std_logic_vector(0 downto 0);
    
    --== VFAT2 ==--
    
    signal vfat2_t1             : t1_array_t(5 downto 0); -- 0 = GTX, 1 = Internal, 2 = External, 3 = loop, 4 = Muxed, 5 = GBT (for backwards compatibility put at the end)
    signal vfat2_tk_data        : tk_data_array_t(23 downto 0);
    
    --== SEM ==--
    signal sem_correction       : std_logic;
    signal sem_critical         : std_logic;
    
    --== System ==--
    
    signal vfat2_tk_mask        : std_logic_vector(23 downto 0);
    signal vfat2_t1_sel         : std_logic_vector(2 downto 0);
    signal sys_loop_sbit        : std_logic_vector(4 downto 0);
    signal vfat2_reset          : std_logic;
    signal vfat2_sbit_mask      : std_logic_vector(23 downto 0);
    signal sys_sbit_sel         : std_logic_vector(29 downto 0);
    signal trigger_lim          : std_logic_vector(31 downto 0);
    signal zero_suppress        : std_logic;
    signal sys_sbit_mode        : std_logic_vector(1 downto 0);
    signal clk_source           : std_logic;
    signal remove_bad_crc       : std_logic;
    
    --== Wishbone signals ==--
    
    signal wb_m_req             : wb_req_array_t((WB_MASTERS - 1) downto 0);
    signal wb_m_res             : wb_res_array_t((WB_MASTERS - 1) downto 0);
    signal wb_s_req             : wb_req_array_t((WB_SLAVES - 1) downto 0);
    signal wb_s_res             : wb_res_array_t((WB_SLAVES - 1) downto 0);
        
begin

    reset <= '0';    
    
    --==============--
    --== Clocking ==--
    --==============--
    
    clocking_inst : entity work.clocking
    port map(
        reset_i             => reset,
        clk_source_i        => clk_source,
        cdce_pll_locked_i   => cdce_locked_b,
        
        fpga_pll_locked_o   => fpga_pll_locked,
        rec_pll_locked_o    => rec_pll_locked,
        switch_mode_o       => clk_switch_mode,
        
        clk_50MHz_i         => clk_50MHz_i,
        clk_gtx_rec_i       => gtx_rx_clk,
        
        ref_clk_o           => ref_clk,
        clk_1x_o            => clk_1x,
        clk_2x_o            => clk_2x,
        clk_4x_o            => clk_4x,
        clk_8x_o            => clk_8x
    );   
        
    --==========--
    --== CDCE ==--
    --==========--
    
    -- This module controls the CDCE.
    
    cdce_inst : entity work.cdce 
    port map(
		ref_clk_i       => ref_clk,
        cdce_clk_i      => cdce_clk_b,
        cdce_clk_pri_o  => cdce_clk_pri_b,
        cdce_aux_out_o  => cdce_aux_out_b,
        cdce_aux_in_i   => cdce_aux_in_b,
        cdce_ref_o      => cdce_ref_b,
        cdce_pwrdown_o  => cdce_pwrdown_b,
        cdce_sync_o     => cdce_sync_b,
        cdce_locked_i   => cdce_locked_b,
        cdce_sck_o      => cdce_sck_b,
        cdce_mosi_o     => cdce_mosi_b,
        cdce_le_o       => cdce_le_b,
        cdce_miso_i     => cdce_miso_b
	);
    
    --======================--
    --== External signals ==--
    --======================--   

    -- This module handles the external signals: the input trigger and the output SBits.
    
    external_inst : entity work.external
    port map(
        ref_clk_i           => ref_clk,
        reset_i             => reset,
        ext_trigger_i       => ext_trigger_i,
        vfat2_t1_o          => vfat2_t1(2),
        vfat2_sbits_i       => vfat2_sbits_b,
        vfat2_sbit_mask_i   => vfat2_sbit_mask,
        sys_sbit_mode_i     => sys_sbit_mode,
        sys_sbit_sel_i      => sys_sbit_sel,
        ext_sbits_o         => ext_sbits_o        
    );
    
    --=====================--
    --== Wishbone switch ==--
    --=====================--
    
    -- This module is the Wishbone switch which redirects requests from the masters to the slaves.
    
    wb_switch_inst : entity work.wb_switch
    port map(
        ref_clk_i   => ref_clk,
        reset_i     => reset,
        wb_req_i    => wb_m_req,
        wb_req_o    => wb_s_req,
        wb_res_i    => wb_s_res,
        wb_res_o    => wb_m_res
    );

    --=========--
    --== GTX ==--
    --=========--
    
    -- This module controls the PHY of the GTX. It contains low-level functions that control the quality of the 
    -- link and perform the resets.
    
    gtx_inst : entity work.gtx
    port map(
        ref_clk_i      => ref_clk,
        reset_i        => reset,
        
        mgt_refclk_n_i => mgt_clk_n_i,
        mgt_refclk_p_i => mgt_clk_p_i,
        tx_clk_o       => gtx_tx_clk,
        rx_clk_o       => gtx_rx_clk,
        
        rx_n_i         => mgt_rx_n_i(0 downto 0),
        rx_p_i         => mgt_rx_p_i(0 downto 0),
        tx_n_o         => mgt_tx_n_o(0 downto 0),
        tx_p_o         => mgt_tx_p_o(0 downto 0),
        tx_kchar_i     => gtx_tx_kchar,
        tx_data_i      => gtx_tx_data,
        rx_kchar_o     => gtx_rx_kchar,
        rx_data_o      => gtx_rx_data,
        rx_error_o     => gtx_rx_error
    );
    
    -- This module controls the DATA of the GTX. It formats data packets to be sent over the optical link.

    gtx_link_inst : entity work.gtx_link
    port map(
        ref_clk_i       => ref_clk,
        tx_clk_i        => gtx_tx_clk,
        rx_clk_i        => gtx_rx_clk,
        reset_i         => reset,
        
        gtx_tx_kchar_o  => gtx_tx_kchar,
        gtx_tx_data_o   => gtx_tx_data,
        gtx_rx_kchar_i  => gtx_rx_kchar,
        gtx_rx_data_i   => gtx_rx_data,
        gtx_rx_error_i  => gtx_rx_error,        
        
        wb_mst_req_o    => wb_m_req(WB_MST_GTX),
        wb_mst_res_i    => wb_m_res(WB_MST_GTX),
        vfat2_tk_data_i => vfat2_tk_data,
        vfat2_tk_mask_i => vfat2_tk_mask,
        zero_suppress_i => zero_suppress,
        vfat2_t1_i      => vfat2_t1(4),
        vfat2_t1_o      => vfat2_t1(0), 
        tk_error_o      => gtx_tk_error,
        tr_error_o      => gtx_tr_error,
        evt_sent_o      => gtx_evt_sent   
    );

    --=============--
    --== Trigger ==--
    --=============--
    
    -- This module controls the trigger source. 
    
    trigger_inst : entity work.trigger
    port map(
        ref_clk_i       => ref_clk,
        reset_i         => reset,
        vfat2_sbits_i   => vfat2_sbits_b,
        vfat2_t1_sel_i  => vfat2_t1_sel,
        sys_loop_sbit_i => sys_loop_sbit,
        trigger_lim_i   => trigger_lim,
        vfat2_t1_gtx_i  => vfat2_t1(0),    
        vfat2_t1_gbt_i  => vfat2_t1(5), 
        vfat2_t1_int_i  => vfat2_t1(1),
        vfat2_t1_ext_i  => vfat2_t1(2),
        vfat2_t1_loop_o => vfat2_t1(3),
        vfat2_t1_mux_o  => vfat2_t1(4)
    );

    --===========--
    --== VFAT2 ==--
    --===========--
    
    -- This module controls the low-level VFAT2 functionnalities.
        
    vfat2_inst : entity work.vfat2      
    port map(        
        ref_clk_i           => ref_clk,
        clk_4x_i            => clk_4x,
        reset_i             => reset,
        vfat2_reset_i       => vfat2_reset,
        vfat2_t1_i          => vfat2_t1(4),
        vfat2_mclk_o        => vfat2_mclk_b,
        vfat2_reset_o       => vfat2_reset_b,
        vfat2_t1_o          => vfat2_t1_b,
        remove_bad_crc_i    => remove_bad_crc,
        vfat2_data_out_i    => vfat2_data_out_b,
        vfat2_tk_data_o     => vfat2_tk_data,
        wb_slv_i2c_req_i    => wb_s_req(WB_SLV_I2C_5 downto WB_SLV_I2C_0),
        wb_slv_i2c_res_o    => wb_s_res(WB_SLV_I2C_5 downto WB_SLV_I2C_0),
        vfat2_scl_o         => vfat2_scl_b,
        vfat2_sda_miso_i    => vfat2_sda_miso_b,
        vfat2_sda_mosi_o    => vfat2_sda_mosi_b,
        vfat2_sda_tri_o     => vfat2_sda_tri_b
    );    

    --=====================--
    --== Functionalities ==--
    --=====================--
    
    -- This modules controls the high-level VFAT2 functionnalities.
        
    func_inst : entity work.func      
    port map(        
        ref_clk_i           => ref_clk,
        reset_i             => reset,
        wb_slv_ei2c_req_i   => wb_s_req(WB_SLV_EI2C),
        wb_slv_ei2c_res_o   => wb_s_res(WB_SLV_EI2C),
        wb_mst_ei2c_req_o   => wb_m_req(WB_MST_EI2C),
        wb_mst_ei2c_res_i   => wb_m_res(WB_MST_EI2C),
        wb_slv_scan_req_i   => wb_s_req(WB_SLV_SCAN),
        wb_slv_scan_res_o   => wb_s_res(WB_SLV_SCAN),
        wb_mst_scan_req_o   => wb_m_req(WB_MST_SCAN),
        wb_mst_scan_res_i   => wb_m_res(WB_MST_SCAN),
        wb_slv_uscan_req_i  => wb_s_req(WB_SLV_USCAN),
        wb_slv_uscan_res_o  => wb_s_res(WB_SLV_USCAN),
        wb_mst_uscan_req_o  => wb_m_req(WB_MST_USCAN),
        wb_mst_uscan_res_i  => wb_m_res(WB_MST_USCAN),
        wb_slv_t1_req_i     => wb_s_req(WB_SLV_T1),
        wb_slv_t1_res_o     => wb_s_res(WB_SLV_T1),
        wb_slv_dac_req_i    => wb_s_req(WB_SLV_DAC),
        wb_slv_dac_res_o    => wb_s_res(WB_SLV_DAC),
        wb_mst_dac_req_o    => wb_m_req(WB_MST_DAC),
        wb_mst_dac_res_i    => wb_m_res(WB_MST_DAC),
        vfat2_tk_data_i     => vfat2_tk_data,
        vfat2_sbits_i       => vfat2_sbits_b,
        vfat2_t1_o          => vfat2_t1(1)
    );    
    
    --=========--
    --== SEM ==--
    --=========--
    
    sem_mon_inst : entity work.sem_mon
    port map(
        clk_i               => ref_clk,
        heartbeat_o         => open,
        initialization_o    => open,
        observation_o       => open,
        correction_o        => sem_correction,
        classification_o    => open,
        injection_o         => open,
        essential_o         => open,
        uncorrectable_o     => sem_critical
    );   
            
    --==============--
    --== Counters ==--
    --==============--
    
    -- This module implements a multitude of counters.
    
    counters_inst : entity work.counters
    port map(
        ref_clk_i           => ref_clk,
        gtx_clk_i           => gtx_rx_clk,
        reset_i             => reset, 
        wb_slv_req_i        => wb_s_req(WB_SLV_CNT),
        wb_slv_res_o        => wb_s_res(WB_SLV_CNT),
        wb_m_req_i          => wb_m_req,      
        wb_m_res_i          => wb_m_res,
        wb_s_req_i          => wb_s_req,
        wb_s_res_i          => wb_s_res,
        vfat2_tk_data_i     => vfat2_tk_data,
        vfat2_t1_i          => vfat2_t1,
        gtx_tk_error_i      => gtx_tk_error,
        gtx_tr_error_i      => gtx_tr_error,
        gtx_evt_sent_i      => gtx_evt_sent,        
        gbt_link_error_i    => '0',  
        gbt_evt_sent_i      => '0',  
        qpll_locked_i       => rec_pll_locked,
        qpll_pll_locked_i   => clk_switch_mode,        
        vfat2_sbits_i       => vfat2_sbits_b,
        sem_correction_i    => sem_correction
    );
    
    --============--
    --== System ==--
    --============--
    
    -- This module holds the system registers that define the behaviour of the OH.
    
    sys_inst : entity work.sys
    port map(
        ref_clk_i           => ref_clk,
        reset_i             => reset, 
        wb_slv_req_i        => wb_s_req(WB_SLV_SYS),
        wb_slv_res_o        => wb_s_res(WB_SLV_SYS),  
        vfat2_tk_mask_o     => vfat2_tk_mask,
        vfat2_t1_sel_o      => vfat2_t1_sel,
        sys_loop_sbit_o     => sys_loop_sbit,
        vfat2_reset_o       => vfat2_reset,
        vfat2_sbit_mask_o   => vfat2_sbit_mask,
        sys_sbit_sel_o      => sys_sbit_sel,
        trigger_lim_o       => trigger_lim,
        zero_suppress_o     => zero_suppress,
        sys_sbit_mode_o     => sys_sbit_mode,
        clk_source_o        => clk_source,
        remove_bad_crc_o    => remove_bad_crc
    );
    
    --============--
    --== Status ==--
    --============--
    
    -- This module holds the status registers that describe the state of the OH.
    
    stat_inst : entity work.stat
    port map(
        ref_clk_i           => ref_clk,
        reset_i             => reset, 
        wb_slv_req_i        => wb_s_req(WB_SLV_STAT),
        wb_slv_res_o        => wb_s_res(WB_SLV_STAT), 
        qpll_locked_i       => rec_pll_locked,
        qpll_pll_locked_i   => clk_switch_mode,
        sem_critical_i      => sem_critical
    );
	 
	 --=========--
	 --== TDC ==--
	 --=========--
	 
	 tdc_wrapper_ohv2a_inst : entity work.tdc_wrapper_ohv2a
	 port map(
        ref_clk_i => ref_clk,
        clk_8x_i  => clk_8x,
		  
        wb_slv_req_i => wb_s_req(WB_SLV_TDC),
        wb_slv_res_o => wb_s_res(WB_SLV_TDC),
		  
        trigger_i   => ext_trigger_i,
        sbits_i     => vfat2_sbits_b,
        sbit_mask_i => vfat2_sbit_mask
    );
    
    --=============--
    --== Buffers ==--
    --=============--
    
    -- This module implements all the required buffers on the FPGA. 
    -- Nothing to see below here.
    
    buffers_inst: entity work.buffers 
    port map(
        -- VFAT2
        vfat2_mclk_p_o          => vfat2_mclk_p_o,
        vfat2_mclk_n_o          => vfat2_mclk_n_o,
        vfat2_resb_o            => vfat2_resb_o,
        vfat2_resh_o            => vfat2_resh_o,
        vfat2_t1_p_o            => vfat2_t1_p_o,
        vfat2_t1_n_o            => vfat2_t1_n_o,
        vfat2_scl_o             => vfat2_scl_o,
        vfat2_sda_io            => vfat2_sda_io,
        vfat2_data_valid_p_i    => vfat2_data_valid_p_i,
        vfat2_data_valid_n_i    => vfat2_data_valid_n_i,
        vfat2_0_sbits_p_i       => vfat2_0_sbits_p_i,
        vfat2_0_sbits_n_i       => vfat2_0_sbits_n_i,
        vfat2_0_data_out_p_i    => vfat2_0_data_out_p_i,
        vfat2_0_data_out_n_i    => vfat2_0_data_out_n_i,
        vfat2_1_sbits_p_i       => vfat2_1_sbits_p_i,
        vfat2_1_sbits_n_i       => vfat2_1_sbits_n_i,
        vfat2_1_data_out_p_i    => vfat2_1_data_out_p_i,
        vfat2_1_data_out_n_i    => vfat2_1_data_out_n_i,
        vfat2_2_sbits_p_i       => vfat2_2_sbits_p_i,
        vfat2_2_sbits_n_i       => vfat2_2_sbits_n_i,
        vfat2_2_data_out_p_i    => vfat2_2_data_out_p_i,
        vfat2_2_data_out_n_i    => vfat2_2_data_out_n_i,
        vfat2_3_sbits_p_i       => vfat2_3_sbits_p_i,
        vfat2_3_sbits_n_i       => vfat2_3_sbits_n_i,
        vfat2_3_data_out_p_i    => vfat2_3_data_out_p_i,
        vfat2_3_data_out_n_i    => vfat2_3_data_out_n_i,
        vfat2_4_sbits_p_i       => vfat2_4_sbits_p_i,
        vfat2_4_sbits_n_i       => vfat2_4_sbits_n_i,
        vfat2_4_data_out_p_i    => vfat2_4_data_out_p_i,
        vfat2_4_data_out_n_i    => vfat2_4_data_out_n_i,
        vfat2_5_sbits_p_i       => vfat2_5_sbits_p_i,
        vfat2_5_sbits_n_i       => vfat2_5_sbits_n_i,
        vfat2_5_data_out_p_i    => vfat2_5_data_out_p_i,
        vfat2_5_data_out_n_i    => vfat2_5_data_out_n_i,
        vfat2_6_sbits_p_i       => vfat2_6_sbits_p_i,
        vfat2_6_sbits_n_i       => vfat2_6_sbits_n_i,
        vfat2_6_data_out_p_i    => vfat2_6_data_out_p_i,
        vfat2_6_data_out_n_i    => vfat2_6_data_out_n_i,
        vfat2_7_sbits_p_i       => vfat2_7_sbits_p_i,
        vfat2_7_sbits_n_i       => vfat2_7_sbits_n_i,
        vfat2_7_data_out_p_i    => vfat2_7_data_out_p_i,
        vfat2_7_data_out_n_i    => vfat2_7_data_out_n_i,
        vfat2_8_sbits_p_i       => vfat2_8_sbits_p_i,
        vfat2_8_sbits_n_i       => vfat2_8_sbits_n_i,
        vfat2_8_data_out_p_i    => vfat2_8_data_out_p_i,
        vfat2_8_data_out_n_i    => vfat2_8_data_out_n_i,
        vfat2_9_sbits_p_i       => vfat2_9_sbits_p_i,
        vfat2_9_sbits_n_i       => vfat2_9_sbits_n_i,
        vfat2_9_data_out_p_i    => vfat2_9_data_out_p_i,
        vfat2_9_data_out_n_i    => vfat2_9_data_out_n_i,
        vfat2_10_sbits_p_i      => vfat2_10_sbits_p_i,
        vfat2_10_sbits_n_i      => vfat2_10_sbits_n_i,
        vfat2_10_data_out_p_i   => vfat2_10_data_out_p_i,
        vfat2_10_data_out_n_i   => vfat2_10_data_out_n_i,
        vfat2_11_sbits_p_i      => vfat2_11_sbits_p_i,
        vfat2_11_sbits_n_i      => vfat2_11_sbits_n_i,
        vfat2_11_data_out_p_i   => vfat2_11_data_out_p_i,
        vfat2_11_data_out_n_i   => vfat2_11_data_out_n_i,
        vfat2_12_sbits_p_i      => vfat2_12_sbits_p_i,
        vfat2_12_sbits_n_i      => vfat2_12_sbits_n_i,
        vfat2_12_data_out_p_i   => vfat2_12_data_out_p_i,
        vfat2_12_data_out_n_i   => vfat2_12_data_out_n_i,
        vfat2_13_sbits_p_i      => vfat2_13_sbits_p_i,
        vfat2_13_sbits_n_i      => vfat2_13_sbits_n_i,
        vfat2_13_data_out_p_i   => vfat2_13_data_out_p_i,
        vfat2_13_data_out_n_i   => vfat2_13_data_out_n_i,
        vfat2_14_sbits_p_i      => vfat2_14_sbits_p_i,
        vfat2_14_sbits_n_i      => vfat2_14_sbits_n_i,
        vfat2_14_data_out_p_i   => vfat2_14_data_out_p_i,
        vfat2_14_data_out_n_i   => vfat2_14_data_out_n_i,
        vfat2_15_sbits_p_i      => vfat2_15_sbits_p_i,
        vfat2_15_sbits_n_i      => vfat2_15_sbits_n_i,
        vfat2_15_data_out_p_i   => vfat2_15_data_out_p_i,
        vfat2_15_data_out_n_i   => vfat2_15_data_out_n_i,
        vfat2_16_sbits_p_i      => vfat2_16_sbits_p_i,
        vfat2_16_sbits_n_i      => vfat2_16_sbits_n_i,
        vfat2_16_data_out_p_i   => vfat2_16_data_out_p_i,
        vfat2_16_data_out_n_i   => vfat2_16_data_out_n_i,
        vfat2_17_sbits_p_i      => vfat2_17_sbits_p_i,
        vfat2_17_sbits_n_i      => vfat2_17_sbits_n_i,
        vfat2_17_data_out_p_i   => vfat2_17_data_out_p_i,
        vfat2_17_data_out_n_i   => vfat2_17_data_out_n_i,
        vfat2_18_sbits_p_i      => vfat2_18_sbits_p_i,
        vfat2_18_sbits_n_i      => vfat2_18_sbits_n_i,
        vfat2_18_data_out_p_i   => vfat2_18_data_out_p_i,
        vfat2_18_data_out_n_i   => vfat2_18_data_out_n_i,
        vfat2_19_sbits_p_i      => vfat2_19_sbits_p_i,
        vfat2_19_sbits_n_i      => vfat2_19_sbits_n_i,
        vfat2_19_data_out_p_i   => vfat2_19_data_out_p_i,
        vfat2_19_data_out_n_i   => vfat2_19_data_out_n_i,
        vfat2_20_sbits_p_i      => vfat2_20_sbits_p_i,
        vfat2_20_sbits_n_i      => vfat2_20_sbits_n_i,
        vfat2_20_data_out_p_i   => vfat2_20_data_out_p_i,
        vfat2_20_data_out_n_i   => vfat2_20_data_out_n_i,
        vfat2_21_sbits_p_i      => vfat2_21_sbits_p_i,
        vfat2_21_sbits_n_i      => vfat2_21_sbits_n_i,
        vfat2_21_data_out_p_i   => vfat2_21_data_out_p_i,
        vfat2_21_data_out_n_i   => vfat2_21_data_out_n_i,
        vfat2_22_sbits_p_i      => vfat2_22_sbits_p_i,
        vfat2_22_sbits_n_i      => vfat2_22_sbits_n_i,
        vfat2_22_data_out_p_i   => vfat2_22_data_out_p_i,
        vfat2_22_data_out_n_i   => vfat2_22_data_out_n_i,
        vfat2_23_sbits_p_i      => vfat2_23_sbits_p_i,
        vfat2_23_sbits_n_i      => vfat2_23_sbits_n_i,
        vfat2_23_data_out_p_i   => vfat2_23_data_out_p_i,
        vfat2_23_data_out_n_i   => vfat2_23_data_out_n_i,
        --
        vfat2_mclk_i            => vfat2_mclk_b,
        vfat2_reset_i           => vfat2_reset_b,
        vfat2_t1_i              => vfat2_t1_b,
        vfat2_scl_i             => vfat2_scl_b,
        vfat2_sda_miso_o        => vfat2_sda_miso_b, 
        vfat2_sda_mosi_i        => vfat2_sda_mosi_b,
        vfat2_sda_tri_i         => vfat2_sda_tri_b,
        vfat2_data_valid_o      => vfat2_data_valid_b,
        vfat2_data_out_o        => vfat2_data_out_b,
        vfat2_sbits_o           => vfat2_sbits_b,
        -- QPLL
        qpll_ref_40MHz_o        => qpll_ref_40MHz_o,
        qpll_reset_o            => qpll_reset_o,
        qpll_locked_i           => qpll_locked_i,
        qpll_error_i            => qpll_error_i,
        qpll_clk_p_i            => qpll_clk_p_i,
        qpll_clk_n_i            => qpll_clk_n_i,
        --
        qpll_ref_40MHz_i        => qpll_ref_40MHz_b,
        qpll_reset_i            => qpll_reset_b,
        qpll_locked_o           => qpll_locked_b,
        qpll_error_o            => qpll_error_b,
        qpll_clk_o              => qpll_clk_b,
        -- CDCE
        cdce_clk_p_i            => cdce_clk_p_i,
        cdce_clk_n_i            => cdce_clk_n_i,
        cdce_clk_pri_p_o        => cdce_clk_pri_p_o,
        cdce_clk_pri_n_o        => cdce_clk_pri_n_o,
        cdce_aux_out_o          => cdce_aux_out_o,
        cdce_aux_in_i           => cdce_aux_in_i,
        cdce_ref_o              => cdce_ref_o,
        cdce_pwrdown_o          => cdce_pwrdown_o,
        cdce_sync_o             => cdce_sync_o,
        cdce_locked_i           => cdce_locked_i,
        cdce_sck_o              => cdce_sck_o,
        cdce_mosi_o             => cdce_mosi_o,
        cdce_le_o               => cdce_le_o,
        cdce_miso_i             => cdce_miso_i,
        -- 
        cdce_clk_o              => cdce_clk_b,
        cdce_clk_pri_i          => cdce_clk_pri_b,
        cdce_aux_out_i          => cdce_aux_out_b,
        cdce_aux_in_o           => cdce_aux_in_b,
        cdce_ref_i              => cdce_ref_b,
        cdce_pwrdown_i          => cdce_pwrdown_b,
        cdce_sync_i             => cdce_sync_b,
        cdce_locked_o           => cdce_locked_b,
        cdce_sck_i              => cdce_sck_b,
        cdce_mosi_i             => cdce_mosi_b,
        cdce_le_i               => cdce_le_b,
        cdce_miso_o             => cdce_miso_b
    );
 
end Behavioral;
