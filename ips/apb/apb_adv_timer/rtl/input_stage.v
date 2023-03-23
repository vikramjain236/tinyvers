module input_stage (
	clk_i,
	rstn_i,
	ctrl_active_i,
	ctrl_update_i,
	ctrl_arm_i,
	cnt_end_i,
	cfg_sel_i,
	cfg_sel_clk_i,
	cfg_mode_i,
	ls_clk_i,
	signal_i,
	event_o
);
	parameter EXTSIG_NUM = 32;
	input wire clk_i;
	input wire rstn_i;
	input wire ctrl_active_i;
	input wire ctrl_update_i;
	input wire ctrl_arm_i;
	input wire cnt_end_i;
	input wire [7:0] cfg_sel_i;
	input wire cfg_sel_clk_i;
	input wire [2:0] cfg_mode_i;
	input wire ls_clk_i;
	input wire [EXTSIG_NUM - 1:0] signal_i;
	output reg event_o;
	wire s_rise;
	wire s_rise_ls_clk;
	wire s_fall;
	reg s_int_evnt;
	wire s_event;
	wire r_active;
	reg r_event;
	reg r_oldval;
	reg s_int_sig;
	reg [7:0] r_sel;
	reg [2:0] r_mode;
	reg r_armed;
	reg [2:0] r_ls_clk_sync;
	assign s_rise = ~r_oldval & s_int_sig;
	assign s_fall = r_oldval & ~s_int_sig;
	assign s_rise_ls_clk = ~r_ls_clk_sync[2] & r_ls_clk_sync[1];
	always @(posedge clk_i or negedge rstn_i) begin : proc_r_ls_clk_sync
		if (~rstn_i)
			r_ls_clk_sync <= 'h0;
		else
			r_ls_clk_sync <= {r_ls_clk_sync[1:0], ls_clk_i};
	end
	always @(posedge clk_i or negedge rstn_i) begin : proc_r_mode
		if (~rstn_i) begin
			r_mode <= 0;
			r_sel <= 0;
		end
		else if (ctrl_update_i) begin
			r_mode <= cfg_mode_i;
			r_sel <= cfg_sel_i;
		end
	end
	always @(*) begin : proc_event_o
		if (cfg_sel_clk_i)
			event_o = s_int_evnt & s_rise_ls_clk;
		else
			event_o = s_int_evnt;
	end
	always @(*) begin : proc_s_int_evnt
		case (r_mode)
			3'b000: s_int_evnt = 1'b1;
			3'b001: s_int_evnt = ~s_int_sig;
			3'b010: s_int_evnt = s_int_sig;
			3'b011: s_int_evnt = s_rise;
			3'b100: s_int_evnt = s_fall;
			3'b101: s_int_evnt = s_rise | s_fall;
			3'b110:
				if (r_armed)
					s_int_evnt = (s_rise ? 1'b1 : r_event);
				else
					s_int_evnt = 1'b0;
			3'b111:
				if (r_armed)
					s_int_evnt = (s_fall ? 1'b1 : r_event);
				else
					s_int_evnt = 1'b0;
		endcase
	end
	always @(*) begin : proc_int_sig
		s_int_sig = 0;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < EXTSIG_NUM; i = i + 1)
				if (r_sel == i)
					s_int_sig = signal_i[i];
		end
	end
	always @(posedge clk_i or negedge rstn_i) begin : proc_r_event
		if (~rstn_i) begin
			r_event <= 1'b0;
			r_armed <= 1'b0;
		end
		else begin
			if (r_armed)
				r_event <= s_int_evnt;
			else if (cnt_end_i)
				r_event <= 1'b0;
			if (ctrl_arm_i)
				r_armed <= 1'b1;
			else if (cnt_end_i)
				r_armed <= 1'b0;
		end
	end
	always @(posedge clk_i or negedge rstn_i) begin : proc_r_sync
		if (~rstn_i)
			r_oldval <= 0;
		else if (ctrl_active_i)
			if (!cfg_sel_clk_i || (cfg_sel_clk_i && s_rise_ls_clk))
				r_oldval <= s_int_sig;
	end
endmodule
