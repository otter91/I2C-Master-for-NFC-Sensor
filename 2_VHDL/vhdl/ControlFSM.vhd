--
-- Stefan von Burg 
-- 15.06.2016
-- Bachelor-Thesis
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ControlFSM is
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
end ControlFSM;


architecture behavioral of ControlFSM is
  type StateType is 	(callcard,
			                loadcard,
			                addval,
			                decide,
			                hidelost,
			                showwin,
			                load1,
			                load2,
			                decidewithace,
			                addvalwithace,
			                loadcardwithace,
			                callcardwithace,
			                IllegalState);

  signal outvec       : std_logic_vector(6 downto 0);
  signal state        : StateType;
  signal cardReadySync: std_logic;

begin
  --  the signal 'cardReady' is an asynchronous input signal
  --  used by the finit state machine which NEEDS to be synchronized!
  --  The synchronized signal is named 'cardReadySync' (see theory slides for explanation).
      
  --  skeletton of state transition table of finit state machine
  --  add your VHDL code to complete
  Transition: process(clock, rst)
  begin
    if (rst = '0') then
      cardReadySync <= '0';
      state <= callcard;
    elsif (clock'event and clock = '1') then
      cardReadySync <= cardReady; 
      
    case state is
        
	when callcard =>
          if (cardReadySync = '1') then
            state <= loadcard;
          end if;
	when loadcard =>
	  state <= addval;
	when addval =>
	  state <= decide;
	when decide =>
	  if (cardReadySync = '0') then
	    if (cmp16 = '1' and cmp21 = '1') then
	    state <= hidelost;
	    elsif (cmp16 = '1' and cmp21 = '0' and cmp11 = '0') then
	    state <= showwin;
	    elsif (cmp21 = '1' and cmp11 = '1') then
	    state <= load2;
	    elsif (cmp16 = '0' and cmp11 = '0') then
	    state <= callcard;
	    elsif (cmp16 = '0' and cmp11 = '1') then
	    state <= callcardwithace;
	    end if;	  
	  end if;
	when hidelost =>
	when showwin =>
	when load1 =>
	  if (cmp11 = '0') then
	      state <= addval;
	  else
	      state <= addvalwithace;
	  end if;	
	when load2 =>
	  state <= addval;
	when decidewithace =>
	  if (cardReadySync = '0') then
	    if (cmp16 = '1' and cmp21 = '0') then
	    state <= showwin;
	    elsif (cmp16 = '0' and cmp21 = '0') then
	    state <= showwin;
	    elsif (cmp21 = '1') then
	    state <= load1;
	    end if;	  
	  end if;
	when addvalwithace =>
	  state <= decidewithace;
	when loadcardwithace =>
          state <= addvalwithace;
	when callcardwithace =>
	  if (cardReadySync = '1') then
            state <= loadcardwithace;
          end if;
        

	when others => state <= IllegalState;
      end case;
    end if;
  end process;
                                 
  --  output logic of Moore finit state machine
  --  use of internal dummy signal called 'outvec'
  --  add your VHDL code to complete
  OutBlock: process(state)
  begin
    case state is

	when callcard | callcardwithace =>
 	  outvec <= "001-000";              --  don't care is a slash
	when loadcard | loadcardwithace =>
	  outvec <= "0011100";
	when addval | addvalwithace =>
	  outvec <= "000-010";
	when decide | decidewithace =>
	  outvec <= "000-000";
	when hidelost =>
	  outvec <= "110-000";
	when showwin =>
	  outvec <= "100-001";
	when load1 | load2 =>
	  outvec <= "0000100";
	
      when others=> outvec <= "-------";
    end case;
  end process;

  --  definition of internal dummy variable 'outvec' to real signals
  --  add your VHDL code to complete
  finished <= outvec(6);
  lost     <= outvec(5);
  newCard  <= outvec(4);
  sel      <= outvec(3);
  enaLoad  <= outvec(2);
  enaAdd   <= outvec(1);
  enaScore <= outvec(0);

end behavioral;

