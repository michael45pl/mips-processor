library IEEE;
use IEEE.std_logic_1164.all;

entity nMux2 is
  port(i_A     : in std_logic;
       i_B     : in std_logic;
       i_X     : in std_logic;
       o_F     : out std_logic);
end nMux2;

architecture dataflow of nMux2 is
 	
begin

with i_X select
o_F <= i_A when '0', i_B when others;

end dataflow;