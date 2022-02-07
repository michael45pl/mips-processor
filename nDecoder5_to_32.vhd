library IEEE;
use IEEE.std_logic_1164.all;

entity nDecoder5_to_32 is
  port(	i_WE		: in std_logic;
	i_D        	: in std_logic_vector(4 downto 0);     -- Data value input
      	o_F        	: out std_logic_vector(31 downto 0));   -- Data value output
end nDecoder5_to_32;

architecture dataflow of nDecoder5_to_32 is
begin

process(i_WE, i_D)
begin
	o_F<="00000000000000000000000000000000";
	if i_WE = '1' then
		case i_D is
			when "00000" => o_F(0)  <= '1';
        		when "00001" => o_F(1)  <= '1';
        		when "00010" => o_F(2)  <= '1';
        		when "00011" => o_F(3)  <= '1';

        		when "00100" => o_F(4)  <= '1';
        		when "00101" => o_F(5)  <= '1';
        		when "00110" => o_F(6)  <= '1';
        		when "00111" => o_F(7)  <= '1';

        		when "01000" => o_F(8)  <= '1';
        		when "01001" => o_F(9)  <= '1';
        		when "01010" => o_F(10) <= '1';
        		when "01011" => o_F(11) <= '1';

        		when "01100" => o_F(12) <= '1';
        		when "01101" => o_F(13) <= '1';
        		when "01110" => o_F(14) <= '1';
        		when "01111" => o_F(15) <= '1';

        		when "10000" => o_F(16) <= '1';
        		when "10001" => o_F(17) <= '1';
        		when "10010" => o_F(18) <= '1';
        		when "10011" => o_F(19) <= '1';

        		when "10100" => o_F(20) <= '1';
        		when "10101" => o_F(21) <= '1';
        		when "10110" => o_F(22) <= '1';
        		when "10111" => o_F(23) <= '1';

        		when "11000" => o_F(24) <= '1';
        		when "11001" => o_F(25) <= '1';
        		when "11010" => o_F(26) <= '1';
        		when "11011" => o_F(27) <= '1';

        		when "11100" => o_F(28) <= '1';
	        	when "11101" => o_F(29) <= '1';
        		when "11110" => o_F(30) <= '1';
			when others  => o_F(31) <= '1';         

		end case;
	end if;
end process;
end dataflow;