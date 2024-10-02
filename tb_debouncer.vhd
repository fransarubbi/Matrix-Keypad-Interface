
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_debouncer IS
END tb_debouncer;
 
ARCHITECTURE behavior OF tb_debouncer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debouncer
    PORT(
         col : IN  std_logic_vector(3 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         row : OUT  std_logic_vector(3 downto 0);
         value : OUT  std_logic_vector(3 downto 0);
			rdy   : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal col : std_logic_vector(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal row : std_logic_vector(3 downto 0);
   signal value : std_logic_vector(3 downto 0);
	signal rdy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debouncer PORT MAP (
          col => col,
          clk => clk,
          rst => rst,
          row => row,
			 rdy => rdy,
          value => value
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      rst <= '0';
		wait for 100 ns;
		rst <= '1';
		
		wait until row = "0001";  -- Esperar la fila 4
		col <= "1100"; -- Pulse la E
		wait for 90 ms;
		
		rst <= '0';
		col <= "0000";
		wait for 50 ns;
		rst <= '1';
		wait for 50 ns;
		
		wait until row = "0010";  -- Esperar la fila 3
		col <= "0011";  -- Pulse el 9
		wait for 90 ms;  --80 ns tarda en llegar a 0 
		
		rst <= '0';
		col <= "0000";
		wait for 50 ns;
		rst <= '1';
		
		wait until row = "0100";  -- Esperar la fila 2
		col <= "1111";  -- Pulse el 4
		wait for 90 ms;  --80 ns tarda en llegar a 0 
      wait;
   end process;

END;
