-- cpu.vhd: Simple 8-bit CPU (BrainLove interpreter)
-- Copyright (C) 2021 Brno University of Technology,
--                    Faculty of Information Technology
-- Author: Ladislav Vašina, xvasin11, 2021
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity cpu is
 port (
   CLK   : in std_logic;  -- hodinovy signal
   RESET : in std_logic;  -- asynchronni reset procesoru
   EN    : in std_logic;  -- povoleni cinnosti procesoru
 
   -- synchronni pamet ROM
   CODE_ADDR : out std_logic_vector(11 downto 0); -- adresa do pameti
   CODE_DATA : in std_logic_vector(7 downto 0);   -- CODE_DATA <- rom[CODE_ADDR] pokud CODE_EN='1'
   CODE_EN   : out std_logic;                     -- povoleni cinnosti
   
   -- synchronni pamet RAM
   DATA_ADDR  : out std_logic_vector(9 downto 0); -- adresa do pameti
   DATA_WDATA : out std_logic_vector(7 downto 0); -- ram[DATA_ADDR] <- DATA_WDATA pokud DATA_EN='1'
   DATA_RDATA : in std_logic_vector(7 downto 0);  -- DATA_RDATA <- ram[DATA_ADDR] pokud DATA_EN='1'
   DATA_WREN  : out std_logic;                    -- cteni z pameti (DATA_WREN='0') / zapis do pameti (DATA_WREN='1')
   DATA_EN    : out std_logic;                    -- povoleni cinnosti
   
   -- vstupni port
   IN_DATA   : in std_logic_vector(7 downto 0);   -- IN_DATA obsahuje stisknuty znak klavesnice pokud IN_VLD='1' a IN_REQ='1'
   IN_VLD    : in std_logic;                      -- data platna pokud IN_VLD='1'
   IN_REQ    : out std_logic;                     -- pozadavek na vstup dat z klavesnice
   
   -- vystupni port
   OUT_DATA : out  std_logic_vector(7 downto 0);  -- zapisovana data
   OUT_BUSY : in std_logic;                       -- pokud OUT_BUSY='1', LCD je zaneprazdnen, nelze zapisovat,  OUT_WREN musi byt '0'
   OUT_WREN : out std_logic                       -- LCD <- OUT_DATA pokud OUT_WREN='1' a OUT_BUSY='0'
 );
end cpu;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of cpu is

 -- zde dopiste potrebne deklarace signalu--
 
 -- PROGRAM COUNTER --
		signal pc_register  : std_logic_vector(11 downto 0);
		signal pc_inc		  : std_logic;
	   signal pc_dec		  : std_logic;
 ---------------
 
 -- COUNTER --
		signal cnt_register : std_logic_vector(7 downto 0);
		signal cnt_inc		  : std_logic;
	   signal cnt_dec		  : std_logic;
		signal cnt_reset    : std_logic;
 ---------------
 
 -- POINTER --
		signal ptr_register : std_logic_vector(9 downto 0);
		signal ptr_inc		  : std_logic;
	   signal ptr_dec		  : std_logic;
 ---------------
 
  -- MULTIPLEXOR --
		signal mx_select    : std_logic_vector(1 downto 0) := (others => '0');
		signal mx_output    : std_logic_vector(7 downto 0) := (others => '0');
 ---------------

 -- STATES --
	type fsm_state is (
		state_start,
		state_fetch,
		state_decode,
		
		state_pointer_inc,
		state_pointer_dec,
		
		state_value_inc,
		state_value_inc_mx,
		state_value_inc_end,
		state_value_dec,
		state_value_dec_mx,
		state_value_dec_end,
		
		state_while_start,
		state_while_start_0,
		state_while_start_1,
		state_while_start_2,
		state_while_end,
		state_while_end_0,
		state_while_end_1,
		state_while_end_2,
		
		state_write,
		state_write_done,
		state_get,
		state_get_done,
		
		state_break,
		state_break_0,
		state_break_1,

		
		state_null,
		state_others
		);
		signal presentState : fsm_state;
		signal nextState    : fsm_state;
 ---------------
 
begin

 -- PROGRAM COUNTER --
	pc: process(CLK, RESET, pc_inc, pc_dec)
	begin
			if RESET = '1' then 
				pc_register <= (others => '0');
				elsif rising_edge(CLK) then
					if pc_inc = '1' then
						pc_register <= pc_register + 1;
					elsif pc_dec = '1' then
							pc_register <= pc_register - 1;
					end if;		
				end if;
	end process;
	CODE_ADDR <= pc_register;
 ---------------
 
 -- COUNTER --
 cnt: process(CLK, RESET, cnt_inc, cnt_dec)
	begin
			if RESET = '1' then 
				cnt_register <= (others => '0');
				elsif rising_edge(CLK) then
					if cnt_inc = '1' then
						cnt_register <= cnt_register + 1;
					elsif cnt_dec = '1' then
							cnt_register <= cnt_register - 1;
					elsif cnt_reset = '1' then
							cnt_register <= (others => '0');
					end if;		
				end if;
	end process;
 
 ---------------
 
 -- POINTER --
 	ptr: process(CLK, RESET, ptr_inc, ptr_dec)
	begin
			if RESET = '1' then 
				ptr_register <= (others => '0');
				elsif rising_edge(CLK) then
					if ptr_inc = '1' then
						ptr_register <= ptr_register + 1;
					elsif ptr_dec = '1' then
							ptr_register <= ptr_register - 1;
					end if;		
				end if;
	end process;
	DATA_ADDR <= ptr_register;
 ---------------
 
 -- MULTIPLEXOR --
	mux: process(CLK, RESET, mx_select)
	begin
		if RESET = '1' then
			mx_output <= (others => '0');
		elsif rising_edge(CLK) then
			case mx_select is
						when "00" =>
								mx_output <= IN_DATA;
						when "01" =>
								mx_output <= DATA_RDATA + 1;
						when "10" =>
								mx_output <= DATA_RDATA - 1;
						when others =>
								mx_output <= (others => '0');
			end case;
		end if;
	end process;
	DATA_WDATA <= mx_output;
 --------------- 
 
 -- FINITE STATE MACHINE --
	present_state_logic: process(CLK, RESET, EN)
	begin
		if RESET = '1' then
			presentState <= state_start;
		elsif rising_edge(CLK) then
				if EN = '1' then
					presentState <= nextState;
				end if;
		end if;		
	end process;
	
	next_state_logic: process(presentState, OUT_BUSY, IN_VLD, CODE_DATA, DATA_RDATA, cnt_register)
	begin
		 -- init --
		 pc_inc    <= '0';
		 pc_dec    <= '0';
		 cnt_inc   <= '0';
		 cnt_dec   <= '0';
		 ptr_inc   <= '0';
		 ptr_dec   <= '0';

		 CODE_EN   <= '0';
		 DATA_EN   <= '0';
		 DATA_WREN <= '0';
		 IN_REQ    <= '0';
		 OUT_WREN  <= '0';
		 
		 mx_select <= "00";
		 
		 case presentState is
			when state_start =>
						nextState <= state_fetch;
			when state_fetch =>
						CODE_EN <= '1';
						nextState <= state_decode;
			when state_decode =>
						case CODE_DATA is
									when x"3E" =>
											nextState <= state_pointer_inc;
									when x"3C" =>
											nextState <= state_pointer_dec;
									when x"2B" =>
											nextState <= state_value_inc;
									when x"2D" =>
											nextState <= state_value_dec;
									when x"5B" =>
											nextState <= state_while_start;
									when x"5D" =>
											nextState <= state_while_end;
									when x"2E" =>
											nextState <= state_write;
									when x"2C" =>
											nextState <= state_get;
									when x"7E" =>
											nextState <= state_break;
									when x"00" =>
											nextState <= state_null;
									when others =>
											nextState <= state_others;
						end case;
			when state_pointer_inc =>
					ptr_inc   <= '1';
					pc_inc    <= '1';
					nextState <= state_fetch;
			when state_pointer_dec =>	
					ptr_dec   <= '1';
					pc_inc    <= '1';
					nextState <= state_fetch;
					
			when state_value_inc =>
					DATA_EN   <= '1';
					DATA_WREN <= '0';
					nextState <= state_value_inc_mx;
			when state_value_inc_mx =>
					mx_select <= "01";
					nextState <= state_value_inc_end;
			when state_value_inc_end =>
					DATA_EN   <= '1';
					DATA_WREN <= '1';
					pc_inc    <= '1';
					nextState <= state_fetch;
			when state_value_dec =>
					DATA_EN   <= '1';
					DATA_WREN <= '0';
					nextState <= state_value_dec_mx;
			when state_value_dec_mx =>
					mx_select <= "10";
					nextState <= state_value_dec_end;
			when state_value_dec_end =>
					DATA_EN   <= '1';
					DATA_WREN <= '1';
					pc_inc    <= '1';
					nextState <= state_fetch;

			when state_while_start =>
					pc_inc     <= '1'; -- PC<- PC+1
					DATA_EN    <= '1';
					DATA_WREN  <= '0';	
					nextState  <= state_while_start_0;
			when  state_while_start_0 =>		
					nextState <= state_fetch;
					if DATA_RDATA = (DATA_RDATA'range => '0') then
						nextState  <= state_while_start_1;
					end if;
			when state_while_start_1 =>
						CODE_EN   <= '1'; -- c <- ROM[PC]
						nextState <= state_while_start_2;
			when state_while_start_2 =>
						pc_inc    <= '1';
					if CODE_DATA /= x"5D" then
						nextState <= state_while_start_1;
					elsif CODE_DATA = x"5D" then
						nextState <= state_fetch;
					end if;	
					
			when state_while_end   =>
					DATA_EN    <= '1';
					DATA_WREN  <= '0';
					nextState  <= state_while_end_0;
			when state_while_end_0 =>
					if DATA_RDATA /= (DATA_RDATA'range => '0') then
						pc_dec    <= '1';
						nextState <= state_while_end_1;
					else
						pc_inc <= '1';
						nextState <= state_fetch;
					end if;
			when state_while_end_1 =>
					CODE_EN   <= '1'; -- c <- ROM[PC]
					nextState <= state_while_end_2;
			when state_while_end_2 =>
					if CODE_DATA /= x"5B" then
						pc_dec <= '1';
						nextState <= state_while_end_1;
					elsif CODE_DATA = x"5B" then	
						pc_inc    <= '1';
						nextState <= state_fetch;
					end if;

			when state_write       =>
					DATA_EN   <= '1';
					DATA_WREN <= '0';
					nextState <= state_write_done;
			when state_write_done  =>
					if OUT_BUSY = '1' then
						DATA_EN   <= '1';
						DATA_WREN <= '0';
						nextState <= state_write_done;
					else
						OUT_WREN  <= '1';
						pc_inc    <= '1';
						OUT_DATA  <= DATA_RDATA;
						nextState <= state_fetch;
					end if;
			when state_get         =>
					IN_REQ <= '1';
					mx_select <= "00";
					nextState <= state_get_done;
			when state_get_done    =>
					if IN_VLD /= '1' then
						IN_REQ <= '1';
						mx_select <= "00";
						nextState <= state_get_done;
					else
						DATA_EN   <= '1';
						DATA_WREN <= '1';
						pc_inc    <= '1';
						nextState <= state_fetch;
					end if;
		   when state_break		  =>
					pc_inc     <= '1'; -- PC<- PC+1
					DATA_EN    <= '1';
					DATA_WREN  <= '0';	
					nextState  <= state_break_0;
			when state_break_0 	  =>
					nextState <= state_fetch;
					CODE_EN   <= '1'; -- c <- ROM[PC]
					nextState <= state_break_1;
			when state_break_1     =>
						pc_inc <= '1';
					if CODE_DATA /= x"5D" then
						nextState <= state_break_0;
					elsif CODE_DATA = x"5D" then
						nextState <= state_fetch;
					end if;	
								
		   when state_null            =>
			   nextState <= state_null;
			when state_others 			=>
				pc_inc <= '1';
				nextState <= state_fetch;
					null;
					
		 end case;
	end process;

end behavioral;
 
