// Name: Joshua Bone, Jonathan Hall
// BU ID: U  ,U21798292
// EC413 Project: Top Level Module

module top #(
  parameter ADDRESS_BITS = 16
) (
  input clock,
  input reset,

  output [31:0] wb_data
);


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// Fetch Wires

// Decode Wires


// Reg File Wires

// Execute Wires
wire [ADDRESS_BITS-1:0] JALR_target; // Assigned outside of ALU

// Memory Wires

// Writeback wires


fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) fetch_inst (
  .clock(),
  .reset(),
  .next_PC_select(),
  .target_PC(),
  .PC()
);


decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) decode_unit (

  // Inputs from Fetch
  .PC(),
  .instruction(),

  // Inputs from Execute/ALU
  .JALR_target(),
  .branch(),

  // Outputs to Fetch
  .next_PC_select(),
  .target_PC(),

  // Outputs to Reg File
  .read_sel1(),
  .read_sel2(),
  .write_sel(),
  .wEn(),

  // Outputs to Execute/ALU
  .branch_op(),
  .imm32(),
  .op_A_sel(),
  .op_B_sel(),
  .ALU_Control(),

  // Outputs to Memory
  .mem_wEn(),

  // Outputs to Writeback
  .wb_sel()

);


regFile regFile_inst (
  .clock(),
  .reset(),
  .wEn(), // Write Enable
  .write_data(),
  .read_sel1(),
  .read_sel2(),
  .write_sel(),
  .read_data1(),
  .read_data2()
);



ALU alu_inst(
  .branch_op(),
  .ALU_Control(),
  .operand_A(),
  .operand_B(),
  .ALU_result(),
  .branch()
);


ram #(
  .ADDR_WIDTH(ADDRESS_BITS)
) main_memory (
  .clock(),

  // Instruction Port
  .i_address(),
  .i_read_data(),

  // Data Port
  .wEn(),
  .d_address(),
  .d_write_data(),
  .d_read_data()
);

endmodule
