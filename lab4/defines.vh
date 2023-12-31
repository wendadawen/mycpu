
//============OPTION
`define OP_R_TYPE  6'b000000
`define FUNCT_AND  6'b100100
`define OP_ANDI    6'b001100
`define FUNCT_OR   6'b100101
`define OP_ORI     6'b001101
`define FUNCT_XOR  6'b100110
`define OP_XORI    6'b001110
`define FUNCT_NOR  6'b100111
`define OP_LUI     6'b001111
// logical
`define FUNCT_SLL  6'b000000
`define FUNCT_SRL  6'b000010
`define FUNCT_SRA  6'b000011
`define FUNCT_SLLV 6'b000100
`define FUNCT_SRLV 6'b000110
`define FUNCT_SRAV 6'b000111
// move from or move to
`define FUNCT_MFHI 6'b010000
`define FUNCT_MFLO 6'b010010
`define FUNCT_MTHI 6'b010001
`define FUNCT_MTLO 6'b010011


//=============ALU_OPTION
`define ALU_ADD 8'b0000_0000
`define ALU_SUB 8'b0000_0001
`define ALU_DIV 8'b0000_0010
`define ALU_DIVU 8'b0000_0011
`define ALU_MULT 8'b0000_0100
`define ALU_MULTU 8'b0000_0101
`define ALU_OR 8'b0000_0110
`define ALU_AND 8'b0000_0111
`define ALU_XOR 8'b0000_1000
`define ALU_NOR 8'b0000_1001
`define ALU_SLT 8'b0000_1010
`define ALU_SLTU 8'b0000_1011
`define ALU_LUI 8'b0000_1100
`define ALU_SLL 8'b0000_1101
`define ALU_SRL 8'b0000_1110
`define ALU_SRA 8'b0000_1111
`define ALU_SLLV 8'b0001_0000
`define ALU_SRLV 8'b0001_0001
`define ALU_SRAV 8'b0001_0010
`define ALU_DEFAULT 8'b0001_0011

