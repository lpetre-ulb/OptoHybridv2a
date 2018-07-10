----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    08:44:34 08/18/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    stat - Behavioral 
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

entity stat is
generic(
    N               : integer := 5
);
port(

    ref_clk_i           : in std_logic;
    reset_i             : in std_logic;
    
    -- Wishbone slave
    wb_slv_req_i        : in wb_req_t;
    wb_slv_res_o        : out wb_res_t;
    
    -- QPLL
    qpll_locked_i       : in std_logic;
    qpll_pll_locked_i   : in std_logic;
    
    -- SEM
    sem_critical_i      : in std_logic
    
);
end stat;

architecture Behavioral of stat is
    
    -- Signals from the Wishbone Hub
    signal wb_stb       : std_logic_vector((N - 1) downto 0);
    signal wb_we        : std_logic;
    signal wb_addr      : std_logic_vector(31 downto 0);
    signal wb_data      : std_logic_vector(31 downto 0);
    
    -- Signals for the registers
    signal reg_ack      : std_logic_vector((N - 1) downto 0);
    signal reg_err      : std_logic_vector((N - 1) downto 0);
    signal reg_data     : std32_array_t((N - 1) downto 0);

begin

    --===============================--
    --== Wishbone request splitter ==--
    --===============================--

    wb_splitter_inst : entity work.wb_splitter
    generic map(
        SIZE        => N,
        OFFSET      => 0
    )
    port map(
        ref_clk_i   => ref_clk_i,
        reset_i     => reset_i,
        wb_req_i    => wb_slv_req_i,
        wb_res_o    => wb_slv_res_o,
        stb_o       => wb_stb,
        we_o        => wb_we,
        addr_o      => wb_addr,
        data_o      => wb_data,
        ack_i       => reg_ack,
        err_i       => reg_err,
        data_i      => reg_data
    );
        
    --========================--
    --== Automatic response ==--
    --========================--
    
    ack_err_loop : for I in 0 to (N - 1) generate
    begin
    
        reg_ack(I) <= wb_stb(I);
        reg_err(I) <= '0';
        
    end generate;
    
    --=============--
    --== Mapping ==--
    --=============--
    
    reg_data(0) <= x"20170321";
    
    reg_data(1) <= (0 => qpll_locked_i, others => '0');
    
    reg_data(2) <= (0 => qpll_pll_locked_i, others => '0');    
                    
    reg_data(3) <= x"0203000B"; -- A for GEB v2a, B for GEB v2b
    
    reg_data(4) <= (0 => sem_critical_i, others => '0');
    
end Behavioral;

