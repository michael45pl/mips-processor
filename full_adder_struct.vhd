library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_struct is

  port(i_A, i_B  : in std_logic;
       i_C : in std_logic;
       o_SUM, o_Cout : out std_logic);

end full_adder_struct;

architecture structure of full_adder_struct is

component andg2
  	port(i_A, i_B : in std_logic;
       	     o_F  : out std_logic);
end component;

component org2
  	port(i_A, i_B : in std_logic;
       	     o_F  : out std_logic);
end component;

component xorg2
  	port(i_A, i_B : in std_logic;
       	     o_F  : out std_logic);
end component;

signal sVALUE_A_B, sVALUE_SC, sVALUE_AB : std_logic;

begin
	
	x_or_A_B : xorg2
	port MAP(i_A               => i_A,
             	 i_B               => i_B,
		 o_F		   => sVALUE_A_B);

	x_or_S_C : xorg2
	port MAP(i_A               => sVALUE_A_B,
             	 i_B               => i_C,
		 o_F		   => o_SUM);

	and_AC : andg2
	port MAP(i_A               => sVALUE_A_B,
             	 i_B               => i_C,
		 o_F		   => sVALUE_SC);

	and_AB : andg2
	port MAP(i_A               => i_A,
             	 i_B               => i_B,
		 o_F		   => sVALUE_AB);

	or_c : org2
	port MAP(i_A               => sVALUE_AB,
             	 i_B               => sVALUE_SC,
		 o_F		   => o_Cout);
	
end structure;