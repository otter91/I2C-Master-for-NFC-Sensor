--
-- Stefan von Burg 
-- 15.06.2016
-- Bachelor-Thesis
--
library IEEE;
use IEEE.std_logic_1164.all;

entity E is
end E;

Architecture A of E is

signal              VAL_SEND : std_logic_vector(7 downto 0);
signal                   clk : std_logic;
signal                   rst : std_logic;
signal              load_val : std_logic;
signal              load_add : std_logic;
signal              read_val : std_logic;
signal            shift_mode : std_logic_vector(1 downto 0); 
signal          bit_cnt2_ena : std_logic;
signal         bit_cnt16_ena : std_logic;
signal              sda_mode : std_logic_vector(1 downto 0); 
signal	            scl_mode : std_logic_vector(1 downto 0);
signal	             sda_ena : std_logic;
signal	             scl_ena : std_logic;              
signal               VAL_REC : std_logic_vector(7 downto 0);
signal                   SDA : std_logic;
signal	                 SCL : std_logic;
signal	                 ack : std_logic;
signal	                  rw : std_logic;
signal 	               cout2 : std_logic;
signal	              cout16 : std_logic;

   component DatapathI2C
       Port ( VAL_SEND : In    std_logic_vector(7 downto 0);
                   clk : In    std_logic;
                   rst : In    std_logic;
              load_val : In    std_logic;
              load_add : In    std_logic;
              read_val : In    std_logic;
            shift_mode : In    std_logic_vector(1 downto 0);
          bit_cnt2_ena : In    std_logic;
       	 bit_cnt16_ena : In    std_logic;
              sda_mode : In    std_logic_vector(1 downto 0); 
              scl_mode : In    std_logic_vector(1 downto 0);
               sda_ena : In    std_logic;
               scl_ena : In    std_logic;              
               VAL_REC : Out   std_logic_vector(7 downto 0);
                   SDA : InOut std_logic;
                   SCL : InOut std_logic;           
                   ack : Out   std_logic;
                    rw : Out   std_logic;
                 cout2 : Out   std_logic;
                cout16 : Out   std_logic);
   end component;

begin

   UUT : DatapathI2C

      Port Map ( VAL_SEND, clk, rst, load_val, load_add, read_val, shift_mode, bit_cnt2_ena, bit_cnt16_ena, sda_mode, scl_mode, sda_ena, scl_ena, 
                 VAL_REC, SDA, SCL, ack, rw, cout2, cout16);

-- *** Test Bench - User Defined Section ***
   TB : block     

   begin

       ClockGeneration : process	   

       begin  -- process ClockGeneration

	        clk <= '0', '1' after 1 ns;--, '0' after 2 ns;
	        wait for 2 ns;

       end process ClockGeneration;

       StimuliGeneration : process	   

       begin 

	      VAL_SEND <= "00000000";
              load_val <= '0';
              load_add <= '0';
              read_val <= '0';
            shift_mode <= "00";
          bit_cnt2_ena <= '0';
       	 bit_cnt16_ena <= '0';
              sda_mode <= "00";
              scl_mode <= "00";
               sda_ena <= '0';
               scl_ena <= '0';             
                   rst <= '0';
                   SDA <= 'H';
                   SCL <= 'H';
	        
	   wait for 9 ns;  	         	
	   VAL_SEND <= "11110001";       --reset
	   rst <= '1';
	   wait for 2 ns;  		 
           Load_add <= '1';              --load add
           wait for 2 ns;                
           Load_add <= '0';              --start
           bit_cnt2_ena <= '1'; 
           sda_mode <= "11";
           scl_mode <= "01";
           sda_ena <= '1';
           scl_ena <= '1';
           wait for 4 ns; 
           VAL_SEND <= "01110110";               
           shift_mode <= "10";           --SAD + W
           bit_cnt16_ena <= '1';
           bit_cnt2_ena <= '0';
           sda_mode <= "01";
           scl_mode <= "11";
           wait for 32 ns;
           bit_cnt16_ena <= '0';         --ack
           shift_mode <= "00";
           sda_ena <= '0';
           bit_cnt2_ena <= '1';
           scl_ena <= '1';
           scl_mode <= "10";
           SDA <= 'H';
           Load_val <= '1';
           wait for 4 ns;
           Load_val <= '0';
           shift_mode <= "10";           --DATA
           bit_cnt2_ena <= '0';
           bit_cnt16_ena <= '1';
           bit_cnt2_ena <= '0';
           sda_mode <= "01";
           scl_mode <= "11";
           sda_ena <= '1';
           scl_ena <= '1';
           wait for 32 ns; 
           bit_cnt2_ena <= '1';          --ack
           bit_cnt16_ena <= '0';         
           shift_mode <= "00";
           scl_mode <= "10";
           sda_ena <= '0';
           scl_ena <= '1';
           wait for 4 ns;
           bit_cnt2_ena <= '0';
           scl_ena <= '0';
           wait for 4 ns;
              
              load_val <= '0';           --rst
              load_add <= '0';
              read_val <= '0';
            shift_mode <= "00";
          bit_cnt2_ena <= '0';
       	 bit_cnt16_ena <= '0';
              sda_mode <= "00";
              scl_mode <= "00";
               sda_ena <= '0';
               scl_ena <= '0';             
                   rst <= '0';
                   SDA <= 'H';
                   SCL <= 'H';
           
           wait for 4 ns;
                   rst <= '1';
                  
           wait for 2 ns;
              read_val <= '1';
         bit_cnt16_ena <= '1';
               sda_ena <= '0';
                   SDA <= '1';  
               scl_ena <= '1';
              scl_mode <= "11";
           wait for 32 ns; 
          bit_cnt2_ena <= '1';          --Mack
         bit_cnt16_ena <= '0';
              read_val <= '0';
              sda_mode <= "00";
              scl_mode <= "10";
               sda_ena <= '1';
               scl_ena <= '1';
                   SDA <= 'H';
           wait for 4 ns; 
              sda_mode <= "11";
              scl_mode <= "00";
               sda_ena <= '1';
               scl_ena <= '1';
           wait for 4 ns;
          bit_cnt2_ena <= '0'; 
               sda_ena <= '0';
               scl_ena <= '0';

           wait for 100 ns;   

       end process StimuliGeneration;

   end block;

end A;

configuration behavioral of E is
   for A
   end for;
end behavioral;

