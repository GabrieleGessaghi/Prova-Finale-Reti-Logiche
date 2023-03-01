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


-- DATAPATH in
    -- i_clk
    -- i_res
    -- address_enable
    -- channel_enable
    -- done
    -- receive
    -- i_w
    -- i_mem_data

-- DATAPATH out
    -- o_mem_address
    -- o_z1
    -- o_z2
    -- o_z3
    -- o_z4

-- DATAPATH internal
    -- sum_address
    -- mult_address
    -- sum_channel
    -- channel_selector
    -- mult_channel
    -- reg_enable
    -- o_reg_z1
    -- o_reg_z2
    -- o_reg_z3
    -- o_reg_z4



entity datapath is 
    port(
        i_clk : in STD_LOGIC,
        i_rst : in STD_LOGIC,
        address_enable : in STD_LOGIC,
        channell_enable : in STD_LOGIC,
        done : in STD_LOGIC,
        receive : in STD_LOGIC,
        i_w : in STD_LOGIC,
        i_mem_data : in STD_LOGIC_VECTOR (7 downto 0),
        o_mem_addr : out STD_LOGIC_VECTOR (15 downto 0),
        o_z1 : out STD_LOGIC_VECTOR (7 downto 0),
        o_z2 : out STD_LOGIC_VECTOR (7 downto 0),
        o_z3 : out STD_LOGIC_VECTOR (7 downto 0),
        o_z4 : out STD_LOGIC_VECTOR (7 downto 0)
        );
end datapath;

architecture Behavioral of datapath is

    signal sum_address : STD_LOGIC_VECTOR (15 downto 0);
    signal mult_address : STD_LOGIC_VECTOR (15 downto 0);
    signal sum_channel : STD_LOGIC_VECTOR (1 downto 0);
    signal channel_selector : STD_LOGIC_VECTOR (1 downto 0);
    signal mult_channel : STD_LOGIC_VECTOR (1 downto 0);
    signal reg_enable : STD_LOGIC;
    signal o_reg_z1 : STD_LOGIC_VECTOR (7 downto 0);
    signal o_reg_z2 : STD_LOGIC_VECTOR (7 downto 0);
    signal o_reg_z3 : STD_LOGIC_VECTOR (7 downto 0);
    signal o_reg_z4 : STD_LOGIC_VECTOR (7 downto 0);


begin

    -- sommatore e moltiplicatore (esegue lo shift logico) per la creazione dell'indirizzo di memoria
    sum_address <= ("000000000000000" & i_w) + (o_mem_addr * 2);
    
    -- registro dove viene salvato l'indirizzo di memoria
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_mem_addr <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(address_enable = '1') then
                o_mem_addr <= sum_address;
            end if;
        end if;
    
    -- sommatore e moltiplicatore (esegue lo shift logico) per la creazione del selettore del canale di uscita
    sum_channel <= ("0" & i_w) + (channel_selector * 2);

    -- registro dove viene salvato il canale di uscita
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            channel_selector <= "00";
        elsif i_clk'event and i_clk = '1' then
            if(channel_enable = '1') then
                channel_selector <= sum_channel;
            end if;
        end if;


-- NON SO COME MAPPARE IL RETTANGOLO CON GLI 00, 01, 10, 11

-- TO DO
    -- reg z1, z2, z3 , z4
    -- o_z1, o_z2, o_z3, o_z4

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

