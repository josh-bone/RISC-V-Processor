// Name: Joshua Bone, Jonathan Hall
// BU ID: U22742355,U21798292
// EC413 Project: Ram Module

module ram #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
) (
  input  clock,

  // Instruction Port
  input  [ADDR_WIDTH-1:0] i_address,
  output [DATA_WIDTH-1:0] i_read_data,

  // Data Port
  input  wEn,
  input  [ADDR_WIDTH-1:0] d_address,
  input  [DATA_WIDTH-1:0] d_write_data,
  output [DATA_WIDTH-1:0] d_read_data

);

localparam RAM_DEPTH = 1 << ADDR_WIDTH; // right shifts 1 by 16 places. Thus there are 2^16 addresses

reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

//combinational read instruction
assign i_read_data = ram[i_address];

assign d_read_data = ram[d_address];

//sequential write data
always @(posedge clock)
begin
    if(wEn)
    begin
        ram[d_address] <= d_write_data;
    end

end


endmodule
