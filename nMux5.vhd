library IEEE;
use IEEE.std_logic_1164.all;

entity nMux5 is
  port(i_A     : in std_logic_vector(4 downto 0);
       i_B     : in std_logic_vector(4 downto 0);
       i_x     : in std_logic;
       o_F     : out std_logic_vector(4 downto 0));
end nMux5;

architecture dataflow of nMux5 is
 	
begin

with i_X select
o_F <= i_A when '0', i_B when others;

end dataflow;