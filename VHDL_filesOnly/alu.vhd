library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is 
	port (
		a, b			: in std_logic_vector(31 downto 0);
		op				: in std_logic_vector(2 downto 0);
		result		: out std_logic_vector(31 downto 0);
		cout, zero	: out std_logic
	);
end alu;

architecture description of alu is

	component mux4to1
		port (
			 s							:	in std_logic_vector(1 downto 0);
			 w0, w1, w2, w3		:	in std_logic_vector(31 downto 0);
			 f							: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component mux2to1
		port (s				:	in std_logic;
				w0, w1		:	in std_logic_vector(31 downto 0);
				f				:	out std_logic_vector(31 downto 0)
		);
	end component;
	
	component adder
		port(
			ci		: in std_logic;
			a, b	: in std_logic_vector(31 downto 0);
			r		: out std_logic_vector(31 downto 0);
			co		: out std_logic
		);
	end component;
	component shift
		port(
			s		:	in std_logic;
			a		:	in std_logic_vector(31 downto 0);
			f		: 	out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal andR		: std_logic_vector(31 downto 0);
	signal orR		: std_logic_vector(31 downto 0);
	signal rot		: std_logic_vector(31 downto 0);
	signal adderR	: std_logic_vector(31 downto 0);
	
	signal mux4out	: std_logic_vector(31 downto 0);
	signal mux2out	: std_logic_vector(31 downto 0);
	signal andROL	: std_logic_vector(31 downto 0);
	signal orROR	: std_logic_vector(31 downto 0);

begin
	andR <= a and b;
	orR <= a or b;
	addSub: adder port map (op(2), a, mux2out, adderR, cout);
	rotate: shift port map (op(0), a, rot);
	
	mux2: mux2to1 port map (op(2), b, (not b), mux2out);
	andLeft: mux2to1 port map (op(2), andR, rot, andROL);
	orRight: mux2to1 port map (op(2), orR, rot, orROR);
	mux4: mux4to1 port map (op(1 downto 0), andROL, orROR, adderR, b, mux4out);
	
	result <= mux4out;
	zero <= '1' when (mux4out = "00000000000000000000000000000000") else
			  '0';
end description;