--
-- Stefan von Burg 
-- 21.06.2016
-- Bachelor-Thesis
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ControlFSM is
  
      Port (      clk : In    std_logic;
                  rst : In    std_logic;
             enatrans : In    std_logic;
                  ack : In    std_logic;
                   rw : In    std_logic;
                cout2 : In    std_logic;
               cout16 : In    std_logic;
             load_val : Out   std_logic;
             load_add : Out   std_logic;
             read_val : Out   std_logic;
           shift_mode : Out   std_logic_vector(1 downto 0);
         bit_cnt2_ena : Out   std_logic;
        bit_cnt16_ena : Out   std_logic;
             sda_mode : Out   std_logic_vector(1 downto 0); 
             scl_mode : Out   std_logic_vector(1 downto 0);
              sda_ena : Out   std_logic;
              scl_ena : Out   std_logic;
                 busy : Out   std_logic;
                 er   : Out   std_logic;);

end ControlFSM;


architecture behavioral of ControlFSM is

  type StateType is 	(ready,
                         load,
                         start,
                         sadw,
                         sack,
                         er,
                         sub,
                         sack2,
                         sr,
                         datasend,
                         sadr,
                         sack3,
                         dataread,
                         mak,
                         stop);

  signal outvec       : std_logic_vector(14 downto 0);
  signal state        : StateType;
  signal enatrans_s   : std_logic;

begin

  Transition: process(clk, rst)

  begin

    if (rst = '0') then
      state <= ready;
      enatrans_s <= '0';

    elsif (clk'event and clock = '1') then
      enatrans_s <= enatrans; 
      
    case state is
        
        when ready =>
          if (enatrans_s = '1') then
            state <= load;
          end if;
        when load =>
	  state <= start;
	when start =>
	  if (cout2 = '1') then
            state <= sadw;
          end if;
	when sadw =>
          if (cout16 = '1') then
            state <= sack;
          end if;
        when sack =>
	  if (cout2 = '1' and ack = '0') then
           state <= er;
          elsif(cout2 = '1' and ack = '1') then
           state <= sub
          end if;	  
        when er =>
          state <= ready;
	when sub =>
          if (cout16 = '1') then
            state <= sack2;
          end if;
	when sack2 =>
          if (cout2 = '1' and ack = '0') then
            state <= er;
          elsif (cout2 = '1' and ack = '1' and rw = '0')
            state <= datasend;
          elsif (cout2 = '1' and ack = '1' and rw = '1')
            state <= sr;
          end if;  
        when datasend =>
          if (cout16 = '1') then
            state <= sack3;
          end if;
        when sr =>
          if (cout2 = '1') then
            state <= sadr;
          end if;
        when sadr =>
          if (cout16 = '1') then
            state <= sack3
          end if;
        when sack3 =>
          if (cout2 = '1' and ack = '0') then
            state <= er;
          elsif (cout2 = '1' and ack = '1' and rw = '0')
            state <= stop;
          elsif (cout2 = '1' and ack = '1' and rw = '1')
            state <= dataread;
          end if;  
        when stop =>
          if (cout2 = '1')
            state <= ready;
          end if;
        when dataread =>
          if (cout16 = '1') then
            state <= mak;
          end if;
        when mak =>
          if (cout2 = '1') then
            state <= stop;
          end if;

  end process;
                                 

  OutBlock: process(state)
  begin
    case state is

	when ready =>
 	  outvec <= "000000000000000";
        when load =>
 	  outvec <= "010000000000010";
        when start =>
 	  outvec <= "000001011011110";
        when sadw =>
 	  outvec <= "000100101111110";
        when sack =>
 	  outvec <= "1000010--100110";
	when er =>
 	  outvec <= "0000000--000011";
	when sub =>
 	  outvec <= "000000000000000";
	when sack2 =>
 	  outvec <= "000000000000000";
	when sr =>
 	  outvec <= "000000000000000";
	when datasend =>
 	  outvec <= "000000000000000";
	when sadr =>
 	  outvec <= "000000000000000";
	when sack3 =>
 	  outvec <= "000000000000000";
	when dataread =>
 	  outvec <= "000000000000000";
	when mak =>
 	  outvec <= "000000000000000";
	when stop =>
 	  outvec <= "000000000000000";

      when others=> outvec <= "-------";
    end case;
  end process;

  load_val       <= outvec(0);
  load_add       <= outvec(1);
  read_val       <= outvec(2);
  shift_mode     <= outvec(4 downto 3);
  bit_cnt2_ena   <= outvec(5);
  bit_cnt16_ena  <= outvec(6);
  sda_mode       <= outvec(8 downto 7);
  scl_mode       <= outvec(10 downto 9);
  sda_ena        <= outvec(11);
  scl_ena        <= outvec(12);
  busy           <= outvec(13); 
  er             <= outvec(14);

end behavioral;

