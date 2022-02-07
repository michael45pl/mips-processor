library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WB is
generic(N : integer := 32);
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   : in std_logic;     -- Reset input
       	i_Run    : in std_logic;     -- Write enable input
       	i_ALUout, i_MemOut, i_Reg2, i_MemAddr, i_MemData, i_Inst	: in std_logic_vector(N-1 downto 0);
	i_RegAddr		: in std_logic_vector(4 downto 0);
	i_MemToReg, i_RegWE, i_MemWr 	: in std_logic;
        o_ALUout, o_MemOut, o_Reg2, o_MemAddr, o_MemData, o_Inst	: out std_logic_vector(N-1 downto 0);
	o_RegAddr		: out std_logic_vector(4 downto 0);
	o_MemToReg, o_RegWE, o_MemWr 	: out std_logic);
end MEM_WB;

architecture mixed of MEM_WB is
  signal s_iALUout, s_iMemOut, s_iReg2, s_iMemAddr, s_iMemData, s_iInst  : std_logic_vector(N-1 downto 0);
  signal s_iRegAddr			: std_logic_vector(4 downto 0);
  signal s_iMemToReg, s_iRegWE, s_iMemWr		: std_logic;
  signal s_oALUout, s_oMemOut, s_oReg2, s_oMemAddr, s_oMemData, s_oInst 	: std_logic_vector(N-1 downto 0);
  signal s_oRegAddr			: std_logic_vector(4 downto 0);
  signal s_oMemToReg, s_oRegWE, s_oMemWr 	: std_logic;

begin

  -- The output of the FF is fixed to s_Q
  o_Inst <= s_oInst;
  o_MemAddr <= s_oMemAddr;
  o_MemData <= s_oMemData;
  o_MemWr <= s_oMemWr;
  o_RegAddr <= s_oRegAddr;
  o_MemToReg <= s_oMemToReg;
  o_RegWE <= s_oRegWe;
  o_ALUout <= s_oALUout;
  o_MemOut <= s_oMemOut; 
  o_Reg2 <= s_oReg2;
  
  -- Create a multiplexed input to the FF based on i_WE
  with i_Run select    
    s_iInst <= i_Inst when '1',
           s_oInst when others;
  with i_Run select
    s_iMemAddr <= i_MemAddr when '1',
           s_oMemAddr when others;
  with i_Run select
    s_iMemData <= i_MemData when '1',
           s_oMemData when others;
  with i_Run select
    s_iMemWr <= i_MemWr when '1',
           s_oMemWr when others;
  with i_Run select
    s_iRegAddr <= i_RegAddr when '1',
           s_oRegAddr when others;
 with i_Run select
  s_iMemToReg <= i_MemToReg when '1',
           s_oMemToReg when others;
  with i_Run select
    s_iRegWE <= i_RegWE when '1',
           s_oRegWE when others;
 with i_Run select
  s_iALUout <= i_ALUout when '1',
           s_oALUout when others;
 with i_Run select
  s_iMemOut <= i_MemOut when '1',
	   s_oMemOut when others;
 with i_Run select
  s_iReg2 <= i_Reg2 when '1',
	   s_oReg2 when others;


  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_CLRN)
  begin
    if (i_CLRN = '1') then
	s_oInst <= x"00000000";
	s_oMemAddr <= x"00000000";
	s_oMemData <= x"00000000";
	s_oMemWr <= '0';
	s_oRegAddr <= "00000";
	s_oMemToReg <= '0';
	s_oRegWE <= '0';
	s_oALUout <= x"00000000";
	s_oMemOut <= x"00000000";
	s_oReg2 <= x"00000000";
    elsif (rising_edge(i_CLK)) then
	s_oInst <= s_iInst;
	s_oMemAddr <= s_iMemAddr;
	s_oMemData <= s_iMemData;
	s_oMemWr <= s_iMemWr;
	s_oRegAddr <= s_iRegAddr;
	s_oMemToReg <= s_iMemToReg;
	s_oRegWE <= s_iRegWE;
	s_oALUout <= s_iALUout;
	s_oMemOut <= s_iMemOut;
	s_oReg2 <= s_iReg2;
    end if;


  end process;
  
end mixed;