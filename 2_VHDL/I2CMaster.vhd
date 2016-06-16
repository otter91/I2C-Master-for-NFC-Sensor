--
-- Stefan von Burg 
-- 15.06.2016
-- Bachelor-Thesis
--
library IEEE;
use IEEE.std_logic_1164.all;

entity I2CMaster is
      Port (  val_send : In  std_logic_vector(7 downto 0);
             ena_trans : In  std_logic;
                   clk : In  std_logic;
                   rst : In  std_logic;
                   sda : Out std_logic;
                   scl : Out std_logic;
                   err : Out std_logic;
                  busy : Out std_logic;
               val_rec : Out std_logic_vector(7 downto 0));
end I2CMaster;

architecture schematic of I2CMaster is

   signal           load_val : std_logic;
   signal	          load_add : std_logic;
   signal	          read_val : std_logic;
   signal	        shift_mode : std_logic;
   signal	      bit_cnt2_ena : std_logic;
   signal      bit_cnt16_ena : std_logic;
   signal           sda_mode : std_logic_vector(1 downto 0); 
   signal           scl_mode : std_logic_vector(1 downto 0);
   signal            sda_ena : std_logic;
   signal            scl_ena : std_logic;
   signal                ack : std_logic;
   signal                 rw : std_logic;
   signal              cout2 : std_logic;
   signal	            cout16 : std_logic;


   component DataPath
      Port ( VAL_SEND : In    std_logic_vector(7 downto 0);
                  clk : In    std_logic;
                  rst : In    std_logic;
             load_val : In    std_logic;
	           load_add : In    std_logic;
	           read_val : In    std_logic;
	         shift_mode : In    std_logic;
	       bit_cnt2_ena : In    std_logic;
	      bit_cnt16_ena : In    std_logic;
  	          sda_mode : In    std_logic_vector(1 downto 0); 
	           scl_mode : In    std_logic_vector(1 downto 0);
	            sda_ena : In    std_logic;
	            scl_ena : In    std_logic;
              VAL_REC : Out   std_logic_vector(7 downto 0);
		              SDA : Out   std_logic;
		              SCL : Out   std_logic;
		              ack : Out   std_logic;
		               rw : Out   std_logic;
 		            cout2 : Out   std_logic;
	             cout16 : Out   std_logic);
   end component;

   component ControlFSM
      Port (      clk : In    std_logic;
                  rst : In    std_logic;
		              ack : In    std_logic;
		               rw : In    std_logic;
 		            cout2 : In    std_logic;
	             cout16 : In    std_logic;
             load_val : Out   std_logic;
	           load_add : Out   std_logic;
	           read_val : Out   std_logic;
	         shift_mode : Out   std_logic;
	       bit_cnt2_ena : Out   std_logic;
	      bit_cnt16_ena : Out   std_logic;
  	          sda_mode : Out   std_logic_vector(1 downto 0); 
	           scl_mode : Out   std_logic_vector(1 downto 0);
	            sda_ena : Out   std_logic;
	            scl_ena : Out   std_logic);
     end component;


begin

   I_1 : DataPath
      Port Map (VAL_SEND, clk, rst, load_val, load_add, read_val, shift_mode, bit_cnt2_ena, bit_cnt16_ena,
	        sda_mode, scl_mode, sda_ena, scl_ena, VAL_REC, SDA, SCL, ack, rw, cout2, cout16);
   I_2 : ControlFSM
      Port Map (clk, rst, ack, rw, cout2, cout16, load_val, load_add, read_val, shift_mode, bit_cnt2_ena,
                bit_cnt16_ena, sda_mode, scl_mode, sda_ena, scl_ena);

end schematic;
