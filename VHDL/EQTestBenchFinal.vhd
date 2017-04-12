----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/12/2017 10:24:46 PM
-- Design Name:
-- Module Name: EQTestBenchFinal
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.FIR4TapPackage.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EQTestBenchFinal is

end EQTestBenchFinal;

architecture Behavioral of EQTestBenchFinal is
component EQ_top is
  Port ( clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        ce : in STD_LOGIC;
        DatIn : in STD_LOGIC_VECTOR (111 downto 0);
        frequencySelect : in std_logic_vector(1 downto 0);
        operationSelect : in std_logic_vector(1 downto 0);
        DatOut : out STD_LOGIC_VECTOR (111 downto 0);
        datOutReady : out STD_LOGIC
       );
end component;

--input
signal clk : std_logic := '0';
signal rst : std_logic;
signal ce : std_logic;
signal DatIn : std_logic_vector(111 downto 0);
signal frequencySelect : std_logic_vector(1 downto 0);
signal operationSelect : std_logic_vector(1 downto 0);


--output
signal DatOut : std_logic_vector(111 downto 0);
signal datOutReady : std_logic;

--clock perid definition
signal endofSim : boolean := FALSE;
constant period : time := 20 ns; --half the period (high for 20ns then low for 20ns)



begin

uut: EQ_top port map(
      clk => clk,
      rst => rst,
      ce => ce,
      DatIn => DatIn,
      frequencySelect => frequencySelect,
      operationSelect => operationSelect,


      DatOut => DatOut,
      datOutReady => datOutReady
      );


clkStim: process (clk)
begin
	if endofSim = false then
		clk <= not clk after period;
	end if;
end process;

testbench: process
variable delay : time := period*2;
begin

--Begin with a reset and selecting all the available coefficient sets
 DatIn <= (others => '0');
 frequencySelect <= "00";
 operationSelect <= "00";
 ce <= '0';
 rst <= '1';
 wait for delay;
 rst <= '0';
 wait for delay;
ce <= '1';
 DatIn <= x"2205" &
            x"7833" &
            x"9932" &
            x"9832" &
            x"CBAC" &
            x"7854" &
            x"2954";
wait for delay ;
wait for delay *7;
DatIn <= x"1111" &
           x"2321" &
           x"5322" &
           x"9832" &
           x"CBAC" &
           x"7854" &
           x"2954";
wait for delay * 8;
DatIn <= (others => '0');
wait for delay * 10;

 endofSim <= true;


end process;

end Behavioral;
