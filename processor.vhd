library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity processor is
  generic(
          rom_a:integer:=6;
          rom_d:integer:=18;
          ram_a:integer:=5;
          ram_d:integer:=10);
end entity;

architecture processor_arch of processor is

  component rom is 
	generic (words: integer :=64;
		bits: integer :=18);
	port(
		addr: in std_logic_vector(5 downto 0);
		data: out std_logic_vector(bits-1 downto 0) );
  end component;
  
  component ram is
	generic (bits:integer:=1+4+5;
			words: integer:=5);
	port(clk, wr_ena: in std_logic;
		addr:in std_logic_vector(words-1 downto 0);
		data_in:in std_logic_vector(bits-1 downto 0);
		data_out:out std_logic_vector(bits-1 downto 0));
  end component;

  signal clock: std_logic:='1';
  signal mar: std_logic_vector(ram_a-1 downto 0):=(others=>'0');
  signal pc: std_logic_vector(ram_a-1 downto 0):=(others=>'0');
  signal ireg: std_logic_vector(rom_a-1 downto 0):=(others=>'0');
  signal sbr: std_logic_vector(ram_a-1 downto 0):=(others=>'0');
  signal mbr: std_logic_vector(ram_d-1 downto 0):=(others=>'0');
  signal ac: std_logic_vector(ram_d-1 downto 0):=(others=>'0');
  signal ibit: std_logic:='0';
  signal rom_address: std_logic_vector(rom_a-1 downto 0):=(others=>'0');
  signal rom_data: std_logic_vector(rom_d-1 downto 0):=(others=>'0');
  signal ram_address: std_logic_vector(ram_a-1 downto 0);
  signal ram_data_in: std_logic_vector(ram_d-1 downto 0):=(others=>'0');
  signal ram_data_out: std_logic_vector(ram_d-1 downto 0):=(others=>'0');
  signal wr_ena: std_logic:='0';
  
  begin
    p1: ram port map(clock,wr_ena,ram_address,ram_data_in,ram_data_out);
    p2: rom port map(rom_address, rom_data);
    
    clk1: process
    begin
      clock<=not clock after 20 ns;
      wait for 20 ns;
    end process;
    
    main:process(clock)
    begin
    if(clock' event and clock = '1') then
    --F1
    case rom_data(17 downto 14) is
      when "0001" =>
        wr_ena<='0';
        ram_address<=mar;
      when "0010" =>        
        ac<=mbr+ac;
      when "0011" =>
        ac<= mbr AND ac;
      when "0100" =>
        ac<= mbr OR ac;
      when "0101" =>
        ac<= mbr NOR ac;
      when "0110" =>
        ac<= mbr NAND ac;
      when "0111" =>
        ac<= mbr XOR ac;
      when "1000" =>
        ac<= mbr XNOR ac;
      when "1001" =>
        ac<=(others =>'0');
      when "1111" =>
        mbr<=ram_data_out;
      when others =>      
    end case;
    
    
    case rom_data(13 downto 10) is
      when "0000" =>
        
      when "0001" =>
        ac<=ac+'1';
      when "0010" =>
        mbr<=ac;
      when "0011" =>
        wr_ena<='1';
        ram_address<=mar;
        ram_data_in<=mbr;
      when "0100"=>
        ac<=mbr;         
      when "0101"=>
        sbr<=pc;
      when "0110"=>
        pc<=sbr+'1';
      when "0111"=>
        mar<=pc;
      when "1000"=>
        pc<=pc+'1';
      when "1001"=>
        mar<=mbr(4 downto 0);
      when "1010"=>
        pc<=mar;
      when others =>
    end case;
    
    case rom_data(7 downto 6) is
      when "00" =>
        rom_address<=rom_data(5 downto 0);
    --indirect specific
      when "01" =>
        if (ibit = '1') then
          ireg<=rom_address;
          rom_address<=rom_data(5 downto 0);
        else 
          rom_address<=rom_address+'1';
        end if;
      when "10" =>
        ibit<=mbr(9);
        rom_address<=(others =>'0');
        rom_address(5 downto 2)<=mbr(8 downto 5);
        --write the map instruction acc to the instruction set....
      when "11" =>
        rom_address<=ireg+'1';
      when others =>
    end case; 
    
  end if;
    end process;
    
  end architecture;
