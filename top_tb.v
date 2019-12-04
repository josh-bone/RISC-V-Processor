// Name: Joshua Bone, Jonathan Hall
// BU ID: U22742355,U21798292
// EC413 Project: Top Level Module Test Bench

module top_tb();

reg clock;
reg reset;

wire [31:0] result;

integer x;

top dut (
  .clock(clock),
  .reset(reset),
  .wb_data(result)
);

always #5 clock = ~clock;

task print_state;
  begin
    $display("Time:\t%0d", $time);
    for( x=0; x<32; x=x+1) begin
      $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
    end
    $display("--------------------------------------------------------------------------------");
    $display("\n\n");
  end
endtask

initial begin
  clock = 1'b1;
  reset = 1'b1;

    print_state();

  // Make sure the .vmh file is in the same directory that you launched the
  // simulation from.
  //$readmemh("./fibonacci.vmh", dut.main_memory.ram); // Should put 0x00000015 in register x9
  $readmemh("./gcd.vmh", dut.main_memory.ram); // Should put 0x00000010 in register x9

  for( x=0; x<32; x=x+1) begin
    dut.regFile_inst.reg_file[x] = 32'd0;
  end

  #1
  #20
  reset = 1'b0; //PC now at 0, should begin executing instructions

  #60000
  print_state();
 
    #100
    $display("done!\n");
    
  $stop();

end

endmodule

