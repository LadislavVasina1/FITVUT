-- uart.vhd: UART controller - receiving part
-- Author: Ladislav Vašina - xvasin11
-- INC PROJECT 2021
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal cnt1   : std_logic_vector(4 downto 0); -- pocitadlo hodinovych signalu
signal cnt2   : std_logic_vector(3 downto 0); -- pocitadlo prijatych bitu
signal rcv_en : std_logic;					
signal cnt_en : std_logic;
signal dvld   : std_logic;
begin
	FSM: entity work.UART_FSM(behavioral)
    port map (
        CLK 	    => CLK,
        RST 	    => RST,
        DIN 	    => DIN,
        CNT1	    => cnt1,
        CNT2	    => cnt2,
		RCV_EN      => rcv_en,
		CNT_EN      => cnt_en,
		DOUT_VLD    => dout_vld
    );
	process(CLK) begin
		if rising_edge(CLK) then
		    if RST = '1' or cnt_en = '0' then
		    cnt1 <= "00000";
		    cnt2 <= "0000";
		    dvld <= '0';
		    DOUT <= "00000000";
		    end if;

			if cnt_en = '1' then
				cnt1 <= cnt1 + 1;
			else
				cnt1 <= "00000";
			end if;
			
			if (rcv_en and cnt_en) = '1' then  
				if cnt1(4) = '1' then
					cnt1 <= "00000";
					case cnt2 is
					when "0000"  => DOUT(0) <= DIN;
					when "0001"  => DOUT(1) <= DIN;
					when "0010"  => DOUT(2) <= DIN;
					when "0011"  => DOUT(3) <= DIN;
					when "0100"  => DOUT(4) <= DIN;
					when "0101"  => DOUT(5) <= DIN;
					when "0110"  => DOUT(6) <= DIN;
					when "0111"  => DOUT(7) <= DIN;
					when others  => null;
					end case;
                cnt2 <= cnt2 + 1; -- inkrementace čítače přenesených bitu      
				end if;	
			end if;
		end if;
	end process;	
end behavioral;