library IEEE;
use IEEE.std_logic_1164.all;

entity muxflowN is
  port(i_A     : in std_logic_vector(31 downto 0);
       i_B     : in std_logic_vector(31 downto 0);
       i_X     : in std_logic;
       o_F     : out std_logic_vector(31 downto 0));
end muxflowN;

architecture dataflow of muxflowN is
 	
begin

with i_X select
o_F <= i_A when '0', i_B when others;

end dataflow;