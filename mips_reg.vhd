library IEEE;
use IEEE.std_logic_1164.all;
use work.vector_type.all;

entity mips_reg is
generic(N : integer := 32);
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN      	: in std_logic;     -- Reset input
       	i_WE		: in std_logic;
	jal_enable	: in std_logic;
	jal_data, i_rd	: in std_logic_vector(N-1 downto 0);
       	rd_add, rt_add, rs_add : in std_logic_vector(4 downto 0);
      	o_reg2, o_rs, o_rt   	: out std_logic_vector(N-1 downto 0));
end mips_reg;

architecture mixed of mips_reg is
  signal s_D    : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
  signal s_Q    : std_logic_vector(N-1 downto 0);    -- Output of the FF

component mux_32t1
   port(mux_In  :	in reg_inputs;
	mux_S	:	in std_logic_vector(4 downto 0);
	mux_O	:	out std_logic_vector(N-1 downto 0));
end component;

component nDecoder5_to_32
   port(i_WE	     : in std_logic;
	i_D          : in std_logic_vector(4 downto 0);     -- Data value input
        o_F          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component nRegister
   port(i_CLK        : in std_logic;     -- Clock input
        i_CLRN        : in std_logic;     -- Reset input
        i_S         : in std_logic;     -- Write enable input
        i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
        o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal WE : std_logic_vector(N-1 downto 0);
signal mux : reg_inputs;

begin

nDec_i : nDecoder5_to_32
   port map(i_WE => i_WE,
	    i_D => rd_add,
	    o_F => WE);


G1: for i in 0 to 30 generate
   nReg_i : nRegister
     port map(i_CLK => i_CLK,
      	      i_CLRN => i_CLRN,
       	      i_S => WE(i),
       	      i_D => i_rd,
              o_Q => mux(i));
end generate;

  nReg_31 : nRegister
    port map(i_CLK => i_CLK,
		i_CLRN => i_CLRN,
		i_S => jal_enable,
		i_D => jal_data,
		o_Q => mux(31));
 o_reg2 <= mux(2);

rs_mux_i : mux_32t1
   port map (mux_In =>  mux,
	mux_S => rs_add,
	mux_O => o_rs);

rt_mux_i : mux_32t1
   port map (mux_In => mux,
	mux_S => rt_add,
	mux_O => o_rt);

  
end mixed;