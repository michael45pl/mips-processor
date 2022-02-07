library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extendsign is
	port (
        i_I             : in std_logic_vector(15 downto 0);
        i_S        : in std_logic;
        o_EXV : out std_logic_vector(31 downto 0)
  	);
end entity;


architecture structure of extendsign is

begin

	sixteen_16 : for i in 0 to 15 generate

		o_EXV(i) <= i_I(i);

	end generate;

	sixteen_to_32 : for i in 16 to 31 generate
		
		o_EXV(i) <= i_S and i_I(15);
	end generate;

end architecture;