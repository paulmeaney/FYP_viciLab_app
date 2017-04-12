----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/10/2017 06:30:05 PM
--This block generates the coeffecients for each filter depending on the input selection bits
--There are 3 filters in the design, with three settings for each filter , and thus 3 sets of
--coefficients.

-- The inputs are as follows:
-- selector [5:0] - this determines the set of coefficients that are output.
-- the selector array is devided for each filter
--[5:4] controls the low frequency band filter
--[3:2] controls the mid frequency band filter
--[1:0] controls the high frequency band filter.

--the filter settings work as follows:
-- 11 - +40dB filter Gain
-- 01 - 0dB filter Gain
-- 00 - -40dB filter Gain
-- e.g selector = 000111 results in
--  low frequencies -40dB Gain
--  mid frequencies 0dB Gain
--  high frequencies +40dB Gain

-- Note the coefficients were calculated in MatLab and normalized to integers.
----------------------------------------------------------------------------------
--coefficient Generator for cascaded EQ

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.FIR4TapPackage.all;


entity FrequencyController is
    Port ( selector : in std_logic_vector(5 downto 0);
           LowCoeffSet : out Array21x16;
           MidCoeffSet : out Array21x16;
           HighCoeffSet : out Array21x16
         );
end FrequencyController;

architecture Behavioral of FrequencyController is
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
lowfilter: process(selector)
begin
case selector(5 downto 4) is
    when "00" => LowCoeffSet <= lowFlow;
    when "01" => LowCoeffSet <= mid;
    when "11" => LowCoeffSet <= lowFhigh;
    when others => LowCoeffSet <= mid;
end case;
end process;

midfilter: process(selector)
begin
case selector(3 downto 2) is
    when "00" => MidCoeffSet <= midFlow;
    when "01" => MidCoeffSet <= mid;
    when "11" => MidCoeffSet <= midFhigh;
    when others => MidCoeffSet <= mid;
end case;
end process;

highfilter: process(selector)
begin
case selector(1 downto 0) is
     when "00" => HighCoeffSet <= highFlow;
     when "01" => HighCoeffSet <= mid;
     when "11" => HighCoeffSet <= highFhigh;
     when others => HighCoeffSet <= mid;
end case;
end process;


end Behavioral;
