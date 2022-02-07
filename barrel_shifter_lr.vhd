library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter_lr is
   port(input      : in std_logic_vector(31 downto 0);
	shift_num  : in std_logic_vector(4 downto 0);
	arithmetic : in std_logic;
	shift_dir  : in std_logic;
	output     : out std_logic_vector(31 downto 0));
end barrel_shifter_lr;

architecture structure of barrel_shifter_lr is

component nMux2
    port ( i_A  : in  STD_LOGIC;
           i_B  : in  STD_LOGIC;
           i_X  : in  STD_LOGIC;
           o_F    : out STD_LOGIC);
end component;

signal fill  : std_logic;

signal temp, temp0, temp1, temp2, temp3, temp4 : std_logic_vector(31 downto 0);

begin

-- INPUT

process (input, shift_num, shift_dir)
	begin
	if shift_dir = '0' then
		temp <= input;
	else
		temp(0)  <= input(31);
		temp(1)  <= input(30);
		temp(2)  <= input(29);
		temp(3)  <= input(28);
		temp(4)  <= input(27);
		temp(5)  <= input(26);
		temp(6)  <= input(25);
		temp(7)  <= input(24);
		temp(8)  <= input(23);
		temp(9)  <= input(22);
		temp(10) <= input(21);
		temp(11) <= input(20);
		temp(12) <= input(19);
		temp(13) <= input(18);
		temp(14) <= input(17);
		temp(15) <= input(16);
		temp(16) <= input(15);
		temp(17) <= input(14);
		temp(18) <= input(13);
		temp(19) <= input(12);
		temp(20) <= input(11);
		temp(21) <= input(10);
		temp(22) <= input(9);
		temp(23) <= input(8);
		temp(24) <= input(7);
		temp(25) <= input(6);
		temp(26) <= input(5);
		temp(27) <= input(4);
		temp(28) <= input(3);
		temp(29) <= input(2);
		temp(30) <= input(1);
		temp(31) <= input(0);	
	end if;
end process;

filbit: nMux2 
	port map ('0', temp(31), arithmetic, fill);

-- Shift_num(0)

temp0_muxes: for i in 0 to 30 generate
  temp_i: nMux2 port map(temp(i), temp(i + 1), shift_num(0), temp0(i));
end generate;

temp_31: nMux2 port map (temp(31), fill, shift_num(0), temp0(31));

-- Shift_num(1)

temp1_muxes: for i in 0 to 29 generate
  temp1_i: nMux2 port map(temp0(i), temp0(i + 2), shift_num(1), temp1(i));
end generate;

temp1_mux_31: nMux2 port map (temp0(31), fill, shift_num(1), temp1(31));

temp1_mux_30: nMux2 port map (temp0(30), fill, shift_num(1), temp1(30));

-- Shift_num(2)

temp2_muxes_0: for i in 0 to 27 generate
  temp2_i_0: nMux2 port map(temp1(i), temp1(i + 4), shift_num(2), temp2(i));
end generate;

temp2_muxes_1: for i in 28 to 31 generate
  temp2_i_1: nMux2 port map (temp1(i), fill, shift_num(2), temp2(i));
end generate;

-- Shift_num(3)

temp3_muxes_0: for i in 0 to 23 generate
  temp3_i_0: nMux2 port map(temp2(i), temp2(i + 8), shift_num(3), temp3(i));
end generate;

temp3_muxes_1: for i in 24 to 31 generate
  temp3_i_1: nMux2 port map (temp2(i), fill, shift_num(3), temp3(i));
end generate;

-- Shift_num(4)

temp4_muxes_0: for i in 0 to 15 generate
  temp4_i_0: nMux2 port map(temp3(i), temp3(i + 16), shift_num(4), temp4(i));
end generate;

temp4_muxes_1: for i in 16 to 31 generate
  temp4_i_1: nMux2 port map (temp3(i), fill, shift_num(4), temp4(i));
end generate;

-- OUTPUT

process (temp4, shift_num, shift_dir)
	begin
	if shift_dir = '0' then
		output <= temp4;
	else
		output(0)  <= temp4(31);
		output(1)  <= temp4(30);
		output(2)  <= temp4(29);
		output(3)  <= temp4(28);
		output(4)  <= temp4(27);
		output(5)  <= temp4(26);
		output(6)  <= temp4(25);
		output(7)  <= temp4(24);
		output(8)  <= temp4(23);
		output(9)  <= temp4(22);
		output(10) <= temp4(21);
		output(11) <= temp4(20);
		output(12) <= temp4(19);
		output(13) <= temp4(18);
		output(14) <= temp4(17);
		output(15) <= temp4(16);
		output(16) <= temp4(15);
		output(17) <= temp4(14);
		output(18) <= temp4(13);
		output(19) <= temp4(12);
		output(20) <= temp4(11);
		output(21) <= temp4(10);
		output(22) <= temp4(9);
		output(23) <= temp4(8);
		output(24) <= temp4(7);
		output(25) <= temp4(6);
		output(26) <= temp4(5);
		output(27) <= temp4(4);
		output(28) <= temp4(3);
		output(29) <= temp4(2);
		output(30) <= temp4(1);
		output(31) <= temp4(0);	
	end if;
end process;

end structure;
