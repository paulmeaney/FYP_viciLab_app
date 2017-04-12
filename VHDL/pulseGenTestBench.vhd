----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/10/2017 01:54:32 PM
-- Design Name:
-- Module Name: pulseGenTestBench - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulseGenTestBench is

end pulseGenTestBench;

architecture Behavioral of pulseGenTestBench is
component PulseGen is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       ce : in STD_LOGIC;
       countTo : in STD_LOGIC_VECTOR (25 downto 0);
       ceo : out STD_LOGIC);
end component;

signal clk : std_logic := '0';
signal rst : std_logic;
signal ce : std_logic;
signal countTo : std_logic_vector(25 downto 0);
signal ceo : std_logic;
signal endofSim : boolean := FALSE;
constant period : time := 20 ns; --half the period (high for 20ns then low for 20ns)

begin
uut: PulseGen port map(
clk => clk,
rst => rst,
ce => ce,
countTo => countTo,
ceo => ceo
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
rst <= '1';
ce <= '0';
countTo <= (others => '0');
wait for delay;
rst <= '0';
countTo <= (3 => '1', others => '0');
ce <= '1';
wait for delay * 20;
countTo <= (1 => '1', others => '0');
wait for delay * 11;
countTo <= (1 downto 0 => '1', others => '0');
wait for delay * 20;

endofSim <= true;
end process;


end Behavioral;
