/*
#	ZUMA Open FPGA Overlay
#	Alex Brant 
#	Email: alex.d.brant@gmail.com
#	2012
#	LUTRAM wrapper
*/
`include "define.v"
`include "def_generated.v"
module elut_custom(
	a,
	d,
	dpra,
	clk,
	we,
	dpo,
	qdpo_clk,
	qdpo_rst,
	qdpo);


input [5 : 0] a;
input [0 : 0] d;
input [5 : 0] dpra;
input clk;
input we;
input qdpo_clk;
input qdpo_rst;
output dpo;
output qdpo;

wire lut_output;
wire lut_registered_output;

`ifdef PLATFORM_XILINX      
//uses distributed dual-port RAM
//uses two luts, which can have two different read busses, sharing a common write logic.
elut_xilinx LUT (
  //read adress [5 : 0] for the first output, also write adress
  .a(a),
  //data input [0 : 0]
  .d(d),
  //read adress [5 : 0] for the second output
  .dpra(dpra),
  //first input clk and write clock
  .clk(clk),
  //input write enable
  .we(we),
  //second input clock
  .qdpo_clk(qdpo_clk),
  // input qdpo_rst 
  .qdpo_rst(qdpo_rst),
  //first unregistered output [0 : 0]
  .dpo(lut_output),
  //second registered output [0 : 0]
  .qdpo(lut_registered_output)
);
  
`elsif PLATFORM_ALTERA

	 SDPR LUT(
	.clock(clk),
	.data(d),
	.rdaddress(dpra),
	.wraddress(a),
	.wren(we),
	.q(lut_output));

`endif

`ifdef XILINX_ISIM //X'd inputs will break the simulation
assign dpo  = (lut_output === 1'bx) ? 0 : lut_output ;
assign qdpo = (lut_registered_output === 1'bx) ? 0 : lut_registered_output ;
`else
assign dpo  = lut_output;
assign qdpo = lut_registered_output;
`endif  


endmodule
