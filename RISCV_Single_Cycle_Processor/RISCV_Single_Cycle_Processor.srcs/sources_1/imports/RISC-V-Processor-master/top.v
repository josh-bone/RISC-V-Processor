// Name: Joshua Bone
// BU ID: U22742355
// EC413 Lab 2 Problem 3: Top Level Module

module top (
  input clock,
  input reset,

  input [31:0] instruction,
  output [31:0] wb_data
);


wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;

wire [31:0] imm;

assign read_sel1 = instruction[19:15];
assign read_sel2 = instruction[24:20];
assign write_sel = instruction[11:7];

// Sign extension
assign imm = { {20{instruction[31]}}, instruction[31:20]};

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// add any wire or reg variables you need here
wire [31:0] rs1, rs2;
wire [31:0] ALU_mux;
assign ALU_mux = op_B_sel ? imm : rs2;

// Fill in port connections
regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(ALU_result),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(rs1),
  .read_data2(rs2)
);


// Fill in port connections
ALU alu_inst(
  .ALU_Control(ALU_Control),
  .operand_A(rs1),
  .operand_B(ALU_mux),
  .ALU_result(ALU_result)
);


endmodule
