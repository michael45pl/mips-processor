library IEEE;
use IEEE.std_logic_1164.all;
use iEEE.numeric_std.all;
use work.regarr.all;

entity mux32_1 is

  port(i_D : in reg_arr;
       i_S : in std_logic_vector(4 downto 0);
       o_Out : out std_logic);

end mux32_1;

architecture dataflow of mux32_1 is

begin

	o_Out <= i_D(to_integer(unsigned(i_S)));

end dataflow;