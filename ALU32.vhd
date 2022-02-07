library IEEE;
use IEEE.std_logic_1164.all;

entity ALU32 is
  -- generic(N : integer := 14);
  port(i_opcode  : in std_logic_vector(5 downto 0);
	i_rs, i_rt : in std_logic_vector(31 downto 0); --Ainvert and Binvert
	o_Out : out std_logic_vector(31 downto 0); --Output of the number
        o_C, o_Ov, o_Set : out std_logic); --Carry Out and Overflow and Zero
end ALU32;

architecture structure of ALU32 is
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



	-- signal s_Less : std_logic;
	signal s_Cin : std_logic;
	signal arth : std_logic;
	signal op : std_logic_vector(5 downto 0);
	signal temp_Out, shift_out : std_logic_vector(31 downto 0);
	signal s_SLT : std_logic_vector (31 downto 0) := x"00000000";
	signal s_Carries : std_logic_vector(31 downto 0) := (others => '0');

	-- signal Results : std_logic_vector(31 downto 0) := (others => '0');

	--signal ov : std_logic := '0';


begin
	alu1_0 : one_bit_alu
		port map(rs 		=> i_rs(0),
			 rt 		=> i_rt(0),
			 Less 		=> i_opcode(3),
			 Cin 		=> i_opcode(4),

			 my_opcode 	=> i_opcode,

			 O_out 		=> temp_Out(0),
			 C_out 		=> s_Carries(0),

			 set 		=> s_SLT(0));


			
	DUT11 : for i in 1 to 31 - 1  generate 
		alu1bit : one_bit_alu
			port map (rs 		=> i_rs(i),
				  rt 		=> i_rt(i),

				  Less 		=> s_SLT(i - 1),
				  Cin 		=> s_Carries(i - 1),
				  my_opcode 	=> i_opcode,

				  O_out 	=> temp_Out(i),
				  C_out 	=> s_Carries(i),
				  set 		=> s_SLT(i));

				-- overflow => 

	end generate;
	alu31 : one_bit_alu
		port map (rs 		=> i_rs(31),
			  rt 		=> i_rt(31),

			  Less 		=> s_SLT(30),

			  Cin 		=> s_Carries(30),

			  my_opcode 	=> i_opcode,

			  O_out 	=> temp_Out(31),

			  C_out 	=> o_C,

			  set 		=> o_Set,

		          overflow 	=> o_Ov);
	
shift : process(op)
	begin
		if(op = "000000") then
			arth <= '0';
		else
			arth <='1';
		end if;
	end process;
	

shifter : barrel_shifter_lr
		port map(input => i_rs, 
			arithmetic => arth, 
			shift_dir => '1', 
			shift_num => i_rt(10 downto 6),
			output => shift_out);

	op <= i_opcode;	

outputs : process(op)
	begin
		if(op = "000000") then
			o_Out <= shift_out;
		else
			if(op = "000010") then 
				o_Out <= shift_out;
			else
				o_Out <= temp_Out;
			end if;
		end if;
	end process;
end structure;