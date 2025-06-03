library ieee;
use ieee.std_logic_1164.all;

entity Control_NEW is
	port(
		clk, mclk : in std_logic;
		enable : in std_logic;
		statusC, statusZ : in std_logic;
		inst: in std_logic_vector(31 downto 0);
		A_Mux, B_Mux : out std_logic;
		IM_MUX1, REG_Mux : out std_logic;
		IM_MUX2, DATA_Mux : out std_logic_vector(1 downto 0);
		ALU_op : out std_logic_vector(2 downto 0);
		inc_PC, ld_PC : out std_logic;
		clr_IR : out std_logic;
		ld_IR : out std_logic;
		clr_A, clr_B, clr_C, clr_Z : out std_logic;
		ld_A, ld_B, ld_C, ld_Z : out std_logic;
		T : out std_logic_vector(2 downto 0);
		wen, en : out std_logic
	);
end Control_NEW;

architecture description of Control is
	type STATETYPE is (state_0, state_1, state_2);
	signal present_state: STATETYPE;
	signal Instruction_sig: std_logic_vector(3 downto 0);
	signal Instruction_sig2: std_logic_vector(7 downto 0);

	begin
		Instruction_sig <= inst(31 downto 28);
		Instruction_sig2 <= inst(31 downto 24);

		------- OPERATION DECODER -------
		process (present_state, inst, statusC, statusZ, enable, Instruction_sig, Instruction_sig2)
		begin
			if enable = '1' then
				if present_state = state_0 then --Fetch Address of next inst
					DATA_Mux <= "00";
					clr_IR <= '0';
					ld_IR <= '1';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					ld_B <= '0';
					clr_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					en <= '0';
					wen <= '0';

				elsif present_state = state_1 then --inc PC counter
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					ld_B <= '0';
					clr_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					en <= '0';
					wen <= '0';

					if Instruction_sig = "0010" then --STA
						DATA_Mux <= "00";
						REG_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '1';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '1';

					elsif Instruction_sig = "0011" then --STB
						DATA_Mux <= "00";
						REG_Mux <= '1';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '1';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '1';

					elsif Instruction_sig = "1001" then --LDA
						DATA_Mux <= "01";
						A_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '1';
						clr_A <= '0';
						ld_A <= '1';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '0';

					elsif Instruction_sig = "1010" then --LDB
						DATA_Mux <= "01";
						B_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '1';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '1';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '0';
					
					end if;

				elsif present_state = state_2 then
					
					if Instruction_sig = "0101" then --JMP
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '0';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
					
					elsif Instruction_sig = "0110" then --BEQ
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';

						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

					elsif Instruction_sig = "1000" then --BNE
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '1';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

					elsif Instruction_sig = "1001" then --LDA
						DATA_Mux <= "01";
						A_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';
						clr_A <= '0';
						ld_A <= '1';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '0';

					elsif Instruction_sig = "1010" then --LDB
						DATA_Mux <= "01";
						B_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '1';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '0';

					elsif Instruction_sig = "0010" then --STA
						DATA_Mux <= "00";
						REG_Mux <= '0';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '1';

					elsif Instruction_sig = "0011" then --STB
						DATA_Mux <= "00";
						REG_Mux <= '1';
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';
						clr_A <= '0';
						ld_A <= '0';
						ld_B <= '0';
						clr_B <= '0';
						clr_C <= '0';
						ld_C <= '0';
						clr_Z <= '0';
						ld_Z <= '0';
						en <= '1';
						wen <= '1';

					elsif Instruction_sig = "0000" then --LDAI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

						A_Mux <= '1';

					elsif Instruction_sig = "0001" then --LDBI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '0';
						ld_B <= '1';
						ld_C <= '0';
						ld_Z <= '0';

						B_Mux <= '1';

					elsif Instruction_sig = "0100" then --LUI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '1';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

						A_Mux <= '0';
						ALU_op <= "001";
						DATA_Mux <= "10";
						IM_MUX1 <= '1';

					elsif Instruction_sig2 = "01111001" then --ANDI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '1';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						A_Mux <= '0';
						ALU_op <= "000";
						DATA_Mux <= "10";
						IM_MUX1 <= '1';
						IM_MUX2 <= "01";

					elsif Instruction_sig2 = "01111110" then --DECA
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						A_Mux <= '0';
						ALU_op <= "110";
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "10";

					elsif Instruction_sig2 = "01110000" then --ADD
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						A_Mux <= '0';
						ALU_op <= "010";
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "00";

					elsif Instruction_sig2 = "01110010" then --SUB
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						A_Mux <= '0';
						ALU_op <= "110";
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "00";

					elsif Instruction_sig2 = "01110011" then --INCA
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						A_Mux <= '0';
						ALU_op <= "010";
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "10";

					elsif Instruction_sig2 = "01111011" then --AND
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						ALU_op <= "000";
						A_Mux <= '0';
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "00";

					elsif Instruction_sig2 = "01110001" then --ADDI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						ALU_op <= "010";
						A_Mux <= '0';
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "01";

					elsif Instruction_sig2 = "01111101" then --ORI
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						ALU_op <= "001";
						A_Mux <= '0';
						DATA_Mux <= "10";
						IM_MUX1 <= '0';
						IM_MUX2 <= "01";

					elsif Instruction_sig2 = "01110100" then --ROL
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						ALU_op <= "100";
						A_Mux <= '0';
						DATA_Mux <= "10";
						IM_MUX1 <= '0';

					elsif Instruction_sig2 = "01111111" then --ROR
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';

						ALU_op <= "101";
						A_Mux <= '0';
						DATA_Mux <= "10";
						IM_MUX1 <= '0';

					elsif Instruction_sig2 = "01110101" then --CLRA
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '1';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

					elsif Instruction_sig2 = "01110110" then --CLRB
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '1';
						clr_C <= '0';
						clr_Z <= '0';
						
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

					elsif Instruction_sig2 = "01110111" then --CLRC
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '1';
						clr_Z <= '0';
						
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';

					elsif Instruction_sig2 = "01111000" then --CLRZ
						clr_IR <= '0';
						ld_IR <= '0';
						ld_PC <= '0';
						inc_PC <= '0';

						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '1';
						
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';
					
					elsif Instruction_sig2 = "01111010" then --TSTZ
						if(statusZ = '1') then
							clr_IR <= '0'; --Inc PC count
							ld_IR <= '0';
							ld_PC <= '1';
							inc_PC <= '1';

							clr_A <= '0';
							clr_B <= '0';
							clr_C <= '0';
							clr_Z <= '0';
							
							ld_A <= '0';
							ld_B <= '0';
							ld_C <= '0';
							ld_Z <= '0';
						end if;
					
					elsif Instruction_sig2 = "01111100" then --TSTC
						if(statusC = '1') then
							clr_IR <= '0'; --Inc PC count
							ld_IR <= '0';
							ld_PC <= '1';
							inc_PC <= '1';

							clr_A <= '0';
							clr_B <= '0';
							clr_C <= '0';
							clr_Z <= '0';
							
							ld_A <= '0';
							ld_B <= '0';
							ld_C <= '0';
							ld_Z <= '0';
						end if;
					end if; --for state 2 Ops
				end if;
			end if; --for enable
		end process;

		------- STATE MACHINE -------
		process (clk, enable)
		begin
			if enable = '1' then
				if rising_edge (clk) then
					if present_state = state_0 then present_state <= state_1;
					elsif present_state = state_1 then present_state <= state_2;
					else present_state <= state_0;
					end if;
				end if;
			else
				present_state <= state_0;
			end if;
		end process;

		with present_state select
			T <=	"001" when state_0,
					"010" when state_1,
					"100" when state_2,
					"001" when others;
end description;