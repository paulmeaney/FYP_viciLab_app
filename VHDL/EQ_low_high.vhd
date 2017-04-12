----------------------------------------------------------------------------------
-- Company:
-- Engineer: Paul Meaney
--
-- Create Date: 03/12/2017 08:56:16 PM
-- Design Name:
-- Module Name: EQ_top - Behavioral
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
--******************OLD FILE **************************************
--*********************NOT IN USE ***********************************

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

entity EQ_top is
    Port ( clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          ce : in STD_LOGIC;
          FIRDatIn : in STD_LOGIC_VECTOR (15 downto 0);
          frequencySelect : in std_logic_vector(1 downto 0);
          operationSelect : in std_logic_vector(1 downto 0);
          delayVal : in std_logic_vector(25 downto 0);
          FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0)
         );
end EQ_top;

architecture Behavioral of EQ_top is
component FIRFilter21Tap is
Port ( clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          ce : in STD_LOGIC;
          factorsel : in std_logic_vector(1 downto 0);
          FIRDatIn : in STD_LOGIC_VECTOR (15 downto 0);
          CoeffArray : in Array21x16;
          FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;


component FrequencyControllerSingle is
Port ( selector     : in std_logic_vector(3 downto 0);
       CoeffSet     : out Array21x16
      );
end component;

component PulseGen is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       ce : in STD_LOGIC;
       countTo : in STD_LOGIC_VECTOR (25 downto 0);
       ceo : out STD_LOGIC);
end component;

signal Coeff : Array21x16;
--signal midCoeff : Array21x16;
--signal highCoeff : Array21x16;
--signal FIRDatStage1 : STD_LOGIC_VECTOR(15 downto 0);
--signal FIRDatStage2 : STD_LOGIC_VECTOR(15 downto 0);
signal activate : std_logic;

begin
Filter: FIRFilter21Tap port map
   ( clk => clk,
     rst => rst,
     ce => activate,
     factorsel => operationSelect,
     FIRDatIn => FIRDatIn,
     CoeffArray => Coeff,
     FIRDatOut => FIRDatOut
    );



CoeffGenerator: FrequencyControllerSingle port map
              ( selector(3 downto 2) => frequencySelect,
                selector(1 downto 0) => operationSelect,
                CoeffSet => Coeff

              );
PulseGenerator: PulseGen port map
   (  clk => clk,
      rst => rst,
      ce => ce,
      countTo => delayVal,
      ceo => activate
    );
end Behavioral;
