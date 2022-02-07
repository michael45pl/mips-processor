library IEEE;
use IEEE.std_logic_1164.all;

entity one_bit_alu is

  port(rs, rt, Less, Cin : in std_logic;
       my_opcode : in std_logic_vector(5 downto 0);
       O_out, C_out, set, overflow : out std_logic);

end one_bit_alu;

architecture behavioral of one_bit_alu is

component full_adder_struct
  	port(i_A, i_B  : in std_logic;
       	     i_C : in std_logic;
             o_SUM, o_Cout : out std_logic);
end component;

signal sNewB, sVALUE_AND, sVALUE_OR, sVALUE_XOR, sVALUE_NAND, sVALUE_NOR, sVALUE_ADD_SUB, sVALUE_MUX_ONE, sVALUE_XOR2, sVALUE_DATA, sVALUE_OVFLOW, sVALUE_COUT : std_logic;

begin

	sVALUE_AND 	<= rs AND rt;
	sVALUE_OR	<= rs OR rt;
	sVALUE_XOR	<= rs XOR rt;
	sVALUE_NAND	<= rs NAND rt;
	sVALUE_NOR	<= rs NOR rt;
	
	with my_opcode select 
	sVALUE_DATA <=
		'1'	when	"000101",
		'1'	when	"000111",
		'0'	when	others;



--was here

	sVALUE_XOR2 	<= sVALUE_DATA XOR rt;
	
	with my_opcode select
	sNewB <=
		rt when "000101",
		not rt when "000111",
		rt when others;

	adder_subber : full_adder_struct
	port MAP(i_A               => rs,
             	 i_B               => sValue_XOR2,
		 i_C		   => Cin,
		 o_SUM		   => sVALUE_ADD_SUB,
		 o_Cout		   => sVALUE_COUT);


--now here
	with my_opcode select
	O_out <=
	sVALUE_AND	when	"000000",
	sVALUE_OR	when	"000001",
	sVALUE_XOR	when	"000010",
	sVALUE_NAND	when	"000011",
	sVALUE_NOR	when	"000100",
	Less		when	"000101",
	sVALUE_ADD_SUB	when	"000110",
	sVALUE_ADD_SUB	when	"000111",
	'0'		when	others;

--to here
	C_out		<= sVALUE_COUT;
	sVALUE_OVFLOW	<= sVALUE_COUT XOR Cin;
	overflow	<= sVALUE_OVFLOW;
	set		<= sVALUE_OVFLOW XOR sVALUE_ADD_SUB;

end behavioral;