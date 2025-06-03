library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shift is
	port(
		s		:	in std_logic;
		a		:	in std_logic_vector(31 downto 0);
		f		: 	out std_logic_vector(31 downto 0)
	);
end shift;

architecture Behavior of shift is
	signal rl	:	std_logic_vector(31 downto 0);
	signal rr	:	std_logic_vector(31 downto 0);
begin
	rl(31 downto 1) <= a(30 downto 0);
	rl(0) <= a(31);
	
	rr(30 downto 0) <= a(31 downto 1);
	rr(31) <= a(0);
	
	with s select
	f	<=	rl when '0',
			rr when others;
end Behavior;