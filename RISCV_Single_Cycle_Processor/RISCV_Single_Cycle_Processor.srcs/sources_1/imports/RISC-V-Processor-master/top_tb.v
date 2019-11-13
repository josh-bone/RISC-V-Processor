// Name: Joshua Bone
// BU ID: U22742355
// EC413 Lab 2 Problem 3: Top Level Module Test Bench


// Note that the instruction binaries can be generated with the RISC-V
// Simulator.

module top_tb();

reg clock, reset, op_B_sel, wEn;
reg [5:0] ctrl;
reg [31:0] instruction;

wire [31:0] result;

integer x;

top dut (
  .clock(clock),
  .reset(reset),
  .instruction(instruction),
  .ALU_Control(ctrl),
  .op_B_sel(op_B_sel),
  .wEn(wEn),
  .ALU_result(result)
);

always #5 clock = ~clock;

initial begin
  clock = 1'b1;
  reset = 1'b1;
  op_B_sel = 1'b0;
  ctrl = 6'b000000;
  instruction = 32'h00000000;
  wEn = 1'b0;
  #10
  reset = 1'b0;
  #20
  wEn = 1'b1;
  instruction = 32'b000000000001_00000_000_01011_0010011; // addi a1, zero, 1
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  #10
  #10
  instruction = 32'b000000000010_00000_000_01100_0010011; // addi a2, zero, 2
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  #10
  #10
  instruction = 32'b000000000101_00000_000_01101_0010011; // addi a3, zero, 5
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  #10
  #10
  instruction = 32'b000000000110_00000_000_01110_0010011; // addi a4, zero, 6
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  #10
  #10
  instruction = 32'b111111111111_00000_000_01111_0010011; // addi a5, zero, -1
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end
  #10

  #10
  instruction = 32'b0000000_01100_01011_000_10000_0110011; // add a6, a1, a2
  ctrl = 6'b000000;
  op_B_sel = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

#10
  #10
  instruction = 32'b0100000_01110_01100_000_10001_0110011; // sub a7, a2, a4
  ctrl = 6'b001000;
  op_B_sel = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

#10
  #10
  instruction = 32'b0000000_01111_01011_010_01010_0110011; // slt a0, a1, a5
  ctrl = 6'b000010;
  op_B_sel = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

#10
  #10
  instruction = 32'b0000000_01111_01011_100_01110_0110011; // xor a4, a1, a5
  ctrl = 6'b000100;
  op_B_sel = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

#10
  #10
  instruction = 32'b0000000_01011_01101_111_01101_0110011; // and a3, a3, a1
  ctrl = 6'b000111;
  op_B_sel = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

#10
  #10
  wEn = 1'b0;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end

  /******************************
  * Test more instructions here *
  ******************************/
  
    #10
instruction = 32'b000000000001_00000_000_01110_0010011; // addi a4, zero, 1
ctrl = 6'b000000;
op_B_sel = 1'b1;
$display("Time %d", $time);
for( x=0; x<32; x=x+1) begin
  $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
end
#10
  
    #10
  instruction = 32'b000000000001_00000_000_01110_0010011; // addi a4, zero, 1
  ctrl = 6'b000000;
  op_B_sel = 1'b1;
  $display("Time %d", $time);
  for( x=0; x<32; x=x+1) begin
    $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
  end
  #10
  
    #10
instruction = 32'b000000000001_00000_000_01110_0010011; // addi a4, zero, 1
ctrl = 6'b000000;
op_B_sel = 1'b1;
$display("Time %d", $time);
for( x=0; x<32; x=x+1) begin
  $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
end
#10
  
    #10
instruction = 32'b000000000001_00000_000_01110_0010011; // addi a4, zero, 1
ctrl = 6'b000000;
op_B_sel = 1'b1;
$display("Time %d", $time);
for( x=0; x<32; x=x+1) begin
$display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
end
#10

  #10
  $stop();
end

endmodule




