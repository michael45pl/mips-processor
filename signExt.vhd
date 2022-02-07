library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExt is
	port (  im		: in std_logic_vector(15 downto 0);
		o_F		: out std_logic_vector(31 downto 0));
end signExt;

architecture rtm of signExt is
begin 
process(im)
begin
	for I in 0 to 31 loop
		if (I < 15) then
			o_F(I)<=im(I);
		else	o_F(I)<=im(15);
		end if;
	end loop;
end process;
end rtm;