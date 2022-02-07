library IEEE;
use IEEE.std_logic_1164.all;

package vector_type is
	type reg_inputs is array(31 downto 0) of std_logic_vector(31 downto 0);
end package vector_type;