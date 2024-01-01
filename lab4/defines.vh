
//=============================OPCODE FUNCT
`define OP_R_TYPE   6'b000000
`define FUNCT_AND   6'b100100
`define OP_ANDI     6'b001100
`define FUNCT_OR    6'b100101
`define OP_ORI      6'b001101
`define FUNCT_XOR   6'b100110
`define OP_XORI     6'b001110
`define FUNCT_NOR   6'b100111
`define OP_LUI      6'b001111
// logical
`define FUNCT_SLL   6'b000000
`define FUNCT_SRL   6'b000010
`define FUNCT_SRA   6'b000011
`define FUNCT_SLLV  6'b000100
`define FUNCT_SRLV  6'b000110
`define FUNCT_SRAV  6'b000111
// move from or move to
`define FUNCT_MFHI  6'b010000
`define FUNCT_MFLO  6'b010010
`define FUNCT_MTHI  6'b010001
`define FUNCT_MTLO  6'b010011
// arithmetic
`define FUNCT_ADD   6'b100000
`define FUNCT_ADDU  6'b100001
`define OP_ADDI     6'b001000
`define OP_ADDIU    6'b001001
`define FUNCT_SUB   6'b100010
`define FUNCT_SUBU  6'b100011
`define FUNCT_SLT   6'b101010
`define FUNCT_SLTU  6'b101011
`define OP_SLTI     6'b001010
`define OP_SLTIU    6'b001011
`define FUNCT_DIV   6'b011010
`define FUNCT_DIVU  6'b011011
`define FUNCT_MULT  6'b011000
`define FUNCT_MULTU 6'b011001
// branch jump
`define OP_BEQ      6'b000100
`define OP_BNE      6'b000101
`define OP_BGEZ     6'b000001
`define OP_BGTZ     6'b000111
`define OP_BLEZ     6'b000110
`define OP_BLTZ     6'b000001
`define OP_BLTZAL   6'b000001
`define OP_BGEZAL   6'b000001
`define OP_J        6'b000010
`define OP_JAL      6'b000011
`define FUNCT_JR    6'b001000
`define FUNCT_JALR  6'b001001
`define RT_BGEZ     5'b00001
`define RT_BLTZ     5'b00000
`define RT_BLTZAL   5'b10000
`define RT_BGEZAL   5'b10001


//===========================ALU_OPTION
`define ALU_ADD     8'b0000_0000
`define ALU_SUB     8'b0000_0001
`define ALU_DIV     8'b0000_0010
`define ALU_DIVU    8'b0000_0011
`define ALU_MULT    8'b0000_0100
`define ALU_MULTU   8'b0000_0101
`define ALU_OR      8'b0000_0110
`define ALU_AND     8'b0000_0111
`define ALU_XOR     8'b0000_1000
`define ALU_NOR     8'b0000_1001
`define ALU_SLT     8'b0000_1010
`define ALU_SLTU    8'b0000_1011
`define ALU_LUI     8'b0000_1100
`define ALU_SLL     8'b0000_1101
`define ALU_SRL     8'b0000_1110
`define ALU_SRA     8'b0000_1111
`define ALU_SLLV    8'b0001_0000
`define ALU_SRLV    8'b0001_0001
`define ALU_SRAV    8'b0001_0010
`define ALU_DEFAULT 8'b0001_0011

//============================div
`define DivFree             2'b00
`define DivByZero 			2'b01
`define DivOn 				2'b10
`define DivEnd 				2'b11
`define DivResultReady 		1'b1
`define DivResultNotReady 	1'b0
`define DivStart 			1'b1
`define DivStop 			1'b0
`define ZeroWord            32'b0
