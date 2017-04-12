----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/18/2017 05:52:21 PM
-- Design Name:
-- Module Name: FIRFilter4Tap - Behavioral
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
-- Four tap filter hooked up to the Pulse Gen


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIRFilter4Tap is
    Port ( FIRDatIn : in STD_LOGIC_VECTOR (7 downto 0);
           Coeff0 : in STD_LOGIC_VECTOR (7 downto 0);
           Coeff1 : in STD_LOGIC_VECTOR (7 downto 0);
           Coeff2 : in STD_LOGIC_VECTOR (7 downto 0);
           Coeff3 : in STD_LOGIC_VECTOR (7 downto 0);
           ce : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           numClkCycles : in STD_LOGIC_VECTOR (25 downto 0);
           FIRDatOut : out STD_LOGIC_VECTOR (15 downto 0));
end FIRFilter4Tap;

architecture Behavioral of FIRFilter4Tap is

component PulseGen is
 Port (  clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         ce : in STD_LOGIC;
         countTo : in STD_LOGIC_VECTOR (25 downto 0);
         ceo : out STD_LOGIC
         );
end component;

component dsp_1 is
 Port ( clk : 	     in STD_LOGIC;
        rst :       in STD_LOGIC;
        ce  :       in STD_LOGIC;
        FIRDatIn :  in std_logic_vector (7 downto 0);
        FIRCoeff0:   in std_logic_vector (7 downto 0);
        FIRCoeff1:   in std_logic_vector (7 downto 0);
        FIRCoeff2:   in std_logic_vector (7 downto 0);
        FIRCoeff3:   in std_logic_vector (7 downto 0);
        FIRDatOut : out std_logic_vector (15 downto 0)
       );
end component;

signal filterEnable : std_logic;

begin

PulseGen_i: PulseGen port map
	(	clk => clk,
		rst => rst,

		ce => ce,
		countTo => numClkCycles,

		ceo => filterEnable
	);

dsp_1_i: dsp_1 port map
	(	clk => clk,
		rst => rst,

		ce => filterEnable,
		FIRDatIn => FIRDatIn,
		FIRCoeff0 => Coeff0,
		FIRCoeff1 => Coeff1,
		FIRCoeff2 => Coeff2,
		FIRCoeff3 => Coeff3,

		FIRDatOut => FIRDatOut

	);


end Behavioral;
