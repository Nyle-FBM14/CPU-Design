library ieee;
use ieee.std_logic_1164.all;

entity adder1 is
	port(
		ci		: in std_logic;
		a, b	: in std_logic;
		r		: out std_logic;
		co		: out std_logic
	);
end adder1;

architecture behavior of adder1 is
begin
	r	<= (a xor b) xor ci;
	co	<= ((a xor b) and ci) or (a and b);
end behavior;