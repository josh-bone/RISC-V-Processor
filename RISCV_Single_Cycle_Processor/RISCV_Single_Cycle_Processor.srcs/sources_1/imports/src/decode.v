// Name: Josh Bone, Jonathan Hall
// BU ID: U, U21798292
// EC413 Project: Decode Module

module decode #(
  parameter ADDRESS_BITS = 16  //parameters are constants, thus you cant change their value at runtime <- note 
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC, //curent PC value
  input [31:0] instruction,   //the the 32 bit instruction we are decoding ig

  // Inputs from Execute/ALU    
  input [ADDRESS_BITS-1:0] JALR_target,  //target of JALR instruction 
  input branch,     //Result of a branch instruction, 1 means branch taken (true), 0 means not taken (false)

  // Outputs to Fetch
  output next_PC_select, //select (equivalent to PCsrc mux) 0 is PC+4, 1 is target_PC 
  output [ADDRESS_BITS-1:0] target_PC,   //selected if above is 1

  // Outputs to Reg File  - these are all inputs to Reg File
  output [4:0] read_sel1,  //read Address 1
  output [4:0] read_sel2,  //read address 2
  output [4:0] write_sel,  //write Addr
  output wEn,    //write enable

  // Outputs to Execute/ALU   - 
  output branch_op, // Tells ALU if this is a branch instruction -- I THINK
  output [31:0] imm32,  //the immediate
  output [1:0] op_A_sel,  //A select for the A entry into ALU ??
  output op_B_sel,  //B select for B entry itno ALU (0 for from read Data 2, 1 for Imm32)
  output [5:0] ALU_Control, //tells ALU operation

  // Outputs to Memory
  output mem_wEn, //write to memory

  // Outputs to Writeback
  output wb_sel //read from memory

);

localparam [6:0]R_TYPE  = 7'b0110011, //wEn  //data2
                I_TYPE  = 7'b0010011, //wEn  //imm32
                STORE   = 7'b0100011, //NO   //imm32  //memWrite
                LOAD    = 7'b0000011, //wEn  //imm32
                BRANCH  = 7'b1100011, //NO   //data2
                JALR    = 7'b1100111, //wEn  //imm32
                JAL     = 7'b1101111,  //wEn 
                AUIPC   = 7'b0010111, //wEn
                LUI     = 7'b0110111; //wEn


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.
wire[6:0]  s_imm_msb;
wire[4:0]  s_imm_lsb;
wire[19:0] u_imm;
wire[11:0] i_imm_orig;
wire[19:0] uj_imm;
wire[11:0] s_imm_orig;
wire[12:0] sb_imm_orig;

wire[31:0] sb_imm_32;
wire[31:0] u_imm_32;
wire[31:0] i_imm_32;
wire[31:0] s_imm_32;
wire[31:0] uj_imm_32;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target;
wire [ADDRESS_BITS-1:0] JAL_target;


// Read registers
assign read_sel2  = instruction[24:20];
assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
//first assigning values that are input regardless of instruction type

reg regWrite;
assign wEn = regWrite;
reg ALU_B;
assign op_B_sel = ALU_B;
reg [1:0] ALU_A;
assign op_A_sel = ALU_B;
//first my thinking is that we check what type of instruction it is:


always @(*) 
begin
//Write enable case
    casez(opcode)
        7'b??000?? : regWrite <= 0;  //dont reg write
        default: regWrite <= 1;
    endcase
    
    casez(opcode)
        R_TYPE: begin
                    regWrite <= 1;
                    ALU_B <= 0; //read in from Reg data 2
                    ALU_A <= 0; //read in from Reg data 1
                    
end



endmodule
