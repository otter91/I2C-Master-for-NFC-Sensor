-- updated version
-- elaborated rules: differenciate between 16 or 18 if ace is present
-- Marcel Jacomet 
-- December 31 Mar 2014
-- HuCE-microLab
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity DataPath is
      Port (cardvalue : In    std_logic_vector(3 downto 0);
                clock : In    std_logic;
               enaAdd : In    std_logic;
              enaLoad : In    std_logic;
             enaScore : In    std_logic;
                  rst : In    std_logic;
                  sel : In    std_logic;
                cmp11 : Out   std_logic;
                cmp16 : Out   std_logic;
                cmp18 : Out   std_logic;
                cmp21 : Out   std_logic;
                score : Out   std_logic_vector(4 downto 0));
end DataPath;

architecture behavioral of DataPath is

  signal regLoad_s  : std_logic_vector(4 downto 0);
  signal regAdd_s   : std_logic_vector(4 downto 0);
  signal value_s    : std_logic_vector(4 downto 0);

begin
  --   The process "Reg" for the data-path registers,
  --   as example the accumulator is already described. Try to understand it.
  --   Be aware, that VHDL is strictly data type sensitive: In case you need 
  --   to adapt the length of types to each other, use the concatenate operator
  --   to combine two vectors to one:  "vector3" <= "vector1" & "vector2";
  
  Reg: process(clock, rst)
  begin
    if (rst = '0') then

      regLoad_s  <= (others => '0');
      regAdd_s   <= (others => '0');
      value_s    <= (others => '0');
      score    <= (others => '0');

    else

      if (clock'event and clock = '1') then

        if (enaAdd = '1') then
          regAdd_s <= regAdd_s + regLoad_s;
	end if;

	if (enaLoad = '1') then
	  if(sel = '1') then
	  regLoad_s <= '0'&cardValue;
          else
	  regLoad_s <= "10110";
	  end if;
	end if;

	if (enaScore = '1') then
          score <= regAdd_s;
	end if;

      end if;

    end if;

  end process;

  cmp11 <= '1' when (regLoad_s = "01011") else '0';
  cmp16 <=  '1' when (regAdd_s > "10000") else '0';
  cmp21 <= '1' when (regAdd_s > "10101") else '0';

end behavioral;

