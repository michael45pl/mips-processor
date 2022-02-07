library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity tb_processor is
	generic (
		clk_time : time := 50 ns
	);
end tb_processor;

architecture behavior of tb_processor is

	constant clk_cycle : time := clk_time * 2; --gets us 100 ns
	component processor is
		port (
			i_OP : in std_logic_vector(5 downto 0);
			i_rt : in std_logic_vector(4 downto 0);
			i_rs : in std_logic_vector(4 downto 0);
			i_rd : in std_logic_vector(4 downto 0);
			i_IMM : in std_logic_vector(15 downto 0);
			i_clk, i_ALUcon, memToReg, regWrite, memWrite, ALUSrc : in std_logic;
			carry_flag, flow_flag, set_flag : out std_logic);
	end component;

	signal s_clk, s_ALUcon, s_memToReg, s_regWrite, s_memWrite, s_ALUSrc : std_logic;
	signal s_OP : std_logic_vector(5 downto 0);
	signal s_rt, s_rs, s_rd : std_logic_vector(4 downto 0);
	signal i_imm : std_logic_vector(15 downto 0);
	signal s_carry_flag, s_flow_flag, s_set_flag : std_logic;
begin
	p : processor
	port map(i_OP => s_OP, 
		 i_rt => s_rt, 
		 i_rs => s_rs, 
		 i_rd => s_rd, 
		 i_IMM => i_imm,
		 i_ALUcon => s_ALUcon,
		 memToReg => s_memToReg,
		 regWrite => s_regWrite,
		 memWrite => s_memWrite,
		 ALUSrc => s_ALUSrc, 
		 i_clk => s_clk,
		 carry_flag => s_carry_flag,
		 flow_flag => s_flow_flag,
		 set_flag => s_set_flag);

	clk : process
	begin
		s_clk <= '0';
		wait for clk_cycle;
		s_clk <= '1';
		wait for clk_cycle;
	end process;
	process
		begin
			
			s_carry_flag	<='0'; 
			s_flow_flag	<='0';
			s_set_flag	<='0';
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='0';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0';
			s_OP		<= "000000";
			s_rt		<= "00000";
			s_rs		<= "00000";
			s_rd		<= "00000";
			i_imm 		<= x"0000";
			wait for clk_cycle;

			-- addi $25, $0, 1 
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='1';
			s_OP 		<= "011000";
			s_rd 		<= "11001";
			s_rs 		<= "00000";
			i_imm 		<= x"0101";
			wait for clk_cycle;

			-- addi $26, $0, 256
			s_OP 		<= "011000";
			s_rd 		<= "11010";
			s_rs 		<= "00000";
			i_imm 		<= x"0100";
			wait for clk_cycle;

			-- AND $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "000100";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go 0100
			wait for clk_cycle;

			-- lw $1, 0($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0000";
			wait for clk_cycle;

			-- OR $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "000100";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go 0101
			wait for clk_cycle;

			-- lw $1, 4($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0004";
			wait for clk_cycle;

			-- XOR $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "001000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go 0001
			wait for clk_cycle;

			-- lw $1, 8($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0008";
			wait for clk_cycle;

			-- NAND $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "001000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go FEFF
			wait for clk_cycle;


			-- lw $1, 12($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"000C";
			wait for clk_cycle;

			-- NOR $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "001000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go FEFE
			wait for clk_cycle;

			-- lw $1, 16($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0010";
			wait for clk_cycle;

			-- NOR $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "001000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go FEFE
			wait for clk_cycle;
	
			-- lw $1, 20($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0014";
			wait for clk_cycle;

			-- SLT $1, $25, $26
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "001000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "11010";
			i_imm 		<= x"0000";--$1 should go 0
			wait for clk_cycle;

			-- lw $1, 24($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"0018";
			wait for clk_cycle;


			-- SLL $1, $25, 7 shifts 0101 7 to the left.
			s_ALUcon	<='1';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "000000";
			s_rd 		<= "00001";
			s_rs 		<= "11001";
			s_rt		<= "00000";
			i_imm 		<= x"01C0";--$1 should go 01010000000
			wait for clk_cycle;

			-- lw $1, 28($4) 
			s_ALUcon	<='0';
			s_memToReg	<='0';
			s_regWrite 	<='1';
			s_memWrite 	<='1';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00100";
			i_imm 		<= x"001C";
			wait for clk_cycle;

			-- addi $1, $1, 65,535
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00001";
			s_rs 		<= "00001";
			i_imm 		<= x"FFFF";
			wait for clk_cycle;

			-- addi $2, $2, 1
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='1'; 
			s_OP 		<= "011000";
			s_rd 		<= "00010";
			s_rs 		<= "00010";
			i_imm 		<= x"0001";
			wait for clk_cycle;

			-- add $3, $1, $2
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "011000";
			s_rd 		<= "00011";
			s_rs 		<= "00001";
			s_rt 		<= "00010";
			i_imm 		<= x"0000";
			wait for clk_cycle; --test for overflow in ALU

			-- add $3, $1, $2
			s_ALUcon	<='0';
			s_memToReg	<='1';
			s_regWrite 	<='1';
			s_memWrite 	<='0';
			s_ALUSrc  	<='0'; 
			s_OP 		<= "011000";
			s_rd 		<= "00011";
			s_rs 		<= "00001";
			s_rt 		<= "00010";
			i_imm 		<= x"0000";
			wait for clk_cycle; --test for overflow in ALU

			
	end process;
end behavior;