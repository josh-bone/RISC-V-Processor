// Name: Joshua Bone, Jonathan Hall
// BU ID: U22742355,U21798292
// EC413 Project: Ram Test Bench

module ram_tb();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;

reg  clock;

// Instruction Port
reg  [ADDR_WIDTH-1:0] i_address;
wire [DATA_WIDTH-1:0] i_read_data;

// Data Port
reg  wEn;
reg  [ADDR_WIDTH-1:0] d_address;
reg  [DATA_WIDTH-1:0] d_write_data;
wire [DATA_WIDTH-1:0] d_read_data;

integer x;

ram #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH)
) uut (
  .clock(clock),

  // Instruction Port
  .i_address(i_address),
  .i_read_data(i_read_data),

  // Data Port
  .wEn(wEn),
  .d_address(d_address),
  .d_write_data(d_write_data),
  .d_read_data(d_read_data)

);

always #5 clock = ~clock;


initial begin
  clock = 1'b1;
  d_address = 16'd0;
  d_write_data = 16'd0;
  wEn = 1'b0;

  #10
  wEn = 1'b1;
  #10
  $display("Data Address %d: %h", d_address, d_read_data); //Data Address     0: 00000000
  d_write_data = 1;
  d_address = 4;
  #10
  $display("Data Address %d: %h", d_address, d_read_data); //Data Address     4: 00000001
  d_write_data = 2;
  d_address = 8;
  #10
  $display("Data Address %d: %h", d_address, d_read_data); //Data Address     8: 00000002


  /***************************
  * Add more test cases here *
  ***************************/
  $readmemh("./fibonacci.vmh", uut.ram); // Should put 0x00000015 in register x9
  //$readmemh("./gcd.vmh", uut.ram); // Should put 0x00000010 in register x9
  
  #300
  i_address = 0;
  $display("Instruction Address %d: %h", i_address, i_read_data);
  
  i_address = 1;
  #10
  $display("Instruction Address %d: %h", i_address, i_read_data);
  
    i_address = 2;
    #10
    $display("Instruction Address %d: %h", i_address, i_read_data);
  
     i_address = 3;
     #10
     $display("Instruction Address %d: %h", i_address, i_read_data);
      
     i_address = 4;
     #10
     $display("Instruction Address %d: %h", i_address, i_read_data);

     i_address = 5;
     #10
     $display("Instruction Address %d: %h", i_address, i_read_data);
          
     i_address = 6;
     #10
     $display("Instruction Address %d: %h", i_address, i_read_data);
      
      
  #100
  $stop();

end

endmodule
