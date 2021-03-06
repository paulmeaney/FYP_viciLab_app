----------------------------------------------------------------------------------
-- Company:
-- Engineer:Paul Meaney
--
-- Create Date: 03/10/2017 05:52:33 PM
-- Design Name:
-- Module Name: EqualiserBlock - Behavioral
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
-- FULL SCALE DESIGN

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

entity EqualiserBlock is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           FIRDatIn : in STD_LOGIC_VECTOR (15 downto 0);
           selector : in std_logic_vector (5 downto 0);
           delayVal : in std_logic_vector(25 downto 0);
           FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0)
          );
end EqualiserBlock;

architecture Behavioral of EqualiserBlock is
component FIRFilter21Tap is
Port ( clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          ce : in STD_LOGIC;
          factorsel : in std_logic_vector(1 downto 0);
          FIRDatIn : in STD_LOGIC_VECTOR (15 downto 0);
          CoeffArray : in Array21x16;
          FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component FrequencyController is
Port ( selector : in std_logic_vector(5 downto 0);
          LowCoeffSet : out Array21x16;
          MidCoeffSet : out Array21x16;
          HighCoeffSet : out Array21x16
        );
end component;

component PulseGen is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       ce : in STD_LOGIC;
       countTo : in STD_LOGIC_VECTOR (25 downto 0);
       ceo : out STD_LOGIC);
end component;

signal lowCoeff : Array21x16;
signal midCoeff : Array21x16;
signal highCoeff : Array21x16;
signal FIRDatStage1 : STD_LOGIC_VECTOR(15 downto 0);
signal FIRDatStage2 : STD_LOGIC_VECTOR(15 downto 0);
signal activate : std_logic;

begin
LowFilter: FIRFilter21Tap port map
   ( clk => clk,
     rst => rst,
     ce => activate,
     factorsel => selector(5 downto 4),
     FIRDatIn => FIRDatIn,
     CoeffArray => lowCoeff,
     FIRDatOut => FIRDatStage1
    );
MidFilter: FIRFilter21Tap port map
       ( clk => clk,
         rst => rst,
         ce => activate,
         factorsel => selector(3 downto 2),
         FIRDatIn => FIRDatStage1,
         CoeffArray => midCoeff,
         FIRDatOut => FIRDatStage2
        );
HighFilter: FIRFilter21Tap port map
     ( clk => clk,
        rst => rst,
        ce => activate,
        factorsel => selector(1 downto 0),
        FIRDatIn => FIRDatStage2,
        CoeffArray => highCoeff,
        FIRDatOut => FIRDatOut
      );


CoeffGenerator: FrequencyController port map
    ( selector => selector,
      LowCoeffSet => lowCoeff,
      MidCoeffSet => midCoeff,
      HighCoeffSet => highCoeff
    );

PulseGenerator: PulseGen port map
     (  clk => clk,
        rst => rst,
        ce => ce,
        countTo => delayVal,
        ceo => activate
     );

end Behavioral;
