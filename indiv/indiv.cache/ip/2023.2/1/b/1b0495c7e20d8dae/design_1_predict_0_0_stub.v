// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Mon Feb 12 02:44:59 2024
// Host        : DESKTOP-VPFT755 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_predict_0_0_stub.v
// Design      : design_1_predict_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "predict,Vivado 2023.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(s_axi_control_AWADDR, 
  s_axi_control_AWVALID, s_axi_control_AWREADY, s_axi_control_WDATA, s_axi_control_WSTRB, 
  s_axi_control_WVALID, s_axi_control_WREADY, s_axi_control_BRESP, s_axi_control_BVALID, 
  s_axi_control_BREADY, s_axi_control_ARADDR, s_axi_control_ARVALID, 
  s_axi_control_ARREADY, s_axi_control_RDATA, s_axi_control_RRESP, s_axi_control_RVALID, 
  s_axi_control_RREADY, ap_clk, ap_rst_n, interrupt, input_stream_TVALID, 
  input_stream_TREADY, input_stream_TDATA, input_stream_TDEST, input_stream_TKEEP, 
  input_stream_TSTRB, input_stream_TUSER, input_stream_TLAST, input_stream_TID, 
  output_stream_TVALID, output_stream_TREADY, output_stream_TDATA, output_stream_TDEST, 
  output_stream_TKEEP, output_stream_TSTRB, output_stream_TUSER, output_stream_TLAST, 
  output_stream_TID)
/* synthesis syn_black_box black_box_pad_pin="s_axi_control_AWADDR[3:0],s_axi_control_AWVALID,s_axi_control_AWREADY,s_axi_control_WDATA[31:0],s_axi_control_WSTRB[3:0],s_axi_control_WVALID,s_axi_control_WREADY,s_axi_control_BRESP[1:0],s_axi_control_BVALID,s_axi_control_BREADY,s_axi_control_ARADDR[3:0],s_axi_control_ARVALID,s_axi_control_ARREADY,s_axi_control_RDATA[31:0],s_axi_control_RRESP[1:0],s_axi_control_RVALID,s_axi_control_RREADY,ap_rst_n,interrupt,input_stream_TVALID,input_stream_TREADY,input_stream_TDATA[31:0],input_stream_TDEST[5:0],input_stream_TKEEP[3:0],input_stream_TSTRB[3:0],input_stream_TUSER[1:0],input_stream_TLAST[0:0],input_stream_TID[4:0],output_stream_TVALID,output_stream_TREADY,output_stream_TDATA[31:0],output_stream_TDEST[5:0],output_stream_TKEEP[3:0],output_stream_TSTRB[3:0],output_stream_TUSER[1:0],output_stream_TLAST[0:0],output_stream_TID[4:0]" */
/* synthesis syn_force_seq_prim="ap_clk" */;
  input [3:0]s_axi_control_AWADDR;
  input s_axi_control_AWVALID;
  output s_axi_control_AWREADY;
  input [31:0]s_axi_control_WDATA;
  input [3:0]s_axi_control_WSTRB;
  input s_axi_control_WVALID;
  output s_axi_control_WREADY;
  output [1:0]s_axi_control_BRESP;
  output s_axi_control_BVALID;
  input s_axi_control_BREADY;
  input [3:0]s_axi_control_ARADDR;
  input s_axi_control_ARVALID;
  output s_axi_control_ARREADY;
  output [31:0]s_axi_control_RDATA;
  output [1:0]s_axi_control_RRESP;
  output s_axi_control_RVALID;
  input s_axi_control_RREADY;
  input ap_clk /* synthesis syn_isclock = 1 */;
  input ap_rst_n;
  output interrupt;
  input input_stream_TVALID;
  output input_stream_TREADY;
  input [31:0]input_stream_TDATA;
  input [5:0]input_stream_TDEST;
  input [3:0]input_stream_TKEEP;
  input [3:0]input_stream_TSTRB;
  input [1:0]input_stream_TUSER;
  input [0:0]input_stream_TLAST;
  input [4:0]input_stream_TID;
  output output_stream_TVALID;
  input output_stream_TREADY;
  output [31:0]output_stream_TDATA;
  output [5:0]output_stream_TDEST;
  output [3:0]output_stream_TKEEP;
  output [3:0]output_stream_TSTRB;
  output [1:0]output_stream_TUSER;
  output [0:0]output_stream_TLAST;
  output [4:0]output_stream_TID;
endmodule
