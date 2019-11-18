// Joshua Bone, Jonathan Hall
// BU ID: U22742355, U21798292
// EC413 Lab 2 Problem 2: ALU

module ALU (
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  input branch_op,
  output ALU_branch,
  output [31:0] ALU_result
);

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
reg [31:0] result;
reg branch;

assign ALU_result = result;
assign ALU_branch = branch;

always @(*)
    if(branch_op) begin
        casez(ALU_Control) //double check that this is correct functionality
            6'b010100 : branch = $signed(operand_A) < $signed(operand_B);   //BLT
            6'b010101 : branch = $signed(operand_A) >= $signed(operand_B);  //BGE
            6'b010110 : branch = operand_A < operand_B;                     //BLTU
            6'b010111 : branch = operand_A >= operand_B;                    //BGEU        
            6'b010000 : branch = operand_A == operand_B;                    //BEQ  
            6'b010001 : branch = operand_A != operand_B;                    //BNE
            
            default: result = 32'hFFFFFFFF;                 //de facto error code
        endcase
    end else begin
        casez (ALU_Control) //treats z as "don't care"
            6'b000000 : result = operand_A + operand_B;     //ADD
            6'b001000 : result = operand_A - operand_B;     //SUB
            
            6'bz11111 : result = operand_A;                 //JAL/JALR, both pass operand_A
            
            6'b000010 : result = $signed(operand_A) < $signed(operand_B);   //SLT, SLTI
            6'b000011 : result = operand_A < operand_B;                     //SLTIU, SLTU
            
            6'b000100 : result = operand_A ^ operand_B;     //XOR, XORI
            6'b000110 : result = operand_A | operand_B;     //ORI
            6'b000111 : result = operand_A & operand_B;     //AND,ANDI
            6'b000001 : result = operand_A << operand_B;    //SLLI, logical shift left Immediate
            6'b000101 : result = operand_A >> operand_B;    //SRLI, Logical shift right immediate
            6'b001101 : result = operand_A >>> operand_B;   //SRAI, Arithmetic shift right immediate
            
            default: result = 32'hFFFFFFFF;                 //de facto error code
        endcase
    end

endmodule
