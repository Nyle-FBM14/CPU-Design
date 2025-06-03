library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port(
		ci		: in std_logic;
		a, b	: in std_logic_vector(31 downto 0);
		r		: out std_logic_vector(31 downto 0);
		co		: out std_logic
	);
end adder;

architecture behavior of adder is
	component adder1
		port(
			ci		: in std_logic;
			a, b	: in std_logic;
			r		: out std_logic;
			co		: out std_logic
		);
	end component;
	
	signal c	:	std_logic_vector(31 downto 0);
begin
	c(0) <= ci;
	add0: adder1 port map(c(0), a(0), b(0), r(0), c(1));
	add1: adder1 port map(c(1), a(1), b(1), r(1), c(2));
	add2: adder1 port map(c(2), a(2), b(2), r(2), c(3));
	add3: adder1 port map(c(3), a(3), b(3), r(3), c(4));
	add4: adder1 port map(c(4), a(4), b(4), r(4), c(5));
	add5: adder1 port map(c(5), a(5), b(5), r(5), c(6));
	add6: adder1 port map(c(6), a(6), b(6), r(6), c(7));
	add7: adder1 port map(c(7), a(7), b(7), r(7), c(8));
	add8: adder1 port map(c(8), a(8), b(8), r(8), c(9));
	add9: adder1 port map(c(9), a(9), b(9), r(9), c(10));
	add10: adder1 port map(c(10), a(10), b(10), r(10), c(11));
	add11: adder1 port map(c(11), a(11), b(11), r(11), c(12));
	add12: adder1 port map(c(12), a(12), b(12), r(12), c(13));
	add13: adder1 port map(c(13), a(13), b(13), r(13), c(14));
	add14: adder1 port map(c(14), a(14), b(14), r(14), c(15));
	add15: adder1 port map(c(15), a(15), b(15), r(15), c(16));
	add16: adder1 port map(c(16), a(16), b(16), r(16), c(17));
	add17: adder1 port map(c(17), a(17), b(17), r(17), c(18));
	add18: adder1 port map(c(18), a(18), b(18), r(18), c(19));
	add19: adder1 port map(c(19), a(19), b(19), r(19), c(20));
	add20: adder1 port map(c(20), a(20), b(20), r(20), c(21));
	add21: adder1 port map(c(21), a(21), b(21), r(21), c(22));
	add22: adder1 port map(c(22), a(22), b(22), r(22), c(23));
	add23: adder1 port map(c(23), a(23), b(23), r(23), c(24));
	add24: adder1 port map(c(24), a(24), b(24), r(24), c(25));
	add25: adder1 port map(c(25), a(25), b(25), r(25), c(26));
	add26: adder1 port map(c(26), a(26), b(26), r(26), c(27));
	add27: adder1 port map(c(27), a(27), b(27), r(27), c(28));
	add28: adder1 port map(c(28), a(28), b(28), r(28), c(29));
	add29: adder1 port map(c(29), a(29), b(29), r(29), c(30));
	add30: adder1 port map(c(30), a(30), b(30), r(30), c(31));
	add31: adder1 port map(c(31), a(31), b(31), r(31), co);
	
end behavior;