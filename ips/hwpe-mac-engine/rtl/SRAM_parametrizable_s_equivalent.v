module SRAM_parametrizable_s_equivalent (
	CLK,
	CEB,
	WEB,
	scan_en_in,
	A,
	D,
	Q
);
	parameter integer numWord = 1024;
	parameter integer numBit = 32;
	parameter numWordAddr = $clog2(numWord);
	input CLK;
	input CEB;
	input WEB;
	input scan_en_in;
	input [numWordAddr - 1:0] A;
	input [numBit - 1:0] D;
	output reg [numBit - 1:0] Q;
	wire CLK_gated;
	MEMS1D_BUFG_1024x32_wrapper SRAM_i(
		.CLK(CLK_gated),
		.D(D),
		.AS(A[9]),
		.AW(A[8:2]),
		.AC(A[1:0]),
		.CEN(CEB),
		.RDWEN(WEB),
		.BW(1'sb1),
		.Q(Q)
	);
	pulp_clock_gating i_clk_gate_l1_sparse(
		.clk_i(CLK),
		.en_i(~scan_en_in),
		.test_en_i(1'b0),
		.clk_o(CLK_gated)
	);
endmodule
