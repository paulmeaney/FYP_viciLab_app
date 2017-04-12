----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/28/2017 12:45:41 PM
-- Design Name:
-- Module Name: InputBuffer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InputBuffer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           DatIn : in STD_LOGIC_VECTOR (111 downto 0);
           DatOut : out STD_LOGIC_VECTOR (15 downto 0);
           ceo : out std_logic);
end InputBuffer;

architecture Behavioral of InputBuffer is
signal inputdata : std_logic_vector (111 downto 0);
signal count : std_logic_vector(2 downto 0); --will count to 7

begin
Count_Clk: process (clk, rst)
begin

	if clk'event and clk = '1' then
    if rst = '1' then
  		count <= "000";
		elsif ce = '1' then
			if count = "111" then
				count <= "000";
			else
				count <= std_logic_vector(unsigned(count) + 1);
			end if;
		end if;
	end if;
end process;

input_data: process (clk, rst, count)
begin
	if clk'event and clk = '1' then
    ceo <= '0';
		if ce = '1' then
      ceo <= '1';
      if count = "000" then
			    inputdata <= DatIn;
      		ceo <= '0';
      end if;
		end if;
	end if;
end process;

ouput_data: process (clk, count)
begin
	if clk'event and clk = '1' then

		case count is
			when "001" => DatOut <= inputdata(111 downto 96);
			when "010" => DatOut <= inputdata(95 downto 80);
			when "011" => DatOut <= inputdata(79 downto 64);
			when "100" => DatOut <= inputdata(63 downto 48);
			when "101" => DatOut <= inputdata(47 downto 32);
			when "110" => DatOut <= inputdata(31 downto 16);
			when "111" => DatOut <= inputdata(15 downto 0);

			when others =>
        DatOut <= (others => '0');
		end case;
	end if;
end process;
end Behavioral;
