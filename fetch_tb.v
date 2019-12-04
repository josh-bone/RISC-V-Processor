// Name: Joshua Bone, Jonathan Hall
// BU ID: U22742355,U21798292
// EC413 Project: Fetch Test Bench

module fetch_tb();

parameter ADDRESS_BITS = 16;

reg clock;
reg reset;
reg next_PC_select;
reg [ADDRESS_BITS-1:0] target_PC;
wire [ADDRESS_BITS-1:0] PC;

fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) uut (
  .clock(clock),
  .reset(reset),
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),
  .PC(PC)
);

always #5 clock = ~clock;


initial begin
  clock = 1'b1;
  reset = 1'b1;
  next_PC_select = 1'b1;
  target_PC = 16'h0000;

  #1
  #10
  reset = 1'b0;
  next_PC_select = 1'b0;
    
  target_PC = 16'hFF00;
  #10
  $display("PC: %h", PC);

  /***************************
  * Add more test cases here *
  ***************************/
   #100
    //wait 10 clock cycles - PC should be 0004 + 0028 = 002c
    $display("PC: %h", PC);
    #5
    next_PC_select = 1'b1;
    //we should jump to FF00 in next clock cycle
    #5
    $display("PC: %h", PC);
    next_PC_select = 1'b0;
    #20
    
    //wait 2 clock cycles - PC should be FF00 + 0008 = FF08
    $display("PC: %h", PC);
    
    
  #100
  $stop();

end

endmodule
