module tc_pwr_level_shifter_in (
	in_i,
	out_o
);
	input wire in_i;
	output wire out_o;
	assign out_o = in_i;
endmodule
module tc_pwr_level_shifter_in_clamp_lo (
	in_i,
	out_o,
	clamp_i
);
	input wire in_i;
	output wire out_o;
	input wire clamp_i;
	assign out_o = (clamp_i ? 1'b0 : in_i);
endmodule
module tc_pwr_level_shifter_in_clamp_hi (
	in_i,
	out_o,
	clamp_i
);
	input wire in_i;
	output wire out_o;
	input wire clamp_i;
	assign out_o = (clamp_i ? 1'b1 : in_i);
endmodule
module tc_pwr_level_shifter_out (
	in_i,
	out_o
);
	input wire in_i;
	output wire out_o;
	assign out_o = in_i;
endmodule
module tc_pwr_level_shifter_out_clamp_lo (
	in_i,
	out_o,
	clamp_i
);
	input wire in_i;
	output wire out_o;
	input wire clamp_i;
	assign out_o = (clamp_i ? 1'b0 : in_i);
endmodule
module tc_pwr_level_shifter_out_clamp_hi (
	in_i,
	out_o,
	clamp_i
);
	input wire in_i;
	output wire out_o;
	input wire clamp_i;
	assign out_o = (clamp_i ? 1'b1 : in_i);
endmodule
module tc_pwr_power_gating (
	sleep_i,
	sleepout_o
);
	input wire sleep_i;
	output wire sleepout_o;
	assign sleepout_o = sleep_i;
endmodule
module tc_pwr_isolation_lo (
	data_i,
	ena_i,
	data_o
);
	input wire data_i;
	input wire ena_i;
	output wire data_o;
	assign data_o = (ena_i ? data_i : 1'b0);
endmodule
module tc_pwr_isolation_hi (
	data_i,
	ena_i,
	data_o
);
	input wire data_i;
	input wire ena_i;
	output wire data_o;
	assign data_o = (ena_i ? data_i : 1'b1);
endmodule
