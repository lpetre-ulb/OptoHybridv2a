library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package wb_pkg is
    
    --== Wishbone options ==--
    
    constant WB_TIMEOUT         : integer := 200_000;
    
    --== Wishbone errors ==--
    
    constant WB_NO_ERR          : std_logic_vector(3 downto 0) := x"0";
        
    constant WB_ERR_BUS         : std_logic_vector(3 downto 0) := x"D";
    constant WB_ERR_SLAVE       : std_logic_vector(3 downto 0) := x"E";
    constant WB_ERR_TIMEOUT     : std_logic_vector(3 downto 0) := x"F";
    
    constant WB_ERR_I2C_CHIPID  : std_logic_vector(3 downto 0) := x"1";
    constant WB_ERR_I2C_REG     : std_logic_vector(3 downto 0) := x"2";
    constant WB_ERR_I2C_ACK     : std_logic_vector(3 downto 0) := x"3";
    
    --== Wishbone masters ==--
    
    constant WB_MASTERS         : positive := 6;
    
    constant WB_MST_GTX         : integer := 0;

    constant WB_MST_GBT         : integer := 1;

    constant WB_MST_EI2C        : integer := 2;

    constant WB_MST_SCAN        : integer := 3;

    constant WB_MST_DAC         : integer := 4;

    constant WB_MST_USCAN       : integer := 5;

    --== Wishbone slaves ==--
    
    constant WB_SLAVES          : positive := 17;
    
    constant WB_SLV_I2C_0       : integer := 0;
    constant WB_SLV_I2C_1       : integer := 1;
    constant WB_SLV_I2C_2       : integer := 2;
    constant WB_SLV_I2C_3       : integer := 3; 
    constant WB_SLV_I2C_4       : integer := 4; 
    constant WB_SLV_I2C_5       : integer := 5;

    constant WB_SLV_EI2C        : integer := 6;

    constant WB_SLV_SCAN        : integer := 7;

    constant WB_SLV_T1          : integer := 8;

    constant WB_SLV_DAC         : integer := 9;

    constant WB_SLV_ADC         : integer := 10;

    constant WB_SLV_CLK         : integer := 11;

    constant WB_SLV_CNT         : integer := 12;

    constant WB_SLV_SYS         : integer := 13;

    constant WB_SLV_STAT        : integer := 14;

    constant WB_SLV_USCAN       : integer := 15;

    constant WB_SLV_TDC         : integer := 16;
    
    --== Wishbone addresses ==--
    
    constant WB_ADDR_I2C        : std_logic_vector(7 downto 0) := x"40";
    constant WB_ADDR_EI2C       : std_logic_vector(7 downto 0) := x"41";
    constant WB_ADDR_SCAN       : std_logic_vector(7 downto 0) := x"42";
    constant WB_ADDR_T1         : std_logic_vector(7 downto 0) := x"43";
    constant WB_ADDR_DAC        : std_logic_vector(7 downto 0) := x"44";

    constant WB_ADDR_ADC        : std_logic_vector(7 downto 0) := x"48";
    constant WB_ADDR_CLK        : std_logic_vector(7 downto 0) := x"49";
    constant WB_ADDR_CNT        : std_logic_vector(7 downto 0) := x"4A";
    constant WB_ADDR_SYS        : std_logic_vector(7 downto 0) := x"4B";
    constant WB_ADDR_STAT       : std_logic_vector(7 downto 0) := x"4C";

    constant WB_ADDR_USCAN      : std_logic_vector(7 downto 0) := x"4D";

    constant WB_ADDR_TDC        : std_logic_vector(7 downto 0) := x"4F";
   
    --== Wishbone address selection & generation ==--
    
    function wb_addr_sel(signal addr : std_logic_vector(31 downto 0)) return integer;
    
end wb_pkg;

package body wb_pkg is

    --== Address decoder ==--   
    
    function wb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
        variable sel : integer;
    begin
        -- VFAT2 I2C                                     |ID||  REGS  |
        if    (std_match(addr, WB_ADDR_I2C  & "00000000000000----------")) then sel := WB_SLV_I2C_0;
        elsif (std_match(addr, WB_ADDR_I2C  & "00000000000001----------")) then sel := WB_SLV_I2C_1;
        elsif (std_match(addr, WB_ADDR_I2C  & "00000000000010----------")) then sel := WB_SLV_I2C_2;
        elsif (std_match(addr, WB_ADDR_I2C  & "00000000000011----------")) then sel := WB_SLV_I2C_3;
        elsif (std_match(addr, WB_ADDR_I2C  & "00000000000100----------")) then sel := WB_SLV_I2C_4;
        elsif (std_match(addr, WB_ADDR_I2C  & "00000000000101----------")) then sel := WB_SLV_I2C_5;
        -- VFAT2 I2C extended                                 | REGS  |
        elsif (std_match(addr, WB_ADDR_EI2C & "000000000000000---------")) then sel := WB_SLV_EI2C;
        -- VFAT2 scan                                         REGS |  |            
        elsif (std_match(addr, WB_ADDR_SCAN & "00000000000000000000----")) then sel := WB_SLV_SCAN;
        -- VFAT2 T1                                           REGS |  |      
        elsif (std_match(addr, WB_ADDR_T1   & "00000000000000000000----")) then sel := WB_SLV_T1;   
        -- VFAT2 DAC                                          REGS |  |            
        elsif (std_match(addr, WB_ADDR_DAC  & "00000000000000000000----")) then sel := WB_SLV_DAC;  
        -- ADC                                                  | REGS|
        elsif (std_match(addr, WB_ADDR_ADC  & "00000000000000000-------")) then sel := WB_SLV_ADC;    
        -- Clocking                                                              
        elsif (std_match(addr, WB_ADDR_CLK  & "000000000000000000000000")) then sel := WB_SLV_CLK;    
        -- Counters                                            | REGS |
        elsif (std_match(addr, WB_ADDR_CNT  & "0000000000000000--------")) then sel := WB_SLV_CNT;    
        -- System                                              | REGS |
        elsif (std_match(addr, WB_ADDR_SYS  & "0000000000000000--------")) then sel := WB_SLV_SYS;  
        -- Status                                              | REGS |
        elsif (std_match(addr, WB_ADDR_STAT & "0000000000000000--------")) then sel := WB_SLV_STAT;  
        -- Ultra VFAT2 scan                                       |REGS|            
        elsif (std_match(addr, WB_ADDR_USCAN & "000000000000000000------")) then sel := WB_SLV_USCAN;
        -- TDC                                               REGS |   |
        elsif (std_match(addr, WB_ADDR_TDC  & "0000000000000000000-----")) then sel := WB_SLV_TDC;
        --
        else sel := 99;
        end if;
        return sel;
    end wb_addr_sel;
 
end wb_pkg;
