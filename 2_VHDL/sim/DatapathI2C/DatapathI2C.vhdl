--
-- Stefan von Burg 
-- 15.06.2016
-- Bachelor-Thesis
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity DataPathI2C is
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
                  SCL : InOut   std_logic;
                  ack : Out   std_logic;
                   rw : Out   std_logic;
                cout2 : Out   std_logic;
               cout16 : Out   std_logic);
end DataPathI2C;

architecture behavioral of DataPathI2C is


  signal data_bit1_s   : std_logic;
  signal data_bit2_s   : std_logic;
  signal sda_pre_s     : std_logic;
  signal sda_s	       : std_logic;
  signal sda_ena_s     : std_logic;
  signal sda_bit_s     : std_logic;
  signal scl_pre_s     : std_logic;
  signal scl_s	       : std_logic;
  signal scl_ena_s     : std_logic;
  signal bit2_cnt_s    : std_logic;
  signal bit16_cnt_s   : std_logic_vector(3 downto 0);
  signal bit2_s        : std_logic_vector(1 downto 0);
  signal bit16_s       : std_logic_vector(3 downto 0);
--internal
  signal add_shift_s   : std_logic_vector(7 downto 0);
  signal in_shift_s    : std_logic_vector(7 downto 0);
  signal out_shift_s   : std_logic_vector(7 downto 0);
  signal temp          : std_logic_vector(4 downto 0);

begin

  Reg: process(clk, rst)

  begin

    if (rst = '0') then				--reset Reg

       sda_s        <= '0';   
       sda_ena_s    <= '0'; 
       sda_bit_s    <= '0'; 
       scl_s        <= '0';   
       scl_ena_s    <= '0'; 
       bit2_cnt_s   <= '0'; 
       bit16_cnt_s  <= (others => '0');
       ack          <= '0';
       rw           <= '0';
       data_bit1_s  <= '0';   
       data_bit2_s  <= '0'; 
       VAL_REC      <= (others => '0');
       in_shift_s   <= (others => '0');
       out_shift_s  <= (others => '0');
       add_shift_s  <= (others => '0');

    else

      if (clk'event and clk = '1') then

        if (load_add = '1') then		--rw_reg
         rw <= VAL_SEND(0);
         in_shift_s   <= VAL_SEND(7 downto 1) & "0";
         add_shift_s  <= VAL_SEND;
        end if;

        if (bit_cnt2_ena = '1') then		--cnt2_reg
          bit2_cnt_s <= bit2_s(0);    
        end if;

        if (bit_cnt16_ena = '1') then		--cnt16_reg
         bit16_cnt_s <= bit16_s ;
        end if;

        if (sda_ena = '0') then			--sda_in_reg
         sda_bit_s <= SDA;
	end if;

        if (load_val = '1') then		--in_shift_reg
         in_shift_s  <= VAL_SEND; 
          
        end if;

        if (read_val = '1') then		--out_shift_reg
         out_shift_s(0)  <= sda_bit_s;  
        end if;

        sda_ena_s <= sda_ena;			--sda_ena_reg
        sda_s     <= sda_pre_s;			--sda_out_reg
        scl_ena_s <= scl_ena;			--scl_ena_reg
        scl_s	  <= scl_pre_s;			--scl_pre_reg
        ack       <= NOT sda_ena and NOT SDA;	--ack_reg
        VAL_REC   <= out_shift_s;

        if (bit16_cnt_s(0)='0' AND shift_mode="10") then	--in_shift
         in_shift_s <= in_shift_s(6 downto 0) & '0';
        end if;

        if (bit16_cnt_s(0)='0' AND shift_mode="11") then	--add_shift
         add_shift_s <= add_shift_s(6 downto 0) & '0';
        end if;

        if (bit16_cnt_s(0)='0' AND read_val = '1') then	        --out_shift
         out_shift_s <= out_shift_s(6 downto 0) & sda_bit_s;
        
        end if;

       data_bit1_s <= in_shift_s(7);
       data_bit2_s <= add_shift_s(7);
   

       end if;

    end if;

  end process;
 
  scl_pre_s <= '1'            when scl_mode = "00" else
               NOT bit2_cnt_s when scl_mode = "01" else
                   bit2_cnt_s when scl_mode = "10" else
                   bit16_cnt_s(0); 
               
  sda_pre_s <= '1'            when sda_mode = "00" else
               data_bit1_s     when sda_mode = "01" else
               data_bit2_s     when sda_mode = "10" else
               '0'; 

  SDA       <= sda_s WHEN (sda_ena_s = '1') ELSE 'H';			--SDA Buffer

  SCL       <= scl_s WHEN (scl_ena_s = '1') ELSE 'H';			--SCL Buffer

  temp      <= ("0" & bit16_cnt_s) + "0001";                  --bit16_counter
  bit16_s   <= temp(3 downto 0);
  cout16    <= temp(4);
  
  bit2_s    <= ("0" & bit2_cnt_s) + "1";                      --bit2_counter
  cout2     <= bit2_s(1);					                           --carry out 2


end behavioral;

