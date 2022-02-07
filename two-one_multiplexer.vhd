library IEEE;
use IEEE.std_logic_1164.all;

entity two_one_multiplexer is

  port(i_C, i_D, i_S  : in std_logic;
       o_M  : out std_logic);

end two_one_multiplexer;

architecture structure of two_one_multiplexer is

component andg2
  	port(i_A, i_B  : in std_logic;
       	     o_F  : out std_logic);
end component;

component org2
	port(i_A, i_B  : in std_logic;
       	     o_F  : out std_logic);
end component;

component invg
  	port(i_A  : in std_logic;
       	     o_F : out std_logic);
end component;

signal sVALUE_SB, sVALUE_S, sVALUE_SA : std_logic;

begin

  g_and_SB: andg2
    port MAP(i_A               => i_S,
             i_B               => i_D,
             o_F               => sVALUE_SB);

  g_inv_S: invg
    port MAP(i_A               => i_S,
             o_F               => sVALUE_S);

  g_and_SA: andg2
    port MAP(i_A               => sVALUE_S,
             i_B               => i_C,
             o_F               => sVALUE_SA);

  g_or: org2
    port MAP(i_A               => sVALUE_SB,
             i_B               => sVALUE_SA,
             o_F               => o_M);
  
end structure;