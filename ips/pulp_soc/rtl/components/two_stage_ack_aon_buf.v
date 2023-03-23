module two_stage_ack_aon_buf (sleep_signal_buf);
	output wire sleep_signal_buf;
	wire s_sleep_signal_buf_1;
	wire s_sleep_signal_buf_2;
	SC7P5T_AONBUFX8_CSC28L i_aon_buf_1(
		.A(s_sleep_signal_buf_1),
		.Z(s_sleep_signal_buf_2)
	);
	SC7P5T_AONBUFX8_CSC28L i_aon_buf_2(
		.A(s_sleep_signal_buf_2),
		.Z(sleep_signal_buf)
	);
endmodule
