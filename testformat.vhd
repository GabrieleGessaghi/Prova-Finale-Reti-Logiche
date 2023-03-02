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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

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

ENTITY project_reti_logiche IS
    PORT (
        i_clk : IN STD_LOGIC;
        i_rst : IN STD_LOGIC;
        i_start : IN STD_LOGIC;
        i_w : IN STD_LOGIC;
        o_z0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_done : OUT STD_LOGIC;
        o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        i_mem_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mem_we : OUT STD_LOGIC;
        o_mem_en : OUT STD_LOGIC
    );
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS

    SIGNAL sum_address : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL mult_address : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sum_channel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL channel_selector : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL mult_channel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL reg_enable : STD_LOGIC;
    SIGNAL o_reg_z1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL o_reg_z2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL o_reg_z3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL o_reg_z4 : STD_LOGIC_VECTOR (7 DOWNTO 0);

    --Segnali di Pier (do not touch)
    SIGNAL addr_en : STD_LOGIC;
    SIGNAL chan_en : STD_LOGIC;
    TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6);
    SIGNAL state : state_type;
    SIGNAL next_state : state_type;
BEGIN

    -- sommatore e moltiplicatore (esegue lo shift logico) per la creazione dell'indirizzo di memoria
    -- sum_address <= ("000000000000000" & i_w) + (o_mem_addr * 2); RIVEDI

    -- registro dove viene salvato l'indirizzo di memoria
    PROCESS (i_clk, i_rst)
    BEGIN
        IF (i_rst = '1') THEN
            o_mem_addr <= "0000000000000000";
        ELSIF i_clk'event AND i_clk = '1' THEN
            IF (addr_en = '1') THEN
                o_mem_addr <= sum_address;
            END IF;
        END IF;

        -- sommatore e moltiplicatore (esegue lo shift logico) per la creazione del selettore del canale di uscita
        -- sum_channel <= ("0" & i_w) + (channel_selector * 2); RIVEDI
    END PROCESS;

    -- registro dove viene salvato il canale di uscita
    PROCESS (i_clk, i_rst)
    BEGIN
        IF (i_rst = '1') THEN
            channel_selector <= "00";
        ELSIF i_clk'event AND i_clk = '1' THEN
            IF (chan_en = '1') THEN
                channel_selector <= sum_channel;
            END IF;
        END IF;
    END PROCESS;

    -- NON SO COME MAPPARE IL RETTANGOLO CON GLI 00, 01, 10, 11

    -- TO DO
    -- reg z1, z2, z3 , z4
    -- o_z1, o_z2, o_z3, o_z4

    PROCESS (i_clk, i_rst) --FSM
    BEGIN
        CASE state IS
                -- Se la FSM è in attesa
            WHEN IDLE =>
                -- current_state <= 0;
                -- Se c'è una richiesta di scrittura
                IF wen = '1' THEN
                    cache_wen <= '1';
                    next_state <= WRITE;
                    -- Se c'è una richiesta di lettura
                ELSIF ren = '1' THEN
                    cache_ren <= '1';
                    next_state <= READ;
                END IF;
                -- Se la FSM è in fase di scrittura
            WHEN WRITE =>
                -- current_state <= 1;
                -- Se la cache ha completato la scrittura
                IF cache_invalid = '0' THEN
                    next_state <= IDLE;
                ELSE
                    invalid <= cache_invalid;
                END IF;
                -- Se la FSM è in fase di lettura
            WHEN READ =>
                -- current_state <= 2;
                -- Se la cache ha completato la lettura
                IF cache_invalid = '0' THEN
                    next_state <= IDLE;
                ELSE
                    invalid <= cache_invalid;
                END IF;
        END CASE;
    END PROCESS;
END Behavioral;