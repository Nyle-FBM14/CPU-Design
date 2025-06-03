LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY datapath IS
PORT( 
		-- clock Signal
		Clk, mClk : IN STD_LOGIC;
		
		--Memory Signals
		WEN, EN : IN STD_LOGIC;
		
		-- Register Control Signals (CLR and LD).
		Clr_A , Ld_A 	: IN STD_LOGIC;
		Clr_B , Ld_B 	: IN STD_LOGIC;
		Clr_C , Ld_C 	: IN STD_LOGIC;
		Clr_Z , Ld_Z 	: IN STD_LOGIC;
		ClrPC , Ld_PC : IN STD_LOGIC;
		ClrIR , Ld_IR : IN STD_LOGIC;
		
		-- Register outputs (Some needed to feed back to control unit. Others pulled out for testing.
		Out_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_C : OUT STD_LOGIC;
		Out_Z : OUT STD_LOGIC;
		Out_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		-- Special inputs to PC.
		Inc_PC : IN STD_LOGIC;
		
		-- Address and Data Bus signals for debugging.
		ADDR_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		DATA_BUS, MEM_OUT, MEM_IN : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MEM_ADDR : OUT UNSIGNED(7 DOWNTO 0);
		-- Various MUX controls.
		DATA_Mux: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		REG_Mux : IN STD_LOGIC;
		A_MUX, B_MUX : IN STD_LOGIC;
		IM_MUX1 : IN STD_LOGIC;
		IM_MUX2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		-- ALU Operations.
		ALU_Op : IN STD_LOGIC_VECTOR(2 DOWNTO 0));
END datapath;
ARCHITECTURE description OF datapath IS
-- Component instantiations -- you figure this out
-- Internal signals -- you decide what you need
	component data_mem is
		port(
			clk		:	in std_logic;
			addr		:	in unsigned(7 downto 0);
			data_in	:	in std_logic_vector(31 downto 0);
			wen		:	in std_logic;
			en			:	in std_logic;
			data_out	:	out std_logic_vector(31 downto 0)
		);
	end component;

	component register32 is
		port(
			d		:	in std_logic_vector(31 downto 0);
			ld		:	in std_logic;
			clr	:	in std_logic;
			clk	: 	in std_logic;
			Q		:	out std_logic_vector(31 downto 0)
		);
	end component;

	component pc is
		port(
			clr	:	in std_logic;
			clk	: 	in std_logic;
			ld		:	in std_logic;
			inc	:	in std_logic;
			d		:	in std_logic_vector(31 downto 0);
			q		:	out std_logic_vector(31 downto 0)
		);
	end component;

	component LZE is
		port(
				LZE_in		: in std_logic_vector(31 downto 0);
				LZE_out		: out std_logic_vector(31 downto 0)
		);
	end component;

	component UZE is
		port(
				UZE_in		: in std_logic_vector(31 downto 0);
				UZE_out		: out std_logic_vector(31 downto 0)
		);
	end component;

	component RED is
		port(
				RED_in		: in std_logic_vector(31 downto 0);
				RED_out		: out unsigned(7 downto 0)
		);
	end component;

	component mux2to1 is
		port(
			s				:	in std_logic;
			w0, w1		:	in std_logic_vector(31 downto 0);
			f				:	out std_logic_vector(31 downto 0)
		);
	end component;

	component mux4to1 is
		port ( s							:	in std_logic_vector(1 downto 0);
				 w0, w1, w2, w3		:	in std_logic_vector(31 downto 0);
				 f							: out std_logic_vector(31 downto 0)
		);
	end component;

	component alu is 
		port (
			a, b			: in std_logic_vector(31 downto 0);
			op				: in std_logic_vector(2 downto 0);
			result		: out std_logic_vector(31 downto 0);
			cout, zero	: out std_logic
		);
	end component;


	signal IR_OUT					:	std_logic_vector(31 downto 0);
	signal data_bus_s			:	std_logic_vector(31 downto 0);
	signal LZE_out_PC			:	std_logic_vector(31 downto 0);
	signal LZE_out_A_Mux			:	std_logic_vector(31 downto 0);
	signal LZE_out_B_Mux			:	std_logic_vector(31 downto 0);
	signal RED_out_Data_Mem			:	unsigned(7 downto 0);
	signal A_Mux_out			:	std_logic_vector(31 downto 0);
	signal B_Mux_out			:	std_logic_vector(31 downto 0);
	signal reg_A_out			:	std_logic_vector(31 downto 0);
	signal reg_B_out			:	std_logic_vector(31 downto 0);
	signal reg_Mux_out			:	std_logic_vector(31 downto 0);
	signal data_mem_out			:	std_logic_vector(31 downto 0);
	signal UZE_IM_MUX1_out			:	std_logic_vector(31 downto 0);
	signal IM_MUX1_out			:	std_logic_vector(31 downto 0);
	signal LZE_IM_MUX2_out			:	std_logic_vector(31 downto 0);
	signal IM_MUX2_out			:	std_logic_vector(31 downto 0);
	signal ALU_out				:	std_logic_vector(31 downto 0);
	signal zero_flag			:	std_logic;
	signal carry_flag			:	std_logic;
	signal temp				:	std_logic_vector(30 downto 0) := (others => '0');
	signal out_pc_sig			:	std_logic_vector(31 downto 0);

BEGIN
-- you fill in the details END
	IR:	register32 port map(
				data_bus_s,
				Ld_IR,
				ClrIR,
				Clk,
				IR_OUT
			);

	LZE_PC:	LZE port map(
					IR_OUT,
					LZE_out_PC
				);
				
	PC0:	PC port map(
					CLRPC,
					Clk,
					ld_PC,
					INC_PC,
					LZE_out_PC,
					out_Pc_sig
			);
			
	LZE_A_Mux:	LZE port map(
							IR_OUT,
							LZE_out_A_Mux
					);
					
	A_Mux0:	mux2to1 port map(
							A_MUX,
							data_bus_s,
							LZE_out_A_Mux,
							A_Mux_out
							);
							
	Reg_A:	register32 port map(
								A_Mux_out,
								Ld_A,
								Clr_A,
								Clk,
								reg_A_out
				);
				
	LZE_B_Mux:	LZE port map(
							IR_OUT,
							LZE_out_B_Mux
							);
							
	B_Mux0:	mux2to1	port map(
							B_MUX,
							data_bus_s,
							LZE_out_B_Mux,
							B_Mux_out
							);
							
	Reg_B: register32 port map(
							B_Mux_out,
							Ld_B,
							Clr_B,
							Clk,
							reg_B_out
							);
							
	Reg_Mux0:	mux2to1 port map(
								REG_MUX,
								Reg_A_out,
								Reg_B_out,
								Reg_Mux_out
								);
								
	RED_Data_Mem: RED port map(
							IR_OUT,
							RED_out_data_mem
							);
						
	Data_Mem0:	data_mem port map(
								mClk,
								RED_out_data_mem,
								Reg_Mux_out,
								WEN,
								EN,
								data_mem_out
								);
								
	UZE_IM_MUX1: UZE port map(
							IR_OUT,
							UZE_IM_MUX1_out
							);
							
	IM_MUX1a:	mux2to1 port map(
								IM_MUX1,
								reg_A_out,
								UZE_IM_MUX1_out,
								IM_MUX1_out
								);
								
	LZE_IM_MUX2: LZE port map(
							IR_OUT,
							LZE_IM_MUX2_out
							);
							
	IM_MUX2a:	mux4to1 port map(
								IM_MUX2,
								reg_B_out,
								LZE_IM_MUX2_out, (temp & '1'), (others => '0'),
								IM_MUX2_out
								);
								
	ALU0:	ALU port map(
					IM_MUX1_out,
					IM_MUX2_out,
					ALU_op,
					ALU_out,
					zero_flag,
					carry_flag
					);
					
	DATA_MUX0: mux4to1 port map(
								DATA_MUX,
								DATA_IN,
								data_mem_out,
								ALU_out,
								(others => '0'),
								data_bus_s
								);
								
	DATA_BUS 	<= data_bus_s;
	OUT_A			<= reg_A_out;
	OUT_B			<= reg_B_out;
	OUT_IR		<= IR_OUT;
	ADDR_OUT		<= out_pc_sig;
	OUT_PC		<= out_pc_sig;
	
	MEM_ADDR		<= RED_out_Data_Mem;
	MEM_IN		<= Reg_Mux_out;
	MEM_OUT		<= data_mem_out;
	
END description;

--Questions
--How does this data-path implement the INCA, ADDI, LDBI and LDA operations? 
--INCA: first a value is given to the DATA_IN signal
--		 (supposed to come from instruction memory). This data is then loaded into
--		 register A either immediately (LDAI) or from memory (LDA).
--		 Then the add operation code is given to the ALU to add the value in
--		 register A (IM_MUX1 = 0) and a '1' signal value (IM_MUX2 = 2).
--		 The data bus carries the output from the ALU (DATA_MUX = 2).
--		 In the waveforms, the output is usually loaded into register A.
--		 Zero and Carry flags are loaded from the result.
--ADDI: first a value is given to the DATA_IN signal and loaded into register A.
--		  Waveforms to show functionality usually use LDAI to load register A.
--		  Another value is given to DATA_IN and this is loaded into IR.
--		  Then the add operation code is given to the ALU to add the value in
-- 	  and the immediate value that was loaded into IR prior. However, only
--		  the lower half of the data from DATA_IN is used (using LZE) since
--      an ADDI instruction would only have 16bits of space for the immediate
--		  value. But the instruction register has not been implemented and only
--		  simulated.
--LDBI: a value is given to DATA_IN. This data is loaded into IR.
--		  Afterwards, this is value is loaded into register B through LZE (B_MUX = 1)
--		  to simulate a 16bit space for an immediate instruction.
--LDA:	Assuming there is data already inside the DATA MEMORY.
--			An address is given to DATA_IN, this address is then loaded into IR.
--			This address passes through the reducer (RED) into DATA MEMORY.
--			To load register A from memory, the DATA MEMORY is enabled (EN = 1).
--			DATA_MUX chooses to output the data from memory onto the DATA_BUS.
--			The value passing through the DATA_BUS is loaded into register A,
--			with A_MUX = 0.
--The data-path has a maximum reliable operating speed (Clk). What determines this speed? (i.e. 
--how would you estimate the data-path circuit clock)? 
--		It would be the time it takes for the longest path in the data path to
--		complete, taking into account the propagation delays between all parts
--		in that path.
--What is a reliable limit for your data-path clock? 
--	Based on the waveforms, an operation usually takes 100ns and would make
--	a reliable limit for the data-path clock.
