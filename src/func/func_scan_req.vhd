----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    13:46:42 08/05/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    func_scan_req - Behavioral 
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
use work.wb_pkg.all;

entity func_scan_req is
port(

    ref_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    -- Request data
    req_stb_i       : in std_logic;
    req_mode_i      : in std_logic_vector(2 downto 0);
    req_vfat2_i     : in std_logic_vector(4 downto 0);
    req_channel_i   : in std_logic_vector(6 downto 0);
    req_min_i       : in std_logic_vector(7 downto 0);
    req_max_i       : in std_logic_vector(7 downto 0);
    req_step_i      : in std_logic_vector(7 downto 0);
    req_events_i    : in std_logic_vector(23 downto 0);
    
    req_ack_o       : out std_logic;
    req_err_o       : out std_logic;
       
    -- Wishbone master
    wb_mst_req_o    : out wb_req_t;
    wb_mst_res_i    : in wb_res_t;
    
    -- VFAT2 data
    vfat2_sbits_i   : in sbits_array_t(23 downto 0);
    vfat2_tk_data_i : in tk_data_array_t(23 downto 0);
    
    -- FIFO control
    fifo_we_o       : out std_logic;
    fifo_din_o      : out std_logic_vector(31 downto 0);
    
    -- Running mode
    scan_error_o    : out std_logic;
    scan_running_o  : out std_logic_vector(2 downto 0)
    
);
end func_scan_req;

architecture Behavioral of func_scan_req is

    type state_t is (IDLE, CHECKS, REQ_RUNNING, ACK_RUNNING, REQ_CURRENT, ACK_CURRENT, REQ_I2C, ACK_I2C, WAIT_DELAY, SCAN_THRESHOLD, SCAN_THRESHOLD2, SCAN_LATENCY, SCAN_SCURVE, SCAN_TK, STORE_RESULT, REQ_RESTORE, ACK_RESTORE);
        
    signal state            : state_t;
    
    -- Scan parameters
    signal req_mode         : std_logic_vector(2 downto 0);
    signal req_vfat2        : std_logic_vector(4 downto 0);
    signal req_channel      : std_logic_vector(6 downto 0);
    signal req_min          : std_logic_vector(8 downto 0);
    signal req_max          : std_logic_vector(8 downto 0);
    signal req_step         : std_logic_vector(8 downto 0);
    signal req_events       : std_logic_vector(23 downto 0);
    
    -- Helpers
    signal vfat2_int        : integer range 0 to 23;
    signal channel_int      : integer range 0 to 127;
    signal register_id      : std_logic_vector(7 downto 0);
    
    -- Value of the register before the scan
    signal saved_value      : std_logic_vector(7 downto 0);
    
    -- Counter for the scan
    signal value_counter    : unsigned(8 downto 0);
    signal event_counter    : unsigned(23 downto 0);
    signal hit_counter      : unsigned(23 downto 0);
    signal delay            : unsigned(15 downto 0);    
    
    -- Utility
    signal empty_8bits      : std_logic_vector(7 downto 0);

begin

    -- All 0 to compare to
    empty_8bits <= (others => '0');

    process(ref_clk_i)
    begin
        if (rising_edge(ref_clk_i)) then
            -- Reset and default values
            if (reset_i = '1') then
                req_ack_o <= '0';
                req_err_o <= '0';
                wb_mst_req_o <= (stb => '0', we => '0', addr => (others => '0'), data => (others => '0'));
                fifo_we_o <= '0';
                fifo_din_o <= (others => '0');
                scan_running_o <= (others => '0');
                scan_error_o <= '0';
                state <= IDLE;
                req_mode <= (others => '0');
                req_vfat2 <= (others => '0');
                req_channel <= (others => '0');
                req_min <= (others => '0');
                req_max <= (others => '0');
                req_step <= (others => '0');
                req_events <= (others => '0');
                vfat2_int <= 0;
                channel_int <= 0;
                register_id <= (others => '0');
                saved_value <= (others => '0');
                value_counter <= (others => '0');
                event_counter <= (others => '0');
                hit_counter <= (others => '0');
                delay <= (others => '0');
            else
                case state is                
                    -- Wait for request
                    when IDLE =>
                        -- Reset the flags
                        req_ack_o <= '0';
                        req_err_o <= '0';
                        fifo_we_o <= '0';
                        scan_running_o <= (others => '0');
                        -- On request
                        if (req_stb_i = '1') then
                            -- Store the request values                              
                            req_mode <= req_mode_i;
                            req_vfat2 <= req_vfat2_i;
                            req_channel <= req_channel_i;
                            req_min <= '0' & req_min_i;
                            case req_max_i is
                                when x"00" => req_max <= '0' & x"FF";
                                when others => req_max <= '0' & req_max_i;
                            end case;
                            case req_step_i is
                                when x"00" => req_step <= '0' & x"01";
                                when others => req_step <= '0' & req_step_i;
                            end case;
                            case req_events_i is
                                when x"000000" => req_events <= x"FFFFFF";
                                when others => req_events <= req_events_i;
                            end case;
                            -- Set the helpers
                            vfat2_int <= to_integer(unsigned(req_vfat2_i));
                            channel_int <= to_integer(unsigned(req_channel_i));
                            case req_mode_i is
                                when "000" | "001" | "100" => register_id <= x"92";
                                when "010" => register_id <= x"10";
                                when "011" => register_id <= x"91";
                                when others => register_id <= x"10";
                            end case;
                            value_counter <= '0' & unsigned(req_min_i);
                            -- Set the flags
                            case req_mode_i is
                                when "000" => scan_running_o <= "001";
                                when "001" => scan_running_o <= "010";
                                when "010" => scan_running_o <= "011";
                                when "011" => scan_running_o <= "100";
                                when "100" => scan_running_o <= "101";
                                when others => scan_running_o <= "000";
                            end case;
                            -- Change state
                            state <= CHECKS;
                        end if;       
                    -- Check the parameters
                    when CHECKS =>
                        -- Check VFAT2
                        if (vfat2_int > 23) then
                            req_ack_o <= '0';
                            req_err_o <= '1';
                            scan_error_o <= '1';
                            state <= IDLE;                        
                        -- Check if the min < max
                        elsif (unsigned(req_min) > unsigned(req_max)) then
                            req_ack_o <= '0';
                            req_err_o <= '1';
                            scan_error_o <= '1';
                            state <= IDLE;      
                        else
                            state <= REQ_RUNNING;   
                        end if;                        
                    -- Prepare the scan
                    when REQ_RUNNING =>
                        -- Reset the acknowledmgents
                        req_ack_o <= '0';
                        req_err_o <= '0';
                        -- Ask if VFAT2 is running
                        wb_mst_req_o <= (stb => '1', we => '0', addr => WB_ADDR_I2C & "00000000000" & req_vfat2 & x"00", data => (others => '0'));
                        state <= ACK_RUNNING;      
                    -- Wait for the response
                    when ACK_RUNNING => 
                        -- Reset the strobe
                        wb_mst_req_o.stb <= '0';
                        -- On acknowledgment
                        if (wb_mst_res_i.ack = '1') then
                            -- If the data is valid and the VFAT2 is on
                            if (wb_mst_res_i.stat = WB_NO_ERR and wb_mst_res_i.data(0) = '1') then
                                -- change state
                                req_ack_o <= '1';
                                req_err_o <= '0';
                                scan_error_o <= '0';
                                state <= REQ_CURRENT;
                            -- Or
                            else
                                req_ack_o <= '0';
                                req_err_o <= '1';
                                scan_error_o <= '1';
                                state <= IDLE;
                            end if;
                        end if;                        
                    -- Read the current value of the register
                    when REQ_CURRENT => 
                        -- Send an I2C request
                        wb_mst_req_o <= (stb => '1', we => '0', addr => WB_ADDR_I2C & "00000000000" & req_vfat2 & register_id, data => (others => '0'));
                        state <= ACK_CURRENT;                        
                    -- Wait for the response
                    when ACK_CURRENT => 
                        -- Reset the strobe
                        wb_mst_req_o.stb <= '0';
                        -- On acknowledgment
                        if (wb_mst_res_i.ack = '1') then
                            -- If the data is valid
                            if (wb_mst_res_i.stat = WB_NO_ERR) then
                                -- Store it in memory
                                saved_value <= wb_mst_res_i.data(7 downto 0);
                                -- and change state
                                state <= REQ_I2C;
                            -- Or
                            else
                                scan_error_o <= '1';
                                state <= IDLE;
                            end if;
                        end if;                        
                    -- Send an I2C request to change the value
                    when REQ_I2C =>
                        -- Reset the write enable 
                        fifo_we_o <= '0';
                        -- Send an I2C request
                        wb_mst_req_o <= (stb => '1', we => '1', addr => WB_ADDR_I2C & "00000000000" & req_vfat2 & register_id, data => x"000000" & std_logic_vector(value_counter(7 downto 0)));
                        state <= ACK_I2C;                        
                    -- Wait for the acknowledgment
                    when ACK_I2C => 
                        -- Reset the strobe
                        wb_mst_req_o.stb <= '0';
                        -- On acknowledgment
                        if (wb_mst_res_i.ack = '1') then
                            -- If the request was done successfully
                            if (wb_mst_res_i.stat = WB_NO_ERR) then
                                delay <= (others => '0');
                                state <= WAIT_DELAY;
                            -- or store an error
                            else
                                event_counter <= (others => '1');
                                hit_counter <= (others => '1');
                                state <= STORE_RESULT;
                            end if;
                        end if;  
                    -- Wait a bit
                    when WAIT_DELAY =>
                        if (delay = 50_000) then 
                            -- Go for counting
                            event_counter <= (others => '0');
                            hit_counter <= (others => '0');
                            -- Change state
                            case req_mode is
                                when "000" => state <= SCAN_THRESHOLD;
                                when "001" => state <= SCAN_THRESHOLD2;
                                when "010" => state <= SCAN_LATENCY;
                                when "011" => state <= SCAN_SCURVE;
                                when "100" => state <= SCAN_TK;
                                when others => state <= IDLE;
                            end case;
                        else
                            delay <= delay + 1;
                        end if;
                    -- Perform a threshold scan using trigger bits
                    when SCAN_THRESHOLD =>
                        -- Change state when the counter reached its limit
                        if (event_counter = unsigned(req_events)) then
                            state <= STORE_RESULT;
                        else
                            -- Increment the event counter
                            event_counter <= event_counter + 1;
                            -- Increment the hit counter
                            if (vfat2_sbits_i(vfat2_int) /= empty_8bits) then
                                hit_counter <= hit_counter + 1;
                            end if;
                        end if;                      
                    -- Perform a latency scan or threshold scan using tracking data
                    when SCAN_LATENCY | SCAN_TK =>                        
                    -- Change state when the counter reached its limit
                        if (event_counter = unsigned(req_events)) then
                            state <= STORE_RESULT;
                        else
                            -- Wait for tracking data
                            if (vfat2_tk_data_i(vfat2_int).valid = '1' and vfat2_tk_data_i(vfat2_int).crc_ok = '1') then
                                -- Increment the event counter
                                event_counter <= event_counter + 1;
                                -- Increment the hit counter
                                if (vfat2_tk_data_i(vfat2_int).hit = '1') then
                                    hit_counter <= hit_counter + 1;
                                end if;
                            end if;
                        end if;                      
                    -- Perform a threshold scan or scurve on a single channel
                    when SCAN_THRESHOLD2 | SCAN_SCURVE =>                   
                        -- Change state when the counter reached its limit
                        if (event_counter = unsigned(req_events)) then
                            state <= STORE_RESULT;
                        else
                            -- Wait for tracking data
                            if (vfat2_tk_data_i(vfat2_int).valid = '1' and vfat2_tk_data_i(vfat2_int).crc_ok = '1') then
                                -- Increment the event counter
                                event_counter <= event_counter + 1;
                                -- Increment the hit counter
                                if (vfat2_tk_data_i(vfat2_int).strips(channel_int) = '1') then
                                    hit_counter <= hit_counter + 1;
                                end if;
                            end if;
                        end if;                               
                    -- Store the results in the FIFO
                    when STORE_RESULT =>
                        -- Write in the FIFO
                        fifo_we_o <= '1';
                        fifo_din_o <= std_logic_vector(value_counter(7 downto 0)) & std_logic_vector(hit_counter);
                        -- Check the value for its limit
                        if (value_counter + unsigned(req_step) <= unsigned(req_max)) then
                            -- Increment the value counter
                            value_counter <= value_counter + unsigned(req_step);
                            -- and repeat the procedure
                            state <= REQ_I2C;
                        -- Or restore the latency value
                        else
                            state <= REQ_RESTORE;
                        end if;                        
                    -- Restore the value
                    when REQ_RESTORE => 
                        -- Reset the write enable 
                        fifo_we_o <= '0';
                        -- Send an I2C request
                        wb_mst_req_o <= (stb => '1', we => '1', addr => WB_ADDR_I2C & "00000000000" & req_vfat2 & register_id, data => x"000000" & std_logic_vector(saved_value));
                        state <= ACK_RESTORE;                        
                    -- Wait for the acknowledgment
                    when ACK_RESTORE => 
                        -- Reset the strobe
                        wb_mst_req_o.stb <= '0';
                        -- On acknowledgment
                        if (wb_mst_res_i.ack = '1') then
                            state <= IDLE;
                        end if;                    
                    --
                    when others =>
                        wb_mst_req_o <= (stb => '0', we => '0', addr => (others => '0'), data => (others => '0'));
                        fifo_we_o <= '0';
                        fifo_din_o <= (others => '0');
                        scan_running_o <= (others => '0');
                        scan_error_o <= '0';
                        state <= IDLE;
                        req_mode <= (others => '0');
                        req_vfat2 <= (others => '0');
                        req_channel <= (others => '0');
                        req_min <= (others => '0');
                        req_max <= (others => '0');
                        req_step <= (others => '0');
                        req_events <= (others => '0');
                        vfat2_int <= 0;
                        channel_int <= 0;
                        register_id <= (others => '0');
                        saved_value <= (others => '0');
                        value_counter <= (others => '0');
                        event_counter <= (others => '0');
                        hit_counter <= (others => '0');                                                
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;




