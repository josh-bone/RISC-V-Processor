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
reg WBSEL;
assign wb_sel = WBSEL;
reg memWrite;
assign mem_wEn = memWrite;
reg Branch_reg;
assign branch_op = Branch_reg;
reg BranchTrue;
assign branch = BranchTrue;
reg [1:0] ALU_A;
assign op_A_sel = ALU_B;
reg [5:0] ALU_C;
assign ALU_Control = ALU_C;
//first my thinking is that we check what type of instruction it is:


always @(*) 
begin

    case(opcode)
         R_TYPE: begin
                    Branch_reg <= 0;
                    regWrite <= 1;
                    ALU_B <= 0; //read in from Reg data 2
                    ALU_A <= 2'b00; //read in from Reg data 1
                    WBSEL <= 0; //write back data from ALU
                    memWrite <= 0;
                    
                 end
         I_TYPE: begin
                    regWrite <= 1;
                    Branch_reg = 0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b00; //read in from Reg data 1
                    WBSEL <= 0;
                    memWrite <= 0;                
                 end
         STORE: begin
                    regWrite <= 0;
                    Branch_reg <= 0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b00; //read in from Reg data 1
                    WBSEL <= WBSEL; //doesn't matter
                    memWrite <= 1; //write to memory
                end
         LOAD: begin
                    regWrite <= 1;
                    Branch_reg <= 0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b00; //read in from reg data 1
                    WBSEL <= 1; //write back data from MEMORY
                    memWrite <= 0; //not writing to memory
               end
         BRANCH: begin
                    regWrite <= 0;
                    Branch_reg <= 1;
                    ALU_B <= 0; //read in from reg data 2
                    ALU_A <= 2'b00; //read in from Reg Data 1
                    WBSEL <= WBSEL; //doesn't matter
                    memWrite <= 0; //not writing to memory
                 end
         JALR: begin
                    regWrite <= 1;
                    Branch_reg <= 0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b00; //read in from reg data 1
                    WBSEL <= 0; //WB data from ALU
                    memWrite <= 0; 
               end
         JAL: begin
                    regWrite <= 1;
                    Branch_reg <=0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b10; //read PC+4
                    WBSEL <= 0; //WB from ALU
                    memWrite <=0;
              end
         AUIPC: begin
                    regWrite <= 1;
                    Branch_reg <= 0;
                    ALU_B <= 1; //read in from Imm32
                    ALU_A <= 2'b01 ; //read PC
                    WBSEL <= 0; //WB from ALU
                    memWrite <= 0; 
                end
         LUI: begin
                    regWrite <= 1;
                    Branch_reg <= 0;
                    ALU_B <= 1; //read in from IMM32
                    ALU_A <= 2'b00; //NOTE this value should be 0!
                    WBSEL <= 0; //WB from ALU
                    memWrite <=0;
              end                   
     endcase
     //for alu control 6-bit input
     case(opcode)
         R_TYPE: begin
                    case(funct3)
                        3'b000: begin
                                  if(funct7 == 7'b0100000) 
                                  begin
                                        ALU_C = 6'b001000; //SUB c
                                  end
                                  else
                                  begin
                                        ALU_C = 6'b000000; //ADD c
                                  end
                                end
                        3'b111: ALU_C <= 6'b000111; //AND c
                        3'b110: ALU_C <= 6'b000110; //OR c
                        3'b101: ALU_C <= 6'b000101; //SRL
                        3'b100: ALU_C <= 6'b000100; //XOR
                        3'b011: ALU_C <= 6'b000010; //SLTU
                        3'b010: ALU_C <= 6'b000010; //SLT c
                    endcase
                end
         I_TYPE: begin
                  case(funct3)
                        3'b000: ALU_C <= 6'b000000; //ADDI
                        3'b111: ALU_C <= 6'b000111; //ANDI c
                        3'b110: ALU_C <= 6'b000110; //ORI c
                        3'b101: ALU_C <= 6'b000101; //SRLI
                        3'b100: ALU_C <= 6'b000100; //XORI
                        3'b011: ALU_C <= 6'b000010; //SLTUI
                        3'b010: ALU_C <= 6'b000010; //SLTI c
                   endcase
                 end
         BRANCH: begin
                  case(funct3)
                       3'b000: ALU_C <= 6'b010000; //BEQ
                       3'b001: ALU_C <= 6'b010001; //BNE
                       3'b100: ALU_C <= 6'b010100; //BLT
                       3'b101: ALU_C <= 6'b010101; //BGE
                       3'b110: ALU_C <= 6'b010110; //BLTU
                       3'b111: ALU_C <= 6'b010111; //BGEU
                   endcase
                 end
         LOAD: ALU_C <= 000000; //load is just an add
         STORE: ALU_C <= 000000; //store is just an add
         LUI: ALU_C <= 000000; //Load upper imm is just an add
         AUIPC: ALU_C <= 000000; //AUIPC is just an add
         JALR: ALU_C <= 111111; //pass data A through
         JAL: ALU_C <= 011111; //pass data A through
         
       endcase
         
         
           
                    
end



endmodule
