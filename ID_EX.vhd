library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
generic(N : integer := 32);
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   : in std_logic;     -- Reset input
       	i_Run    : in std_logic;     -- Write enable input
	i_ALUop		: in std_logic_vector(5 downto 0);
	i_RegAddr	: in std_logic_vector(4 downto 0);
       	i_JumpAddr, i_PC, i_RsOut, i_RtOut, i_ImmExt, i_Reg2, i_Inst	: in std_logic_vector(N-1 downto 0);
	i_ALUControl, i_MemToReg, i_RegWE, i_ALUSrc, i_Jump, i_Branch, i_MemWE, i_Upper, i_Jal, i_Jr, i_Bne  : in std_logic;
	o_ALUop		: out std_logic_vector(5 downto 0);
	o_RegAddr	: out std_logic_vector(4 downto 0);
       	o_JumpAddr, o_PC, o_RsOut, o_RtOut, o_ImmExt, o_Reg2, o_Inst	: out std_logic_vector(N-1 downto 0);
	o_ALUControl, o_MemToReg, o_RegWE, o_ALUSrc, o_Jump, o_Branch, o_MemWE, o_Upper, o_Jal, o_Jr, o_Bne  : out std_logic);
end ID_EX;

architecture mixed of ID_EX is
  signal s_iJumpAddr, s_iPC, s_iRsOut, s_iRtOut, s_iImmExt, s_iReg2, s_iInst   : std_logic_vector(N-1 downto 0);
  signal s_iMemToReg, s_iRegWE, s_iALUSrc, s_iALUControl, s_iJump, s_iBranch, s_iMemWE, s_iUpper, s_iJal, s_iJr, s_iBne  :std_logic;
  signal s_iALUop  : std_logic_vector(5 downto 0);
  signal s_iRegAddr : std_logic_vector(4 downto 0);
  signal s_oJumpAddr, s_oPC, s_oRsOut, s_oRtOut, s_oImmExt, s_oReg2, s_oInst   : std_logic_vector(N-1 downto 0);
  signal s_oMemToReg, s_oRegWE, s_oALUSrc, s_oALUControl, s_oJump, s_oBranch, s_oMemWE, s_oUpper, s_oJal, s_oJr, s_oBne  :std_logic;
  signal s_oALUop : std_logic_vector(5 downto 0);
  signal s_oRegAddr : std_logic_vector(4 downto 0);

begin

  -- The output of the FF is fixed to s_Q
  o_Inst <= s_oInst;
  o_MemToReg <= s_oMemToReg;
  o_RegWE <= s_oRegWe;
  o_JumpAddr <= s_oJumpAddr; 
  o_PC <= s_oPC; 
  o_ALUSrc <= s_oALUSrc;
  o_ALUControl <= s_oALUControl;
  o_Jump <= s_oJump;
  o_Branch <= s_oBranch;
  o_MemWE <= s_oMemWE;  
  o_ALUop <= s_oALUop;
  o_Upper <= s_oUpper;
  o_Jal <= s_oJal; 
  o_Jr <= s_oJr;
  o_RsOut <= s_oRsOut; 
  o_RtOut <= s_oRtOut; 
  o_ImmExt <= s_oImmExt;
  o_RegAddr <= s_oRegAddr;
  o_Bne <= s_oBne;
  o_Reg2 <= s_oReg2;
  
  -- Create a multiplexed input to the FF based on i_WE
  with i_Run select
    s_iInst <= i_Inst when '1',
           s_oInst when others;
  with i_Run select
    s_iMemToReg <= i_MemToReg when '1',
           s_oMemToReg when others;
 with i_Run select
  s_iRegWE <= i_RegWE when '1',
           s_oRegWE when others;
  with i_Run select
    s_iJumpAddr <= i_JumpAddr when '1',
           s_oJumpAddr when others;
 with i_Run select
  s_iPC <= i_PC when '1',
           s_oPC when others;
  with i_Run select
    s_iALUSrc <= i_ALUSrc when '1',
           s_oALUSrc when others;
 with i_Run select
  s_iALUControl <= i_ALUControl when '1',
           s_oALUControl when others;
  with i_Run select
    s_iJump <= i_Jump when '1',
           s_oJump when others;
 with i_Run select
  s_iBranch <= i_Branch when '1',
           s_oBranch when others;
  with i_Run select
    s_iMemWE <= i_MemWE when '1',
           s_oMemWE when others;
 with i_Run select
  s_iALUop <= i_ALUop when '1',
           s_oALUop when others;
  with i_Run select
    s_iUpper <= i_Upper when '1',
           s_oUpper when others;
 with i_Run select
  s_iJal <= i_Jal when '1',
           s_oJal when others;
  with i_Run select
    s_iJr <= i_Jr when '1',
           s_oJr when others;
 with i_Run select
  s_iRsOut <= i_RsOut when '1',
           s_oRsOut when others;
  with i_Run select
    s_iRtOut <= i_RtOut when '1',
           s_oRtOut when others;
 with i_Run select
  s_iImmExt <= i_ImmExt when '1',
           s_oImmExt when others;
  with i_Run select
    s_iRegAddr <= i_RegAddr when '1',
           s_oRegAddr when others;
 with i_Run select
  s_iBne <= i_Bne when '1',
           s_oBne when others;
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
	s_oRegAddr <= "00000";
	s_oMemToReg <= '0';
	s_oRegWE <= '0';
	s_oJumpAddr <= x"00000000";
	s_oPC <= x"00000000";
	s_oALUSrc <= '0';
	s_oALUControl <= '0';
	s_oJump <= '0';
	s_oBranch <= '0';
	s_oMemWE <= '0';
	s_oALUop <= "000000";
	s_oUpper <= '0';
	s_oJal <= '0';
	s_oJr <= '0';
	s_oBne <= '0';
	s_oRsOut <= x"00000000";
	s_oRtOut <= x"00000000";
	s_oImmExt <= x"00000000";
	s_oReg2 <= x"00000000";
    elsif (rising_edge(i_CLK)) then
	s_oInst <= s_iInst;
	s_oRegAddr <= s_iRegAddr;
	s_oMemToReg <= s_iMemToReg;
	s_oRegWE <= s_iRegWE;
	s_oJumpAddr <= s_iJumpAddr;
	s_oPC <= s_iPC;
	s_oALUSrc <= s_iALUSrc;
	s_oALUControl <= s_iALUControl;
	s_oJump <= s_iJump;
	s_oBranch <= s_iBranch;
	s_oMemWE <= s_iMemWE;
	s_oALUop <= s_iALUop;
	s_oUpper <= s_iUpper;
	s_oJal <= s_iJal;
	s_oJr <= s_iJr;
	s_oRsOut <= s_iRsOut;
	s_oRtOut <= s_iRtOut;
	s_oImmExt <= s_iImmExt;
	s_oBne <= s_iBne;
	s_oReg2 <= s_iReg2;
    end if;


  end process;
  
end mixed;