----------------------------------------------------------------------------------
-- Company:
-- Engineer: Paul Meaney
--
-- Create Date: 03/13/2017 04:54:33 PM
-- Design Name:
-- Module Name: FrequencyControllerSingle - Behavioral

--
----------------------------------------------------------------------------------
--Coefficient Generator for single Filter EQ

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.FIR4TapPackage.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FrequencyControllerSingle is
    Port ( selector     : in std_logic_vector(3 downto 0);
           CoeffSet     : out Array21x16
          );
end FrequencyControllerSingle;

architecture Behavioral of FrequencyControllerSingle is
constant lowFlow : Array21x16 := (x"003E",
                                  x"FFF6",
                                  x"FF44",
                                  x"FEC1",
                                  x"0029",
                                  x"03D1",
                                  x"05C0",
                                  x"FFAB",
                                  x"EFED",
                                  x"DE15",
                                  x"562C",
                                  x"DE15",
                                  X"EFED",
                                  x"FFAB",
                                  x"05C0",
                                  x"03D1",
                                  x"0029",
                                  x"FEC1",
                                  x"FF44",
                                  x"FFF6",
                                  x"003E");

constant mid : Array21x16 :=  (10=> x"4000", others=>(others=>'0'));

constant lowFhigh : Array21x16 := (x"FF9E",
                                   x"0010",
                                   x"0125",
                                   x"01F2",
                                   x"FFC0",
                                   x"FA09",
                                   x"F703",
                                   x"0084",
                                   x"191E",
                                   x"3500",
                                   x"435B",
                                   x"3500",
                                   x"191E",
                                   x"0084",
                                   x"F703",
                                   x"FA09",
                                   x"FFC0",
                                   x"01F2",
                                   x"0125",
                                   x"0010",
                                   x"FF9E");

constant midFlow : Array21x16 := (x"FF78",
                                  x"001E",
                                  x"015C",
                                  x"FFDA",
                                  x"0028",
                                  x"FFA9",
                                  x"F418",
                                  x"00FF",
                                  x"1F94",
                                  x"FF67",
                                  x"562C",
                                  x"FF67",
                                  x"1F94",
                                  x"00FF",
                                  x"F418",
                                  x"FFA9",
                                  x"0028",
                                  x"FFDA",
                                  x"015C",
                                  x"001E",
                                  x"FF78");

constant midFhigh : Array21x16 := (x"00D5",
                                  x"FFD0",
                                  x"FDDF",
                                  x"003C",
                                  x"FFC1",
                                  x"0089",
                                  x"129C",
                                  x"FE72",
                                  x"CEA9",
                                  x"00EF",
                                  x"435B",
                                  x"00EF",
                                  x"CEA9",
                                  x"FE72",
                                  x"129C",
                                  x"0089",
                                  x"FFC1",
                                  x"003C",
                                  x"FDDF",
                                  x"FFD0",
                                  x"00D5");

constant highFlow : Array21x16 := (x"0049",
                                   x"FFEC",
                                   x"FF60",
                                   x"0166",
                                   x"FFAF",
                                   x"FC87",
                                   x"0628",
                                   x"FF56",
                                   x"F080",
                                   x"2285",
                                   x"54EF",
                                   x"2285",
                                   x"F080",
                                   x"FF56",
                                   x"0628",
                                   x"FC87",
                                   x"FFAF",
                                   x"0166",
                                   x"FF60",
                                   x"FFEC",
                                   x"0049");

constant highFhigh : Array21x16 := (x"FF8D",
                                   x"001F",
                                   x"00FB",
                                   x"FDD1",
                                   x"0080",
                                   x"056E",
                                   x"F662",
                                   x"0109",
                                   x"1839",
                                   x"CA10",
                                   x"454A",
                                   x"CA10",
                                   x"1839",
                                   x"0109",
                                   x"F662",
                                   x"056E",
                                   x"0080",
                                   x"FDD1",
                                   x"00FB",
                                   x"001F",
                                   x"FF8D");
begin
selectCoeff: process (selector)
begin
case selector is
     when "0000" => CoeffSet <= lowFlow;
     when "0011" => CoeffSet <= lowFhigh;
     when "0100" => CoeffSet <= midFlow;
     when "0111" => CoeffSet <= midFhigh;
     when "1100" => CoeffSet <= highFlow;
     when "1111" => CoeffSet <= highFhigh;
     when others => CoeffSet <= mid;
end case;

end process;


end Behavioral;
