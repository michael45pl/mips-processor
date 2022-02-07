library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_SHIFTER is
  -- generic(N : integer := 14);
  port(i_opcode  : in std_logic_vector(5 downto 0);
	ALU_control : in std_logic;  --0 is ALU 1 is shifter
	i_rs, i_rt : in std_logic_vector(31 downto 0); --Ainvert and Binvert
	o_Out : out std_logic_vector(31 downto 0); --Output of the number
        zero : out std_logic); --Carry Out and Overflow and Zero
end ALU_SHIFTER;

architecture structure of ALU_SHIFTER is
	component one_bit_alu
		port(rs, rt, Less, Cin : in std_logic;
       			my_opcode : in std_logic_vector(5 downto 0);
       			O_out, C_out, set, overflow : out std_logic);
	end component;

	component barrel_shifter_lr
	 	port(	input      : in std_logic_vector(31 downto 0);
			shift_num  : in std_logic_vector(4 downto 0);
			arithmetic : in std_logic;
			shift_dir  : in std_logic;
			output     : out std_logic_vector(31 downto 0));
	end component;

	component org2 
		port(i_A          : in std_logic;
       		     i_B          : in std_logic;
     		     o_F          : out std_logic);
	end component;

	component org32
		port(i_A	  : in std_logic_vector(31 downto 0);
		     o_F	  : out std_logic);
	end component;



	-- signal s_Less : std_logic;
	signal s_CarryIn, s_C, s_Ov, s_Set : std_logic;
	signal s_Cin : std_logic;
	signal arth, s_bne : std_logic;
	signal op : std_logic_vector(5 downto 0);
	signal temp_Out, shift_out : std_logic_vector(31 downto 0);
	signal s_SLT : std_logic_vector (31 downto 0) := x"00000000";
	signal s_Carries : std_logic_vector(31 downto 0) := (others => '0');

	-- signal Results : std_logic_vector(31 downto 0) := (others => '0');

	--signal ov : std_logic := '0';


begin

  op <= i_opcode;

  with i_opcode select
	s_CarryIn <= '1' when "000111",
	'1' when "000101",
	i_opcode(4) when others;
	

	alu1_0 : one_bit_alu
		port map(rs 		=> i_rs(0),
			 rt 		=> i_rt(0),
			 Less 		=> s_SLT(31),
			 Cin 		=> s_CarryIn,
			 my_opcode 	=> op,
			 O_out 		=> temp_Out(0),
			 C_out 		=> s_Carries(0),
			 set 		=> s_SLT(0));


			
	DUT11 : for i in 1 to 31 - 1  generate 
		alu1bit : one_bit_alu
			port map (rs 		=> i_rs(i),
				  rt 		=> i_rt(i),

				  Less 		=> '0',
				  Cin 		=> s_Carries(i - 1),
				  my_opcode 	=> op,

				  O_out 	=> temp_Out(i),
				  C_out 	=> s_Carries(i),
				  set 		=> s_SLT(i));

				-- overflow => 

	end generate;
	alu31 : one_bit_alu
		port map (rs 		=> i_rs(31),
			  rt 		=> i_rt(31),
			  Less 		=> '0',
			  Cin 		=> s_Carries(30),
			  my_opcode 	=> op,
			  O_out 	=> temp_Out(31),
			  C_out 	=> s_C,
			  set 		=> s_SLT(31),
		          overflow 	=> s_Ov);

	

	
zeroer : org32
		port map(i_A => temp_Out,
			 o_F => zero);




shifter : barrel_shifter_lr
		port map(input => i_rs, 
			arithmetic => op(0), --1 is arthimatic
			shift_dir => op(1),  --1 is right
			shift_num => i_rt(10 downto 6),
			output => shift_out);

  with ALU_control select
    o_Out <= temp_Out when '0',
      shift_out when others;





end structure;