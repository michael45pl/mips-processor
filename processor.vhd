library IEEE;
use IEEE.std_logic_1164.all;

entity processor is
  generic(N : integer := 32);
  port(i_rt, i_rs, i_rd : in std_logic_vector(4 downto 0);
       i_OP : in std_logic_vector (5 downto 0);
       i_ALUcon, memToReg, regWrite, memWrite, ALUSrc : in std_logic;
       i_IMM : in std_logic_vector(15 downto 0);
       i_clk : in std_logic;
	carry_flag, flow_flag, set_flag : out std_logic);
end processor;

architecture structure of processor is

component mem is
	generic (DATA_WIDTH : natural := 32;
		 ADDR_WIDTH : natural := 10
	);

	port (
		clk: in std_logic;
		addr: in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we: in std_logic := '1';
		q: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

component extendsign is 
	port (
        	i_I : in std_logic_vector(15 downto 0);
        i_S        : in std_logic;
        o_EXV : out std_logic_vector(31 downto 0)
  	);
end component;

component regfile is
	--generic (N: integer :=32);
	port (i_CLK : in std_logic;
	      i_E : in std_logic; --Enable
		i_R : in std_logic; --Reset
		i_WD : in std_logic_vector(N-1 downto 0); --Write Data

		i_WA : in std_logic_vector(4 downto 0); --Write Address
		i_RAA : in std_logic_vector(4 downto 0); --Read Address A
		i_RBA : in std_logic_vector(4 downto 0); --Read Address B

		o_DA : out std_logic_vector(N-1 downto 0); --Data Output A
		o_DB : out std_logic_vector(N-1 downto 0)); --Data Output B 
end component;


component muxflowN is
	--generic(N : integer := 32);
	port(i_A  : in std_logic_vector(N-1 downto 0);
		i_B  : in std_logic_vector(N-1 downto 0);
		i_X  : in std_logic; 
		o_F  : out std_logic_vector(N-1 downto 0));

end component;


component ALU_SHIFTER is
  -- generic(N : integer := 14);
  port(i_opcode    : in std_logic_vector(5 downto 0);
	ALU_control : in std_logic;  --0 is ALU 1 is shifter
	i_rs, i_rt : in std_logic_vector(31 downto 0); --Ainvert and Binvert
	o_Out      : out std_logic_vector(31 downto 0); --Output of the number
        o_C, o_Ov, o_Set : out std_logic); --Carry Out and Overflow and Zero
end component;

--signals 

	signal s_mux, s_alu_out, s_reg_outA, s_reg_outB, s_ext_out, s_mem_q, reg_mux_out : std_logic_vector(N-1 downto 0);
	signal ctrl : std_logic_vector(4 downto 0);
begin
	
	memMUX : muxflowN
	port map(i_A => s_mem_q,
		i_B => s_alu_out,
		i_X => memToReg,
		o_F => s_mux);

	alu : ALU_SHIFTER
	port map(i_opcode => i_OP,
		i_rs => s_reg_outA,
		i_rt => reg_mux_out,
		ALU_control => i_ALUcon,
		o_Out => s_alu_out,
		o_C => carry_flag,
		o_Ov => flow_flag,
		o_Set => set_flag);

	regTOaluMUX : muxflowN
	port map(i_A => s_reg_outB,
		i_B => s_ext_out,
		i_X => ALUSrc,
		o_F => reg_mux_out);	

	--extend : extend
	
	extender : extendsign
	port map(i_I => i_IMM,
        	 i_S => '1',
        	 o_EXV => s_ext_out);

	memo : mem
	port map(clk => i_clk,
		addr => s_ext_out(11 downto 2),
		data => s_reg_outB,
		we => memWrite,
		q => s_mem_q);
	
	regg : regfile
	port map(i_CLK => i_clk,
	      i_E => regWrite, --Enable
		i_R => '0', --Reset
		i_WD => s_mux, --Write Data

		i_WA => i_rd, --Write Address
		i_RAA => i_rs, --Read Address A
		i_RBA => i_rt); --Read Address B
	
end structure;

	
	




