// Name: Joshua Bone
// BU ID: U22742355
// EC413 Lab 2 Problem 1: Register File Test Bench

module regFile_tb();

reg clock, reset;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

reg wEn;
reg [31:0] write_data;
reg [4:0] read_sel1;
reg [4:0] read_sel2;
reg [4:0] write_sel;
wire [31:0] read_data1;
wire [31:0] read_data2;

// Fill in port connections
regFile uut (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


always begin
    #5 clock = ~clock;
end


initial begin
  clock = 1'b1;
  reset = 1'b1;
  
  #20;
  reset = 1'b0;
  wEn = 1'b1;
  write_sel = 5'b1;
  read_sel1 = 5'b1; //read same value as write, get old value
  write_data = 1'b1;
  
  #20;
  write_sel = 5'b0;
  read_sel1 = 5'b0;
  read_sel2 = 5'b1;
  write_data = 32'd333;
 
  #1000
  $finish();
  
end

// Test reads and writes to the register file here
always begin
    #15
    write_data <= write_data + 1'b1;
    read_sel1 <= read_sel1 + 2'b10;
    read_sel2 <= read_sel2 + 2'b11;
end



endmodule
