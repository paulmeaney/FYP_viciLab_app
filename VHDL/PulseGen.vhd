----------------------------------------------------------------------------------
-- Company: NUIG
-- Engineer: Paul Meaney
--
-- Create Date: 02/18/2017 04:50:56 PM
-- Design Name: Generate Pulse
-- Module Name: PulseGen - Behavioral
-- Project Name: FYP
-- Target Devices:

----------------------------------------------------------------------------------
--Pulse Generator

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PulseGen is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           countTo : in STD_LOGIC_VECTOR (25 downto 0);
           ceo : out STD_LOGIC);
end PulseGen;

architecture Behavioral of PulseGen is
  signal NS : std_logic_vector(25 downto 0);
  signal CS : std_logic_vector(25 downto 0);
  signal maxCount : STD_LOGIC;

begin

  NSDecode_i: process (CS, countTo)
  begin
    maxCount <= '0';
    NS <= std_logic_vector(unsigned(CS) + 1);
    if unsigned(CS) >= unsigned(countTo) - 1 then  --counts the number of clk ticks
      NS <= (others => '0');
      maxCount <= '1';
    end if;
  end process;

  stateReg_i: process (NS, ce, clk, rst)
  begin
    if rst = '1' then
      CS <= (others => '0');
    elsif clk'event and clk = '1' then
      if ce = '1' then
        CS <= NS;
      end if;
    end if;

  end process;

  assign_output_i: ceo <= maxCount and ce;


end Behavioral;
