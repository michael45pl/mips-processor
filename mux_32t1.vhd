library IEEE;
use IEEE.std_logic_1164.all;
use work.vector_type.all;

entity mux_32t1 is
generic(N : Integer := 32;
	M : Integer := 5);
   port(mux_In  :	in reg_inputs;
	mux_S	:	in std_logic_vector(M-1 downto 0);
	mux_O	:	out std_logic_vector(N-1 downto 0));
end mux_32t1;

architecture behavioral of mux_32t1 is
begin
   mux : process (mux_In,mux_S)
	begin
		if (mux_S = "11111") then mux_O <= mux_In(31);
		elsif (mux_S = "11110") then mux_O <= mux_In(30);
		elsif (mux_S = "11101") then mux_O <= mux_In(29);
		elsif (mux_S = "11100") then mux_O <= mux_In(28);
		elsif (mux_S = "11011") then mux_O <= mux_In(27);
		elsif (mux_S = "11010") then mux_O <= mux_In(26);
		elsif (mux_S = "11001") then mux_O <= mux_In(25);
		elsif (mux_S = "11000") then mux_O <= mux_In(24);
		elsif (mux_S = "10111") then mux_O <= mux_In(23);
		elsif (mux_S = "10110") then mux_O <= mux_In(22);
		elsif (mux_S = "10101") then mux_O <= mux_In(21);
		elsif (mux_S = "10100") then mux_O <= mux_In(20);
		elsif (mux_S = "10011") then mux_O <= mux_In(19);
		elsif (mux_S = "10010") then mux_O <= mux_In(18);
		elsif (mux_S = "10001") then mux_O <= mux_In(17);
		elsif (mux_S = "10000") then mux_O <= mux_In(16);
		elsif (mux_S = "01111") then mux_O <= mux_In(15);
		elsif (mux_S = "01110") then mux_O <= mux_In(14);
		elsif (mux_S = "01101") then mux_O <= mux_In(13);
		elsif (mux_S = "01100") then mux_O <= mux_In(12);
		elsif (mux_S = "01011") then mux_O <= mux_In(11);
		elsif (mux_S = "01010") then mux_O <= mux_In(10);
		elsif (mux_S = "01001") then mux_O <= mux_In(9);
		elsif (mux_S = "01000") then mux_O <= mux_In(8);
		elsif (mux_S = "00111") then mux_O <= mux_In(7);
		elsif (mux_S = "00110") then mux_O <= mux_In(6);
		elsif (mux_S = "00101") then mux_O <= mux_In(5);
		elsif (mux_S = "00100") then mux_O <= mux_In(4);
		elsif (mux_S = "00011") then mux_O <= mux_In(3);
		elsif (mux_S = "00010") then mux_O <= mux_In(2);
		elsif (mux_S = "00001") then mux_O <= mux_In(1);
		else mux_O <= mux_In(0);
		end if;
	end process mux;
end behavioral;