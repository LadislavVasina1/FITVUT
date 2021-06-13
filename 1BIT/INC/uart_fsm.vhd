-- uart_fsm.vhd: UART controller - finite state machine
-- Author: Ladislav Vašina - xvasin11
-- INC PROJECT 2021
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK      : in std_logic;
   RST      : in std_logic;
   DIN      : in std_logic;
   CNT1     : in std_logic_vector(4 downto 0); --čítač hodinovych signalu
   CNT2     : in std_logic_vector(3 downto 0); -- čítač prijatych bitu
   RCV_EN   : out std_logic;
   CNT_EN   : out std_logic;
   DOUT_VLD : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
-- Vytvoreni stavu FSM   
type STATE_TYPE is (WAIT_START_BIT, WAIT_FIRST_BIT, RECEIVE_DATA, WAIT_STOP_BIT, DATA_VALID);
signal state : STATE_TYPE := WAIT_START_BIT;
begin      
RCV_EN <= '1' when state = RECEIVE_DATA else '0';
CNT_EN <= '0' when state = WAIT_START_BIT else '1';
DOUT_VLD <= '1' when state = DATA_VALID else '0';
   process(CLK) begin
      if rising_edge(CLK) then
         if RST = '1' then          -- Pokud je nastaveny RST signál ==>
            state <= WAIT_START_BIT;-- ==> Nastaví se stav signálu na WAIT_START_BIT
         else
            case state is
               when WAIT_START_BIT => if DIN = '0' then
                                          state <= WAIT_FIRST_BIT;
                                      end if ;
               when WAIT_FIRST_BIT => if CNT1 = "10110" then      
                                          state <= RECEIVE_DATA;    
                                      end if;    
               when RECEIVE_DATA   => if CNT2 = "1000" then
                                          state <= WAIT_STOP_BIT;
                                      end if;
               when WAIT_STOP_BIT  => if CNT1 = "01000"   then  
                                          state <= DATA_VALID;
                                      end if;
               when DATA_VALID     => state <= WAIT_START_BIT;                                                                    
               when others => null;
            end case;
         end if;   
      end if;   
   end process;
end behavioral;
