library IEEE;
use IEEE.std_logic_1164.all;

entity org32 is

  port(i_A           	: in std_logic_vector(31 downto 0);
        o_F          	: out std_logic);

end org32;



architecture mixed of org32 is

component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


signal temp : std_logic_vector(15 downto 0);
signal temp2: std_logic_vector(7 downto 0);
signal temp3: std_logic_vector(3 downto 0);
signal temp4: std_logic_vector(1 downto 0);
signal temp5: std_logic;

begin

	dut1 : for i in 0 to 15 generate
		or1 : org2 
			port map(i_A => i_A(i),
				i_B => i_A(i+16),
				o_F => temp(i));
	end generate;

	dut2 : for i in 0 to 7 generate
		or2 : org2 
			port map(i_A => temp(i),
				i_B => temp(8+i),
				o_F => temp2(i));
	end generate;

	dut3 : for i in 0 to 3 generate
		or3 : org2 
			port map(i_A => temp2(i),
				i_B => temp2(i+4),
				o_F => temp3(i));
	end generate;

	dut4 : for i in 0 to 1 generate
		or4 : org2 
			port map(i_A => temp3(i),
				i_B => temp3(i+2),
				o_F => temp4(i));
	end generate;
	
	ored: org2
	port map(i_A => temp4(0),
		i_B => temp4(1),
		o_F => temp5);

	o_F <= not temp5;

	
  
end mixed;