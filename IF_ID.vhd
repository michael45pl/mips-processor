library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is
generic(N : integer := 32);
  port(i_CLK   	: in std_logic;     -- Clock input
       i_CLRN   : in std_logic;     -- Reset input
       i_Run      : in std_logic;     -- Write enable input
       i_PC     : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_INST 	: in std_logic_vector(N-1 downto 0);
       o_PC	: out std_logic_vector(N-1 downto 0);
       o_INST      : out std_logic_vector(N-1 downto 0));   -- Data value output

end IF_ID;

architecture mixed of IF_ID is
  signal s_iPC, s_iINST   : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
  signal s_oPC, s_oINST   : std_logic_vector(N-1 downto 0);    -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  o_INST <= s_oINST;
  o_PC <= s_oPC;
  
  -- Create a multiplexed input to the FF based on i_WE
  with i_Run select
    s_iPC <= i_PC when '1',
           s_oPC when others;
 with i_Run select
  s_iINST <= i_INST when '1',
           s_oINST when others;

  
  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_CLRN)
  begin
    if (i_CLRN = '1') then
      s_oPC <=x"00000000";
      s_oINST <=x"00000000"; -- Use "(others => '0')" for N-bit values
    elsif (rising_edge(i_CLK)) then
      s_oPC <= s_iPC;
      s_oINST <= s_iINST;
    end if;


  end process;
  
end mixed;