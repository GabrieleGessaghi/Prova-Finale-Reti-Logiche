----------------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineer: Gabriele Gessaghi, Piermarco Gerli
-- 
-- Create Date: 01.03.2023 15:31:55
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity datapath is 
    port(

    );
end datapath;

architecture Behavioral of datapath is

begin

end Behavioral;


entity fsm is
    port(

    );
end fsm;

architecture Behavioral of fsm is

begin

end Behavioral;

entity project_reti_logiche is
    port (
             i_clk   : in std_logic;
             i_rst   : in std_logic;
             i_start : in std_logic;
             i_w     : in std_logic;
             o_z0    : out std_logic_vector(7 downto 0);
             o_z1    : out std_logic_vector(7 downto 0);
             o_z2    : out std_logic_vector(7 downto 0);
             o_z3    : out std_logic_vector(7 downto 0);
             o_done  : out std_logic;
             o_mem_addr : out std_logic_vector(15 downto 0);
             i_mem_data : in std_logic_vector(7 downto 0);
             o_mem_we   : out std_logic;
             o_mem_en   : out std_logic
         );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

begin


end Behavioral;

