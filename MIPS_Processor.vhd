-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic; -- can ignore
       iInstAddr       : in std_logic_vector(N-1 downto 0); -- can ignore
       iInstExt        : in std_logic_vector(N-1 downto 0); -- can ignore
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;


  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
component extendsign is 
  port (i_I 		: in std_logic_vector(15 downto 0);
        i_S		: in std_logic;
       	o_EXV 		: out std_logic_vector(31 downto 0));
end component;

component mips_reg is	
   port(i_CLK       	: in std_logic;     -- Clock input
        i_CLRN      	: in std_logic;     -- Reset input
	i_WE		: in std_logic;
	jal_enable	: in std_logic;
	jal_data	: in std_logic_vector(N-1 downto 0);
        i_rd	     	: in std_logic_vector(N-1 downto 0);
        rd_add		: in std_logic_vector(4 downto 0); 
	rt_add		: in std_logic_vector(4 downto 0); 
        rs_add 		: in std_logic_vector(4 downto 0);
	o_reg2		: out std_logic_vector(N-1 downto 0); 
        o_rs		: out std_logic_vector(N-1 downto 0);  
        o_rt   		: out std_logic_vector(N-1 downto 0));
end component;


component muxflowN is
   port(i_A  		: in std_logic_vector(N-1 downto 0);
	i_B  		: in std_logic_vector(N-1 downto 0);
	i_X  		: in std_logic; 
	o_F  		: out std_logic_vector(N-1 downto 0));
end component;

component nMux2 is
  port(i_A     : in std_logic;
       i_B     : in std_logic;
       i_X     : in std_logic;
       o_F     : out std_logic);
end component;


component ALU_SHIFTER is
   port(i_opcode    	: in std_logic_vector(5 downto 0);
	ALU_control 	: in std_logic;  --0 is ALU 1 is shifter
	i_rs, i_rt 	: in std_logic_vector(31 downto 0); --Ainvert and Binvert
	o_Out      	: out std_logic_vector(31 downto 0); --Output of the number
        zero 		: out std_logic); --Carry Out and Overflow and Zero
end component;

component pc is
  port(i_CLK       	: in std_logic;     -- Clock input
       i_CLRN      	: in std_logic;     -- Reset input
       i_S          	: in std_logic;     -- Write enable input
       i_D          	: in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          	: out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

component control is
   port(func		: in std_logic_vector(5 downto 0);
	op  		: in std_logic_vector(5 downto 0);
	ALUControl 	: out std_logic_vector(5 downto 0);
	ALUSrc    	: out std_logic;
	ALU_shift    	: out std_logic;
	MemToReg   	: out std_logic;
	RegDst     	: out std_logic;
	s_DMemWr   	: out std_logic;
	s_RegWr    	: out std_logic;
	jump	   	: out std_logic;
	branch		: out std_logic;
	upper		: out std_logic;
	jr		: out std_logic;
	jal		: out std_logic;
	extend		: out std_logic;
	bne		: out std_logic);
end component;

component andg2 is
   port(i_A        	: in std_logic;
       	i_B       	: in std_logic;
       	o_F       	: out std_logic);
end component;

component invg is
   port(i_A          	: in std_logic;
       	o_F         	: out std_logic);
end component;

component org3 is
   port(i_A		: in std_logic;
    	i_B		: in std_logic;
	i_C		: in std_logic;
	o_F		: out std_logic);
end component;

component nMux5 is
   port(i_A     	: in std_logic_vector(4 downto 0);
       	i_B     	: in std_logic_vector(4 downto 0);
      	i_x     	: in std_logic;
       	o_F     	: out std_logic_vector(4 downto 0));
end component;

component IF_ID is
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   	: in std_logic;     -- Reset input
       	i_Run      	: in std_logic;     -- Write enable input
       	i_PC     	: in std_logic_vector(31 downto 0);     -- Data value input
       	i_INST 		: in std_logic_vector(31 downto 0);
       	o_PC		: out std_logic_vector(31 downto 0);
      	o_INST      	: out std_logic_vector(31 downto 0));   -- Data value output
end component;

component ID_EX is
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   	: in std_logic;     -- Reset input
       	i_Run    	: in std_logic;     -- Write enable input
	i_ALUop	 	: in std_logic_vector(5 downto 0);
	i_RegAddr	: in std_logic_vector(4 downto 0);
       	i_JumpAddr, i_PC, i_RsOut, i_RtOut, i_ImmExt, i_Reg2, i_Inst	: in std_logic_vector(N-1 downto 0);
	i_ALUControl, i_MemToReg, i_RegWE, i_ALUSrc, i_Jump, i_Branch, i_MemWE, i_Upper, i_Jal, i_Jr, i_Bne  : in std_logic;
	o_ALUop	 	: out std_logic_vector(5 downto 0);
	o_RegAddr	: out std_logic_vector(4 downto 0);
       	o_JumpAddr, o_PC, o_RsOut, o_RtOut, o_ImmExt, o_Reg2, o_Inst	: out std_logic_vector(N-1 downto 0);
	o_ALUControl, o_MemToReg, o_RegWE, o_ALUSrc, o_Jump, o_Branch, o_MemWE, o_Upper, o_Jal, o_Jr, o_Bne  : out std_logic);
end component;

component EX_MEM is	
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   	: in std_logic;     -- Reset input
       	i_Run    	: in std_logic;     -- Write enable input
       	i_ALUout, i_MemData, i_Reg2, i_MemAddr, i_Inst	: in std_logic_vector(31 downto 0);
	i_MemToReg, i_RegWE, i_MemWE  	: in std_logic;
	i_RegAddr			: in std_logic_vector(4 downto 0);
        o_ALUout, o_MemData, o_Reg2, o_MemAddr, o_Inst	: out std_logic_vector(31 downto 0);
	o_MemToReg, o_RegWE, o_MemWE  	: out std_logic;
	o_RegAddr			: out std_logic_vector(4 downto 0));
end component;

component MEM_WB is
   port(i_CLK   	: in std_logic;     -- Clock input
       	i_CLRN   	: in std_logic;     -- Reset input
       	i_Run    	: in std_logic;     -- Write enable input
       	i_ALUout, i_MemOut, i_Reg2, i_MemAddr, i_MemData, i_Inst	: in std_logic_vector(31 downto 0);
	i_RegAddr		: in std_logic_vector(4 downto 0);
	i_MemToReg, i_RegWE, i_MemWr 	: in std_logic;
        o_ALUout, o_MemOut, o_Reg2, o_MemAddr, o_MemData, o_Inst	: out std_logic_vector(31 downto 0);
	o_RegAddr		: out std_logic_vector(4 downto 0);
	o_MemToReg, o_RegWE, o_MemWr 	: out std_logic);
end component;


	signal s_Rs, s_Rt, s_ImmExt, s_PcInput, s_ImmShift2, s_PcPlus4, s_BranchAmount, s_ALUinput1, s_ALUinput2, s_ALUout, s_ImmUpper,
	s_PcPiece, s_InstShift2, s_InstPiece, s_JumpAddr, s_JumpMux1, s_newPC, s_Rt_upper, s_AluMemOut, s_PcJumps,
	s_Reg2	: std_logic_vector(N-1 downto 0);

	signal s_ALU_shift, s_RegWE, s_MemWE, s_zero, s_zeroInitail, s_notZeroInitail, s_ALUSRC, s_RegDst, s_bne, s_MemToReg, s_jump, 
	s_branch, s_takeBranch, s_upper, s_jal, s_jr, s_Ext, s_JumpsCon	: std_logic;
	signal s_opcode : std_logic_vector(5 downto 0);

	signal s_RegAdd, s_rsORrd, s_ID_RegAddr : std_logic_vector(4 downto 0);
	signal flag1, flag2, flag3, flag4, flag5, flag6, flag7, flag8 : std_logic;
	
	signal s_IF_IDFlush, s_IF_IDRun, s_ID_EXFlush, s_ID_EXRun, s_EX_MEMFlush, s_EX_MEMRun, s_MEM_WBFlush, s_MEM_WBRun : std_logic;
	signal s_EX_RegAddr, s_MEM_RegAddr, s_WB_RegAddr	: std_logic_vector(4 downto 0);

  	signal s_ID_PcPlus4, s_ID_Inst : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
	signal s_ID_RegWr, s_ID_DMemWr : std_logic;

	signal s_EX_JumpAddr, s_EX_PcPlus4, s_EX_Rs, s_EX_Rt, s_EX_ImmExt, s_EX_Reg2, s_EX_DMemAddr, s_EX_Inst   : std_logic_vector(N-1 downto 0);
  	signal s_EX_ALU_shift, s_EX_RegDst, s_EX_MemToReg, s_EX_RegWr, s_EX_ALUSRC, s_EX_jump, s_EX_branch, s_EX_DMemWr, s_EX_upper,
	s_EX_jal, s_EX_jr, s_EX_bne  :std_logic;
  	signal s_EX_opcode : std_logic_vector(5 downto 0);

	signal s_MEM_ALUout, s_MEM_DMemData, s_MEM_Reg2, s_MEM_DMemAddr, s_MEM_DMemOut, s_MEM_Inst 	: std_logic_vector(N-1 downto 0);
	signal s_MEM_MemToReg, s_MEM_RegWr, s_MEM_DMemWr : std_logic;

	signal s_WB_ALUout, s_WB_DMemOut, s_WB_Reg2, s_WB_Inst, s_v0	: std_logic_vector(N-1 downto 0);
	signal s_WB_MemToReg, s_WB_RegWr	: std_logic;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  s_Halt <='1' when (s_WB_Inst(31 downto 26) = "000000") and (s_WB_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 
	
	JumpsOrg:org3
   	port map(i_A =>		s_EX_jump,
    		i_B =>		s_EX_branch,
		i_C =>		s_EX_jr,
		o_F =>		s_JumpsCon);

	jrMux:muxflowN
	port map(i_A =>		s_newPC,  	
		i_B =>		s_EX_Rs,
		i_X =>		s_EX_jr, 
		o_F =>		s_PcJumps);

	PCplus4mux:muxflowN
	port map(i_A =>		s_PcPlus4,
		i_B =>		s_PcJumps,
		i_X =>		s_JumpsCon,
		o_F =>		s_PcInput);	

	pc_unit:pc
	port map(i_CLK => 	iCLK,
		i_CLRN =>	iRST,
		i_S =>		'1',--write enabled
		i_D => 		s_PcInput,
		o_Q => 		s_NextInstAddr);

	PCplus4:ALU_SHIFTER
	port map(i_opcode =>	"000110", 	
		ALU_control =>	'0',
		i_rs =>		s_NextInstAddr, 
		i_rt =>		x"00000004",
		o_Out =>	s_PcPlus4,
		zero =>		flag2);

	s_IF_IDRun <= '1';
	s_IF_IDFlush <= iRST;

	IFtoIDreg:IF_ID
	port map(i_CLK =>	iCLK,
      		i_CLRN =>	s_IF_IDFlush, 
       		i_Run =>	s_IF_IDRun,     
       		i_PC =>		s_PcPlus4,    
       		i_INST =>	s_Inst,
       		o_PC =>		s_ID_PcPlus4,	
       		o_INST =>	s_ID_Inst);

	--END of IF stage      

	PCslicer:ALU_SHIFTER
	port map(i_opcode =>	"000000", 	
		ALU_control =>	'0',
		i_rs =>		s_ID_PcPlus4, 
		i_rt =>		x"F0000000",
		o_Out =>	s_PcPiece,
		zero =>		flag4);

	shift2INST:ALU_SHIFTER
	port map(i_opcode =>	"000010", 	
		ALU_control =>	'1',
		i_rs =>		s_InstPiece, 
		i_rt =>		x"00000080",
		o_Out =>	s_InstShift2,
		zero =>		flag5);

	INSTslicer:ALU_SHIFTER
	port map(i_opcode =>	"000000", 	
		ALU_control =>	'0',
		i_rs =>		s_ID_Inst, 
		i_rt =>		x"03FFFFFF",
		o_Out =>	s_InstPiece,
		zero =>		flag6);

	PCplusINST:ALU_SHIFTER
	port map(i_opcode =>	"000110", 	
		ALU_control =>	'0',
		i_rs =>		s_PcPiece, 
		i_rt =>		s_InstShift2,
		o_Out =>	s_JumpAddr,
		zero =>		flag7);
	
	CU:control
	port map(op =>		s_ID_Inst(31 downto 26),
		func =>		s_ID_Inst(5 downto 0),
		ALUControl =>	s_opcode, 	
		ALUSrc =>	s_ALUSRC,
		ALU_shift =>	s_ALU_shift,
		MemToReg =>  	s_MemToReg,
		RegDst =>	s_RegDst,
		s_DMemWr =>  	s_ID_DMemWr,
		s_RegWr =>    	s_ID_RegWr,
		jump =>	   	s_jump,
		branch =>	s_branch,
		upper =>	s_upper,
		jr =>		s_jr,
		jal =>		s_jal,
		extend =>	s_Ext,
		bne =>		s_bne);

	rsORrdMux:nMux5
	port map(i_A =>		s_ID_Inst(20 downto 16),  	
		i_B =>		s_ID_Inst(15 downto 11),
		i_X =>		s_RegDst, 
		o_F =>		s_ID_RegAddr);

	regs:mips_reg
	port map(i_CLK =>  	iCLK,
       		i_CLRN =>     	iRST, -- Reset input
       		i_WE =>		s_RegWr,
		jal_enable =>   s_EX_jal,
		jal_data =>	s_EX_PcPlus4,
       		i_rd =>	    	s_RegWrData, --Write data 
       		rd_add =>	s_RegWrAddr,  --write add
		rs_add => 	s_ID_Inst(25 downto 21), --rs read add
		rt_add =>	s_ID_Inst(20 downto 16), -- rt read add
		o_reg2 =>	s_reg2,
      		o_rs =>		s_Rs,  --rs data
		o_rt =>  	s_Rt); --rt data
	v0 <=s_reg2;

	exted:extendsign
	port map(i_I => 	s_ID_Inst(15 downto 0),
		i_S =>		s_Ext,
		o_EXV => 	s_ImmExt);

	s_ID_EXRun <= '1';
	s_ID_EXFLush <= iRST;

	IDtoEXreg:ID_EX
	port map(i_CLK =>	iCLK,
      		i_CLRN =>	s_ID_EXFlush, 
       		i_Run =>	s_ID_EXRun, 
		i_RegAddr =>	s_ID_RegAddr,   
       		i_ALUop	=>	s_opcode,
       		i_JumpAddr =>	s_JumpAddr,
		i_PC =>         s_ID_PcPlus4,
		i_RsOut =>	s_Rs,	
		i_RtOut =>	s_Rt,
		i_ImmExt =>	s_ImmExt,
		i_ALUControl =>	s_ALU_shift,
		i_MemToReg =>	s_MemToReg,
		i_RegWE	=>	s_ID_RegWr,
		i_ALUSrc =>	s_ALUSRC,	
		i_Jump =>	s_jump,
		i_Branch =>	s_branch,
		i_MemWE =>	s_ID_DMemWr,
		i_Upper =>	s_upper,
		i_Jal =>	s_jal,
		i_Jr =>		s_jr,
		i_Bne =>	s_bne,
		i_Reg2 =>	s_Reg2,
		i_Inst =>	s_ID_Inst,
		o_RegAddr =>	s_EX_RegAddr,
		o_ALUop	=>	s_EX_opcode,
       		o_JumpAddr =>	s_EX_JumpAddr,
		o_PC =>		s_EX_PcPlus4,
		o_RsOut	=>	s_EX_Rs,
		o_RtOut =>	s_EX_Rt,
		o_ImmExt =>	s_EX_ImmExt,
		o_ALUControl =>	s_EX_ALU_shift,
		o_MemToReg =>	s_EX_MemToReg,
		o_RegWE =>	s_EX_RegWr,
		o_ALUSrc =>	s_EX_ALUSRC,
		o_Jump =>	s_EX_jump,
		o_Branch =>	s_EX_branch,
		o_MemWE =>	s_EX_DMemWr,
		o_Upper =>	s_EX_upper,
		o_Jal =>	s_EX_jal,
		o_Jr =>		s_EX_jr,
		o_Bne =>	s_EX_bne,
		o_Reg2 =>	s_EX_Reg2,
		o_Inst => 	s_EX_Inst);
	
	--End of ID stage	

	IMMshift2:ALU_SHIFTER
	port map(i_opcode =>	"000010", 	
		ALU_control =>	'1',
		i_rs =>		s_EX_ImmExt, 
		i_rt =>		x"00000080",
		o_Out =>	s_ImmShift2,
		zero =>		flag1);

	PCplusImm:ALU_SHIFTER
	port map(i_opcode =>	"000110", 	
		ALU_control =>	'0',
		i_rs =>		s_ImmShift2, 
		i_rt =>		s_EX_PcPlus4,
		o_Out =>	s_BranchAmount,
		zero =>		flag3);

	notZero:invg
  	port map(i_A =>        s_zeroInitail,
       		o_F =>         s_notZeroInitail);


	bneORbeq:nMux2 
 	port map(i_A =>		s_zeroInitail,  	
		i_B =>		s_notZeroInitail,
		i_X =>		s_EX_bne, 
		o_F =>		s_zero);

	BranchAndG:andg2
  	port map(i_A =>		s_EX_branch,
      		i_B =>		s_zero,
       		o_F =>		s_takeBranch);


	jumpMux1:muxflowN
	port map(i_A =>		s_EX_PcPlus4,  	
		i_B =>		s_BranchAmount,
		i_X =>		s_takeBranch, 
		o_F =>		s_JumpMux1);

	jumpMux2:muxflowN
	port map(i_A =>		s_JumpMux1,  	
		i_B =>		s_EX_JumpAddr,
		i_X =>		s_EX_jump, 
		o_F =>		s_newPC);

	ALUsrcMux:muxflowN
	port map(i_A =>		s_EX_Rt,  	
		i_B =>		s_EX_ImmExt,
		i_X =>		s_EX_ALUSRC, 
		o_F =>		s_ALUinput2);
	
	ALURsSrcMux:muxflowN
	port map(i_A =>		s_EX_Rs,  	
		i_B =>		s_EX_Rt,
		i_X =>		s_EX_ALU_shift, 
		o_F =>		s_ALUinput1);

	ALU:ALU_SHIFTER
	port map(i_opcode =>	s_EX_opcode, 	
		ALU_control =>	s_EX_ALU_shift,
		i_rs =>		s_ALUinput1, 
		i_rt =>		s_ALUinput2,
		o_Out =>	s_EX_DMemAddr,
		zero =>		s_zeroInitail); --Zero

	upperLoadShift:ALU_SHIFTER
        port map(i_opcode => 	"000010",
		ALU_control =>	'1',
		i_rs =>		s_EX_ImmExt,
		i_rt =>		x"00000400",
		o_Out =>	s_ImmUpper,
		zero =>		flag8);

	upperMux:muxflowN
	port map(i_A =>		s_EX_DMemAddr,  	
		i_B =>		s_ImmUpper,
		i_X =>		s_EX_upper, 
		o_F =>		s_ALUout);


	s_EX_MEMFLush <= iRST;
	s_EX_MEMRun <= '1';

	EXtoMEMreg:EX_MEM
	port map(i_CLK =>	iCLK,
      		i_CLRN =>	s_EX_MEMFlush, 
       		i_Run =>	s_EX_MEMRun,  
		i_ALUout => 	s_ALUout,
		i_MemAddr =>	s_EX_DMemAddr,
		i_MemData =>	s_EX_Rt,
		i_MemToReg =>	s_EX_MemToReg,
		i_RegWE	=>	s_EX_RegWr,
		i_MemWE =>	s_EX_DMemWr,
		i_RegAddr =>	s_EX_RegAddr,
		i_Reg2 =>	s_EX_Reg2,
		i_Inst =>	s_EX_Inst,
		o_ALUout =>	s_MEM_ALUout,
		o_MemAddr =>	s_MEM_DMemAddr,
		o_MemData =>	s_MEM_DMemData,
		o_MemToReg =>	s_MEM_MemToReg,
		o_RegWE =>	s_MEM_RegWr,
		o_MemWE =>	s_MEM_DMemWr,
		o_RegAddr =>	s_MEM_RegAddr,
		o_Reg2 =>	s_MEM_Reg2,
		o_Inst =>	s_MEM_Inst);
	--END OF EX STAGE
	
	DMem: mem
   generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
   	port map(clk => 	iCLK,
             	addr => 	s_MEM_DMemAddr(11 downto 2),
             	data =>	 	s_MEM_DMemData,
             	we => 		s_MEM_DMemWr,
             	q => 		s_MEM_DMemOut);

	s_MEM_WBFLUSH <= iRST;
	s_MEM_WBRun <= '1';
	
	MEMtoWBreg:MEM_WB
	port map(i_CLK =>	iCLK,
      		i_CLRN =>	s_MEM_WBFlush, 
       		i_Run =>	s_MEM_WBRun,  
		i_MemAddr =>	s_MEM_DMemAddr,
		i_MemData =>	s_MEM_DMemData,
		i_MemWr =>	s_MEM_DMemWr,   
		i_ALUout => 	s_MEM_ALUout,
		i_MemOut =>	s_MEM_DMemOut,
		i_RegAddr =>	s_MEM_RegAddr,
		i_MemToReg =>	s_MEM_MemToReg,
		i_RegWE	=>	s_MEM_RegWr,  
		i_Reg2 =>	S_MEM_Reg2,
		i_Inst =>	s_MEM_Inst,
		o_MemAddr =>	s_DMemAddr,
		o_MemData =>	s_DMemData,
		o_MemWr =>	s_DMemWr,
		o_ALUout =>	s_WB_ALUout,
		o_Memout =>	s_DMemOut,	
		o_RegAddr =>	s_RegWrAddr,
		o_MemToReg =>	s_WB_MemToReg,
		o_RegWE =>	s_RegWr,
		o_Reg2 =>	s_v0,
		o_Inst =>	s_WB_Inst);

	--END OF MEM STAGE
	RegORMemMux:muxflowN
	port map(i_A =>		s_WB_ALUout,  	
		i_B =>		s_DMemOut,
		i_X =>		s_WB_MemToReg, 
		o_F =>		s_RegWrData);


	oALUOut <= s_WB_ALUout;
	
	--END OF WB STAGE


end structure;
