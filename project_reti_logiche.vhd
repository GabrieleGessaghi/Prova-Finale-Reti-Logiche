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
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.all;


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
    SIGNAL sum_channel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL channel_selector : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL addr_en : STD_LOGIC;
    SIGNAL chan_en : STD_LOGIC;
    SIGNAL receive : STD_LOGIC;
    -- ch_enable pack
    SIGNAL ch0_en : STD_LOGIC;
    SIGNAL ch1_en : STD_LOGIC;
    SIGNAL ch2_en : STD_LOGIC;
    SIGNAL ch3_en : STD_LOGIC;
    SIGNAL internal_rst : STD_LOGIC;
    SIGNAL temp_done : STD_LOGIC;
    signal ingresso : std_logic;
    
    SIGNAL reg_z0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL reg_z1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL reg_z2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL reg_z3 : STD_LOGIC_VECTOR (7 DOWNTO 0);

    TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6);
    SIGNAL state : state_type;
    SIGNAL next_state : state_type;
    
BEGIN
    
    PROCESS(i_clk)
    begin
        if rising_edge(i_clk) then ingresso <= i_w; end if;
    end process;
    
    PROCESS (i_clk, i_rst, internal_rst) -- processo calcolo address
    BEGIN
        IF (i_rst = '1') or internal_rst = '1' THEN
            sum_address <= (others => '0');
        ELSIF rising_edge(i_clk) and addr_en = '1' THEN
            -- sum_address <= std_logic_vector(unsigned(sum_address) sll 1); -- shift logico sx del canale
            -- sum_address(0) <= '1';
            sum_address <= sum_address(14 downto 0) & ingresso;
        END IF;
    END PROCESS;
    
    o_mem_addr <= sum_address;

    PROCESS (i_clk, i_rst, internal_rst) -- processo selezione canale di uscita
    BEGIN
        IF (i_rst = '1') or internal_rst = '1' THEN
            channel_selector <= (others => '0');
        ELSIF rising_edge(i_clk) and chan_en = '1' THEN
            -- channel_selector <= std_logic_vector(unsigned(channel_selector) sll 1); -- shift logico sx del canale
            -- channel_selector(0) <= '1';
            channel_selector <= channel_selector(0) & ingresso;
        END IF;
    END PROCESS;

    -- indirizzamento data su uscita indicata in channel
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            reg_z0 <= "00000000";
            reg_z1 <= "00000000";
            reg_z2 <= "00000000";
            reg_z3 <= "00000000";
        elsif rising_edge(i_clk) then
            if ch0_en = '1' then 
                    reg_z0 <= i_mem_data;
                end if; 
                if ch1_en = '1' then 
                    reg_z1 <= i_mem_data;
                end if;
                if ch2_en = '1' then 
                    reg_z2 <= i_mem_data;
                end if;
                if ch3_en = '1' then 
                    reg_z3 <= i_mem_data;
                end if;
        end if;
    end process;
    
    process(i_clk, receive) -- selezione canale uscita ed enabler mux
    begin
        ch0_en <= '0'; 
        ch1_en <= '0'; 
        ch2_en <= '0'; 
        ch3_en <= '0'; 
        if receive = '1' then
            CASE channel_selector IS 
                when "00" => ch0_en <= '1' ;
                when "01" => ch1_en <= '1' ;
                when "10" => ch2_en <= '1' ;
                when "11" => ch3_en <= '1' ;
                when others => null ;
            END CASE;
       end if;
    end process;
    
    -- gestione uscite con DONE
    process(i_clk, temp_done)
    begin 
        if temp_done = '1' then
            o_z0 <= reg_z0;
            o_z1 <= reg_z1;
            o_z2 <= reg_z2;
            o_z3 <= reg_z3;
        else
            o_z0 <= "00000000";
            o_z1 <= "00000000"; 
            o_z2 <= "00000000"; 
            o_z3 <= "00000000"; 
        end if;
    end process;
    
    PROCESS (i_clk, i_rst) -- aggiornatore FSM
    BEGIN 
        if i_rst = '1' then state <= S0;
        elsif rising_edge(i_clk) then state <= next_state;
        end if;
    
    END PROCESS;
   -- process( i_clk)
   -- begin
        -- if rising_edge(i_clk) then o_done <= temp_done; end if;
   -- end process;
        
    PROCESS (i_clk, i_rst) --FSM
    BEGIN
    o_mem_en <= '0';
    addr_en <= '0';
    chan_en <= '0';
    internal_rst <= '0';
    temp_done <= '0';
    receive <= '0';
    
        CASE state IS
            when S0 =>
                temp_done <= '0';
                internal_rst <= '0';
            when S1 => -- legge primo bit canale
                chan_en <= '1';
            when S2 => -- legge secondo bit di indirizzo
                chan_en <= '1';
            when S3 => -- legge indirizzo bit a bit
                addr_en <= '1';
            when S4 => -- trasmette indirizzo
                o_mem_en <= '1';
            when S5 => -- ricevi data da memoria
                receive <= '1';
                --temp_done <= '1';
            when S6 => -- espone risultati, resetta addr register
                temp_done <= '1';
                internal_rst <= '1';
        END CASE;
    END PROCESS;

    PROCESS (i_clk, i_rst, i_start) --FSM
    BEGIN
        next_state <= state; --c
        CASE state IS
            when S0 =>
                next_state <= S0;
                if i_start = '1' then 
                    next_state <= S1;
                end if;
            when S1 => -- legge primo bit canale
                next_state <= S2;
            when S2 => -- legge secondo bit di indirizzo
                -- next_state <= S3;
                if i_start = '1' then next_state <= S3; 
                else next_state <= S4; end if;
            when S3 => -- legge indirizzo bit a bit
                next_state <= S3;
                if i_start = '0' then next_state <= S4; end if;
                -- if i_start = '1' then 
                 --   next_state <= S3;
                --else next_state <= S4;
                -- end if;
            when S4 => -- trasmette indirizzo
                next_state <= S5;
            when S5 => -- ricevi data da memoria
                next_state <= S6;
            when S6 => -- espone risultati, resetta addr register
                next_state <= S0;         
        END CASE;
    END PROCESS;
    
    o_done <= temp_done;
END Behavioral;