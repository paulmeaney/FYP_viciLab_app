----------------------------------------------------------------------------------
-- Company:
-- Engineer:Paul Meaney
--
-- Create Date: 03/28/2017 12:45:41 PM
-- Design Name:FYP
-- Module Name: OuputBuffer - Behavioral
-- Project Name:
-- Target Devices:
--
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

entity OuputBuffer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           DatIn : in STD_LOGIC_VECTOR (15 downto 0);
           DatOut : out STD_LOGIC_VECTOR (111 downto 0);
           ce : in STD_LOGIC;
           datOutVal :out std_logic);
end OuputBuffer;

architecture Behavioral of OuputBuffer is
signal databuffer : std_logic_vector(111 downto 0);
signal count : std_logic_vector(2 downto 0);

begin



counter: process (clk, rst)
begin

  if clk'event and clk = '1' then
    if rst = '1' then
  		count <= "000";
		elsif ce = '1' then
			if count = "110" then
				count <= "000";
			else
				count <= std_logic_vector(unsigned(count) + 1);
			end if;
		end if;
	end if;
end process;

outputbuffer: process (clk, rst, DatIn)
begin

  if clk'event and clk = '1' then
    datOutVal <= '0';
    case count is

      when "000" =>
        databuffer <= (others => '0');
        databuffer(111 downto 96) <= DatIn;

      when "001" =>
        databuffer(95 downto 80) <= DatIn;
      when "010" =>
          databuffer(79 downto 64) <= DatIn;
      when "011" =>
        databuffer(63 downto 48) <= DatIn;
      when "100" =>
        databuffer(47 downto 32) <= DatIn;
      when "101" =>
        databuffer(31 downto 16) <= DatIn;
      when "110" =>
        databuffer(15 downto 0) <= DatIn;
        datOutVal <= '1';
      when others =>
        databuffer <= (others => '0');
    end case;
  end if;

end process;

assignDatOut: DatOut <= databuffer;

end Behavioral;
