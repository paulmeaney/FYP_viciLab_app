----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/09/2017 10:58:35 AM
-- Design Name:
-- Module Name: FIRFilter21Tap - Behavioral
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
--Main 21 TAP FIR Filter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.FIR4TapPackage.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIRFilter21Tap is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           factorsel : in std_logic_vector(1 downto 0);
           ce : in STD_LOGIC;
           FIRDatIn : in STD_LOGIC_VECTOR (15 downto 0);
           CoeffArray : in Array21x16;
           FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0));
end FIRFilter21Tap;

architecture Behavioral of FIRFilter21Tap is
signal FIRStage  : Array21x16;
signal MultStage : Array21x16;
signal factor : std_logic_vector(3 downto 0);
type Array21x32 is array (20 downto 0) of std_logic_vector(31 downto 0);



begin
FIRStage_assign: process (clk, rst)
begin
	if rst = '1' then
		FIRStage <= (others=>(others=>'0'));
	elsif clk'event and clk = '1' then
		if ce = '1' then
			for i in 20 downto 1 loop
				FIRStage(i) <= FIRStage(i-1);
			end loop;
			FIRStage(0) <= FIRDatIn;
		end if;
	end if;
end process;

factor_decode: process (factorsel)
begin
  case factorsel is
      when "00" => factor <= "1111";
      when "01" => factor <= "1110";
      when "11" => factor <= "1001";
      when others => factor <= "0000";
   end case;
end process;

mult_coeff: process(FIRStage, CoeffArray, factor)
variable multout : Array21x32;
variable multin : Array21x32;
begin
for i in 0 to 20 loop
   multin(i) := std_logic_vector(signed(FIRStage(i)) * signed(CoeffArray(i)));
   multin(i) := std_logic_vector(shift_right(signed(multin(i)) , to_integer(unsigned(factor))));

   if signed(multin(i)) < -32768 then  --if negative
      multout(i) := x"FFFF8000";
   elsif signed(multin(i)) > 32767 then
   	  multout(i) := x"00007FFF";
   else
   	  multout(i) := multin(i);
   end if;
   MultStage(i) <= multout(i)(15 downto 0);
end loop;
end process;

accum_i: process(MultStage)
variable tempdatout : std_logic_vector(15 downto 0);
begin
tempdatout := (others => '0');
 for i in 0 to 20 loop
   tempdatout := std_logic_vector(signed(tempdatout) + signed(MultStage(i)));
end loop;

FIRDatOut <= tempdatout;


end process;



end Behavioral;
