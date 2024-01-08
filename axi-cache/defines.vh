
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
// load store
`define OP_LB       6'b100000
`define OP_LBU      6'b100100
`define OP_LH       6'b100001
`define OP_LHU      6'b100101
`define OP_LW       6'b100011
`define OP_SB       6'b101000
`define OP_SH       6'b101001
`define OP_SW       6'b101011
// other
`define OP_SYSCALL  6'b000000
`define FUNCT_SYSCALL 6'b001100
`define OP_BREAK    6'b000000
`define FUNCT_BREAK 6'b001101
`define INSTR_ERET  32'b01000010_00000000_00000000_00011000
`define SPECIAL3_INST 6'b010000
`define RS_MTC0     5'b00100
`define RS_MFC0     5'b00000


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
`define ALU_MTC0    8'b0001_0011
`define ALU_ADDU    8'b0001_0100
`define ALU_SUBU    8'b0001_0101
`define ALU_DEFAULT 8'b0001_0110

// global macro definition
`define RstEnable 		1'b1
`define RstDisable		1'b0
`define ZeroWord		32'h00000000
`define WriteEnable		1'b1
`define WriteDisable	1'b0
`define ReadEnable		1'b1
`define ReadDisable		1'b0
`define AluOpBus		7:0
`define AluSelBus		2:0
`define InstValid		1'b0
`define InstInvalid		1'b1
`define Stop 			1'b1
`define NoStop 			1'b0
`define InDelaySlot 	1'b1
`define NotInDelaySlot 	1'b0
`define Branch 			1'b1
`define NotBranch 		1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 		1'b1
`define TrapNotAssert 	1'b0
`define True_v			1'b1
`define False_v			1'b0
`define ChipEnable		1'b1
`define ChipDisable		1'b0
`define AHB_IDLE 2'b00
`define AHB_BUSY 2'b01
`define AHB_WAIT_FOR_STALL 2'b11

//specific inst macro definition

`define NOP			6'b000000
`define AND 		6'b100100
`define OR 			6'b100101
`define XOR 		6'b100110
`define NOR			6'b100111
`define ANDI		6'b001100
`define ORI			6'b001101
`define XORI		6'b001110
`define LUI			6'b001111

`define SLL			6'b000000
`define SLLV		6'b000100
`define SRL 		6'b000010
`define SRLV 		6'b000110
`define SRA 		6'b000011
`define SRAV 		6'b000111

`define MFHI  		6'b010000
`define MTHI  		6'b010001  
`define MFLO  		6'b010010
`define MTLO  		6'b010011

`define SLT  6'b101010
`define SLTU  6'b101011
`define SLTI  6'b001010
`define SLTIU  6'b001011   
`define ADD  6'b100000
`define ADDU  6'b100001
`define SUB  6'b100010
`define SUBU  6'b100011
`define ADDI  6'b001000
`define ADDIU  6'b001001

`define MULT  6'b011000
`define MULTU  6'b011001
`define DIV  6'b011010
`define DIVU  6'b011011

`define J  6'b000010
`define JAL  6'b000011
`define JALR  6'b001001
`define JR  6'b001000
`define BEQ  6'b000100
`define BGEZ  5'b00001
`define BGEZAL  5'b10001
`define BGTZ  6'b000111
`define BLEZ  6'b000110
`define BLTZ  5'b00000
`define BLTZAL  5'b10000
`define BNE  6'b000101

`define LB  6'b100000
`define LBU  6'b100100
`define LH  6'b100001
`define LHU  6'b100101
`define LW  6'b100011
`define SB  6'b101000
`define SH  6'b101001
`define SW  6'b101011

`define SYSCALL 6'b001100
`define BREAK 6'b001101

`define ERET 5'b10000

`define R_TYPE 6'b000000
`define REGIMM_INST 6'b000001
`define MTC0 5'b00100
`define MFC0 5'b00000

// ALU OP 4bit

`define ANDI_OP 4'b0000
`define XORI_OP 4'b0001
`define ORI_OP  4'b0010
`define LUI_OP  4'b0011
`define ADDI_OP 4'b0100
`define ADDIU_OP    4'b0101
`define SLTI_OP     4'b0110
`define SLTIU_OP    4'b0111

`define MEM_OP  4'b0100
`define R_TYPE_OP 4'b1000
`define MFC0_OP 4'b1001
`define MTC0_OP 4'b1010
`define USELESS_OP 4'b1111

// ALU CONTROL 5bit
`define AND_CONTROL 5'b00111
`define OR_CONTROL  5'b00001
`define XOR_CONTROL 5'b00010
`define NOR_CONTROL 5'b00011
`define LUI_CONTROL 5'b00100

`define SLL_CONTROL 5'b01000
`define SRL_CONTROL 5'b01001
`define SRA_CONTROL 5'b01010
`define SLLV_CONTROL    5'b01011
`define SRLV_CONTROL    5'b01100
`define SRAV_CONTROL    5'b01101

`define ADD_CONTROL     5'b10000
`define ADDU_CONTROL    5'b10001
`define SUB_CONTROL     5'b10010
`define SUBU_CONTROL    5'b10011
`define SLT_CONTROL     5'b10100
`define SLTU_CONTROL    5'b10101

`define MULT_CONTROL    5'b11000
`define MULTU_CONTROL   5'b11001
`define DIV_CONTROL     5'b11010
`define DIVU_CONTROL    5'b11011

`define MFHI_CONTROL  	5'b11100
`define MTHI_CONTROL  	5'b11101
`define MFLO_CONTROL  	5'b11110
`define MTLO_CONTROL  	5'b11111

`define MFC0_CONTROL 	5'b00101
`define MTC0_CONTROL 	5'b00110

//inst ROM macro definition
`define InstAddrBus		31:0
`define InstBus 		31:0

//data RAM
`define DataAddrBus 31:0
`define DataBus 31:0
`define ByteWidth 7:0

//regfiles macro definition

`define RegAddrBus		4:0
`define RegBus 			31:0
`define RegWidth		32
`define DoubleRegWidth	64
`define DoubleRegBus	63:0
`define RegNum			32
`define RegNumLog2		5
`define NOPRegAddr		5'b00000

//div
`define DivFree 2'b00
`define DivByZero 2'b01
`define DivOn 2'b10
`define DivEnd 2'b11
`define DivResultReady 1'b1
`define DivResultNotReady 1'b0
`define DivStart 1'b1
`define DivStop 1'b0

//CP0
`define CP0_REG_BADVADDR    5'b01000       
`define CP0_REG_COUNT    5'b01001        
`define CP0_REG_COMPARE    5'b01011      
`define CP0_REG_STATUS    5'b01100       
`define CP0_REG_CAUSE    5'b01101       
`define CP0_REG_EPC    5'b01110          
`define CP0_REG_PRID    5'b01111         
`define CP0_REG_CONFIG    5'b10000       