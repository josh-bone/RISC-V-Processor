// Name: Joshua Bone , Jonathan Hall
// BU ID: U22742355, U21798292
// EC413 Lab 2 Problem 2: ALU Test Bench

module ALU_tb();

reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;

ALU dut (
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result)
);

initial begin
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #10
  $display("ALU Result 4 + 5: %d",result);
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU Result 4 < 5: %d",result);
  #10
  opB = 32'hffffffff;
  #10
  $display("ALU Result 4 < -1: %d",result);

  // Add other test cases here
  opA = 32'd2;
  opB = 32'hffffffff;
  #10
  ctrl = 6'b000000;
  #10
  $display("ALU Result 2 + -1: %d", result);
  #10
  ctrl = 6'b001000;
  #10
  $display("ALU Result 2 - (-1) %d", result);
  
  
end

endmodule
