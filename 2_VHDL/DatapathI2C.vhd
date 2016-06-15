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
	   shift_mode : In    std_logic;
	 bit_cnt2_ena : In    std_logic;
	bit_cnt16_ena : In    std_logic;
  	     sda_mode : In    std_logic_vector(1 downto 0); 
	     scl_mode : In    std_logic_vector(1 downto 0);
	      sda_ena : In    std_logic;
	      scl_ena : In    std_logic;

             VAL_REC  : Out   std_logic_vector(7 downto 0);
		  SDA : Out   std_logic;
		  SCL : Out   std_logic;
		  ack : Out   std_logic;
		   rw : Out   std_logic;
 		cout2 : Out   std_logic;
	       cout16 : Out   std_logic);
end DataPathI2C;

architecture behavioral of DataPathI2C is

  signal shift_mode1_s : std_logic;
  signal shift_mode2_s : std_logic;
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
  signal bit2_s        : std_logic;
  signal bit16_s       : std_logic_vector(3 downto 0);

--internal
  signal add_shift_s   : std_logic_vector(7 downto 0);
  signal in_shift_s    : std_logic_vector(7 downto 0);
  signal out_shift_s   : std_logic_vector(7 downto 0);

begin

  
  Reg: process(clk, rst)
  begin
    if (rst = '0') then				--reset Reg

       sda_s	    <= '0';   
       sda_ena_s    <= '0'; 
       sda_bit_s    <= '0'; 
       scl_s	    <= '0';   
       scl_ena_s    <= '0'; 
       bit2_cnt_s   <= '0'; 
       bit16_cnt_s  <= (7 downto 0);;
       ack          <= '0';
       rw           <= '0';

    else

      if (clock'event and clock = '1') then

        if (load_add = '1') then		--rw_reg
          rw <= VAL_SEND(0);
	end if;

        if (bit_cnt2_ena = '1') then		--cnt2_reg
          bit2_s <= bit2_cnt_s;
	end if;

        if (bit_cnt16_ena = '1') then		--cnt16_reg
          bit16_s <= bit16_cnt_s;
	end if;

        if (sda_ena = '0') then			--sda_in_reg
          sda_bit_s <= SDA;
	end if;

 	if (load_val = '1') then		--in_shift_reg
        in_shift_s  <= VAL_SEND(7 downto 1) & (load_add nor NOT VAL_SEND(0));  
	end if;

 	if (load_add = '1') then		--add_shift_reg
        add_shift_s  <= VAL_SEND;  
	end if;

 	if (read_val = '1') then		--out_shift_reg
        out_shift_s(0)  <= sda_bit_s;  
	end if;

        sda_ena_s <= sda_ena;			--sda_ena_reg
	sda_s     <= sda_pre_s;			--sda_out_reg
	scl_ena_s <= scl_ena;			--scl_ena_reg
	scl_s	  <= scl_pre_s;			--scl_pre_reg
	ack       <= NOT sda_ena and NOT SDA;	--ack_reg

      end if;

    end if;

  end process;

  ShiftReg: process(clock, rst)
  begin
    if (rst = '0') then				--reset ShiftReg

       data_bit1_s  <= '0';   
       data_bit2_s  <= '0'; 
       add_shift_s  <= (others => '0');
       in_shift_s   <= (others => '0');
       out_shift_s  <= (others => '0');
       VAL_REC	    <= (others => '0');

    else

      if (clock'event and clock = '1') then

        if (bit16_cnt_s and NOT shift_mode = '1') then	--in_shift
        in_shift_s <= in_shift_s(6 downto 0) & "0";
	end if;

        if (bit16_cnt_s and shift_mode = '1') then	--add_shift
        add_shift_s <= add_shift_s(6 downto 0) & "0";
	end if;

        if (read_val = '1') then			--out_shift
        out_shift_s <= out_shift_s(6 downto 0) & sda_bit_s;
	end if;

	data_bit1_s <= in_shift_s(7);
	data_bit2_s <= add_shift_s(7);
	VAL_REC     <= out_shift_s;

      end if;

    end if;

  end process;

  scl_pre_s <= ('1' AND NOT scl_mode(1) AND NOT scl_mode(0)) OR		  --SDA MUX
	       (NOT bit2_cnt_s AND NOT scl_mode(1) AND scl_mode(0)) OR
	       (bit2_cnt_s AND scl_mode(1) AND NOT scl_mode(0)) OR
	       (bit16_cnt_s AND scl_mode(1) AND scl_mode(0));


  sda_pre_s <= ('1' AND NOT sda_mode(1) AND NOT sda_mode(0)) OR		 --SCL MUX
	       (data_bit1_s AND NOT sda_mode(1) AND sda_mode(0)) OR
	       (data_bit2_s AND sda_mode(1) AND NOT sda_mode(0)) OR
	       ('0' AND sda_mode(1) AND sda_mode(0));

  SDA       <= sda_s WHEN (sda_ena_s = '1') ELSE 'Z';			--SDA Buffer

  SCL       <= scl_s WHEN (scl_ena_s = '1') ELSE 'Z';			--SCL Buffer

  bit2_s    <= '1' + bit2_cnt_s;					--bit2_counter

  bit16_s   <= '1' + bit16_cnt_s;					--bit16_counter

  cout2     <= bit2_s;							--carry out 2

  cout16    <= bit16_s(3) AND bit16_s(2) AND bit16_s(1) AND bit16_s(0); --carry out 16
  
end behavioral;

