library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ram is
	generic (bits:integer:=1+4+5;
			words: integer:=5);
	port(clk, wr_ena: in std_logic;
		addr:in std_logic_vector(words-1 downto 0);
		data_in:in std_logic_vector(bits-1 downto 0);
		data_out:out std_logic_vector(bits-1 downto 0));
end entity;
	
architecture ram_arch of ram is
	type vector_array is array (0 to 32-1) of std_logic_vector(bits-1 downto 0);
	signal addd:integer;
	signal memory: vector_array:=( "0001000101",--ADD 00101
	                               "1011100100",--I AND 00100
	                               "0101000000",--INC A
	                               "0111001000",--BSA
	                               
	                               "0000000110",--ADRESS DATA 2
	                               "0110101001",--DATA1
	                               "0011001100",--DATA2
	                               "0000000000",--LOC where acc is stored
	                               
	                               "0101100111",--STA at 00111
	                               "0100100000",--CLA
	                               "0110000111",--LDA 00111
	                               "0000000000",
	                               
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               
	                               "0000000000",
	                               "0000000000",
	                               "0000000000",
	                               "0000000000");
	begin
	 process(wr_ena,clk)
    begin
	 if(wr_ena='0' and clk'event) then
	   	data_out <=memory(conv_integer(addr));
	 elsif(wr_ena='1') then
	 	  if (clk'event) then	   	   
		     memory(conv_integer(addr)) <= data_in;
		  end if;
	end if;
	end process;
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb is
end entity;

architecture tb_arch of tb is
  signal clk: std_logic:='1';
  signal data_out:std_logic_vector(9 downto 0):="0000000000";
  signal data_in:std_logic_vector(9 downto 0):="0000000000";
  signal add:std_logic_vector(4 downto 0):="00000";
  signal wr_ena:std_logic:='0';
  component ram is
	generic (bits:integer:=1+4+5;
			words: integer:=5);
	port(clk, wr_ena: in std_logic;
		addr:in std_logic_vector(words-1 downto 0);
		data_in:in std_logic_vector(bits-1 downto 0);
		data_out:out std_logic_vector(bits-1 downto 0));
end component;
  
begin
  p1: ram port map(clk,wr_ena,add,data_in,data_out);
  clo: process
  begin
    clk <= not clk after 10 ns;
    wait for 10 ns;
  end process;
  main: process
  begin
    wr_ena<='0';
    wait for 20 ns;
    add<="00001";
    wait for 20 ns;
    add<="00010";
    wait for 20 ns;
    add<="00011";
    
  end process;
end architecture;

