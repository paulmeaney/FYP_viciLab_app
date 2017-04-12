----------------------------------------------------------------------------------
-- Company: NUIG
-- Engineer: Paul Meaney
-- 
-- Create Date: 10/25/2016 12:31:23 PM
-- Design Name: DSP v1
-- Module Name: dsp_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a simple DSP/ first project developed for FYP
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
use IEEE.numeric_std.ALL;
use work.FIR4TapPackage.all;

entity dsp_1 is
    Port ( clk : 	   in STD_LOGIC;
           rst :       in STD_LOGIC;
           ce :		   in STD_LOGIC;
           FIRDatIn :  in std_logic_vector (7 downto 0);
           FIRCoeff0 : in std_logic_vector (7 downto 0);
           FIRCoeff1 : in std_logic_vector (7 downto 0);
           FIRCoeff2 : in std_logic_vector (7 downto 0);
           FIRCoeff3 : in std_logic_vector (7 downto 0);
           FIRDatOut : out std_logic_vector (15 downto 0)
          );
end dsp_1;

architecture RTL of dsp_1 is
signal FIRStage     : FIRArray;
signal mult         : multArray;

begin
	 
FIRRegisterStages: process (clk, rst) 
begin
	if rst = '1' then
		   FIRStage <= (others => (others => '0'));
		    
	elsif clk'event and clk ='1' then
		if ce = '1' then
			FIRStage(3) <= FIRStage(2);
			FIRStage(2) <= FIRStage(1);
			FIRStage(1) <= FIRStage(0);
			FIRStage(0) <= FIRDatIn;
		end if;
	end if;
end process;

mult0_i: mult(0) <= std_logic_vector( unsigned(FIRStage(0)) * unsigned(FIRCoeff0));
mult1_i: mult(1) <= std_logic_vector( unsigned(FIRStage(1)) * unsigned(FIRCoeff1));
mult2_i: mult(2) <= std_logic_vector( unsigned(FIRStage(2)) * unsigned(FIRCoeff2));
mult3_i: mult(3) <= std_logic_vector( unsigned(FIRStage(3)) * unsigned(FIRCoeff3));
--mult_i: process (FIRStage, FIRCoeff)
--begin
--	for i in 0 to 3 loop
--		mult(i) <= std_logic_vector( unsigned(FIRStage(i)) * unsigned(FIRCoeff(i));
--	end loop; 
--end process;

accum: process (mult)
variable varFIRDatOut : std_logic_vector (15 downto 0);
begin
    varFIRDatOut := (others => '0');
	for i in 0 to 3 loop
		varFIRDatOut := std_logic_vector( unsigned(varFIRDatOut) + unsigned(mult(i)) );
	end loop;
	FIRDatOut <= varFIRDatOut;
end process;

end RTL;
