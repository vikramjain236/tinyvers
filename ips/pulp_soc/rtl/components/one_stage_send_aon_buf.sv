module one_stage_send_aon_buf
  (
    input logic sleep_signal_buf
  );

logic s_sleep_signal_buf;

SC7P5T_AONBUFX8_CSC28L i_aon_buf (.A(sleep_signal_buf), .Z(s_sleep_signal_buf));

endmodule
