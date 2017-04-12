----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/03/2016 10:47:49 AM
-- Design Name:
-- Module Name: FIR4TapPackage - Behavioral
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
-- This file defines the arrays used in the design

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package FIR4TapPackage is
   type FIRArray          is array (3 downto 0) of std_logic_vector (7 downto 0);
   type multArray         is array (3 downto 0) of std_logic_vector (15 downto 0);

   type Array21x16        is array (20 downto 0) of std_logic_vector (15 downto 0);

end FIR4TapPackage;

package body FIR4TapPackage is

end FIR4TapPackage;
