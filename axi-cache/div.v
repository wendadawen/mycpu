// `timescale 1ns / 1ps

// `include "defines.vh"

// module div(clk,rst,Signed,A,B,Start,annul_i,Result,Ready);
//     input clk,rst;
//     input Signed;
//     input [31:0] A;
//     input [31:0] B;
//     input Start;
//     input annul_i;
//     output reg [63:0] Result;
//     output reg Ready;

//     parameter MAX_ITERATION = 3'd6;// 迭代次数的下界,共计5(商)+1(余数)个周期,可以保证32位整数以浮点形式参与运算过程中的精度要求

//     wire [31:0] divA,divB;
//     reg Divon;
//     reg [2:0] Count;
//     reg [63:0] regA,regB;
//     wire [31:0] mantissA,mantissB;
//     wire [31:0] normQ;
//     wire [63:0] tmpQ;
//     wire [4:0] clzA,clzB;
//     wire [63:0] TwoMinusYi;
//     wire [127:0] Xi,Yi;
//     reg regSigned;// 保留除法开始时的输入信号,避免其在运算过程中发生变化(主要是被除数A和除数B,Signed实际上不会发生变化(因为Signed不存在由数据前推得到的情况))
//     reg [4:0] OffsetA,OffsetB;
//     reg [31:0] Dividend;
//     reg [31:0] Divisor;
//     wire [31:0] mulD,mulQ,tmp;
//     wire [31:0] Quotient;
//     wire [31:0] Remainder;

//     assign divA = (Signed && A[31] == 1'b1 )? ~A + 1'b1 : A;
//     assign divB = (Signed && B[31] == 1'b1 )? ~B + 1'b1 : B; 
//     CLZ CLZA(divA,clzA);
//     CLZ CLZB(divB,clzB);
//     assign mantissA = divA << clzA;
//     assign mantissB = divB << clzB;
//     assign TwoMinusYi = ~regB + 1'b1;
//     assign Xi = regA * TwoMinusYi;
//     assign Yi = regB * TwoMinusYi;

//     always@(posedge clk or posedge rst)
//     begin
//         if(rst)
//             Ready <= 1'b0;
//         else if(Start)
//             begin
//                 if(Divon)
//                 begin
//                     if(Count == MAX_ITERATION)
//                     begin
//                         Result <= {Remainder,Quotient};
//                         Ready <= 1'b1;
//                         Divon <= 1'b0;
//                     end
//                     else if(Count == MAX_ITERATION - 1)//最后一个周期不迭代,用以计算余数
//                         Count <= Count + 1'b1;
//                     else begin
//                         regA <= Xi[126:63];
//                         regB <= Yi[126:63];
//                         Count <= Count + 1'b1;
//                     end
//                 end
//                 else begin
//                     Divon <= 1'b1;
//                     regSigned <= Signed;
//                     OffsetA <= clzA;
//                     OffsetB <= clzB;
//                     Dividend <= A;
//                     Divisor <= B;
//                     regA <= {1'b0,mantissA,31'b0};
//                     regB <= {1'b0,mantissB,31'b0};
//                     Count <= 3'b0;
//                     Ready <= 1'b0;
//                 end
//             end
//         else Ready <= 1'b0;
//     end

//     assign normQ = regA[63:32] + |regA[31:29];//四舍五入
//     assign tmpQ = (OffsetA > OffsetB)? normQ >> (OffsetA - OffsetB) : normQ << (OffsetB - OffsetA);//转回整数
//     assign Quotient = (regSigned && (Dividend[31] ^ Divisor[31]))? ~tmpQ[62:31] + 1'b1 : tmpQ[62:31];
//     assign mulD = Divisor[31]? ~Divisor + 1'b1 : Divisor;//最后一个周期所进行的运算
//     assign mulQ = Quotient[31]? ~Quotient + 1'b1 : Quotient;
//     assign tmp = mulD * mulQ;
//     assign Remainder = Dividend + ((Divisor[31] ^ Quotient[31])? tmp : ~tmp + 1'b1);

// endmodule


`timescale 1ns / 1ps

`include "defines.vh"

module div(
	input wire					clk,
	input wire					rst,
	input wire                  signed_div_i,
	input wire[31:0]            opdata1_i,
	input wire[31:0]		   	opdata2_i,
	input wire                  start_i,
	input wire                  annul_i,
	output reg[63:0]            result_o,
	output reg			        ready_o	
);

	wire[32:0] div_temp;
	reg[5:0] cnt;
	reg[64:0] dividend;	
	reg[1:0] state;	
	reg[31:0] divisor;
	reg[31:0] temp_op1;
	reg[31:0] temp_op2;
	reg[31:0] reg_op1;
	reg[31:0] reg_op2;
	
	assign div_temp = {1'b0,dividend[63:32]} - {1'b0,divisor};

	always @ (posedge clk) begin
		if (rst) begin
			state <= `DivFree;
			ready_o <= `DivResultNotReady;
			result_o <= {`ZeroWord,`ZeroWord};
		end else begin
            case (state)
                `DivFree: begin
                    if(start_i == `DivStart && annul_i == 1'b0) begin
                        if(opdata2_i == `ZeroWord) begin
                            state <= `DivByZero;
                        end else begin
                            state <= `DivOn;
                            cnt <= 6'b000000;
                            if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1 ) begin
                                temp_op1 = ~opdata1_i + 1;
                            end else begin
                                temp_op1 = opdata1_i;
                            end
                            if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1 ) begin
                                temp_op2 = ~opdata2_i + 1;
                            end else begin
                                temp_op2 = opdata2_i;
                            end
                            dividend <= {`ZeroWord,`ZeroWord};
                        dividend[32:1] <= temp_op1;
                        divisor <= temp_op2;
                        reg_op1 <= opdata1_i;
                        reg_op2 <= opdata2_i;
                        end
                    end else begin
                        ready_o <= `DivResultNotReady;
                        result_o <= {`ZeroWord,`ZeroWord};
                    end          	
                end
                `DivByZero:	begin
                    dividend <= {`ZeroWord,`ZeroWord};
                    state <= `DivEnd;		 		
                end
                `DivOn:	begin
                    if(annul_i == 1'b0) begin
                        if(cnt != 6'b100000) begin
                            if(div_temp[32] == 1'b1) begin
                                dividend <= {dividend[63:0] , 1'b0};
                            end else begin
                                dividend <= {div_temp[31:0] , dividend[31:0] , 1'b1};
                            end
                            cnt <= cnt + 1;
                        end else begin
                            if((signed_div_i == 1'b1) && ((reg_op1[31] ^ reg_op2[31]) == 1'b1)) begin
                                dividend[31:0] <= (~dividend[31:0] + 1);
                            end
                            if((signed_div_i == 1'b1) && ((reg_op1[31] ^ dividend[64]) == 1'b1)) begin              
                                dividend[64:33] <= (~dividend[64:33] + 1);
                            end
                            state <= `DivEnd;
                            cnt <= 6'b000000;
                        end
                    end else begin
                        state <= `DivFree;
                    end	
                end
                `DivEnd:	begin
                    result_o <= {dividend[64:33], dividend[31:0]};  
                    ready_o <= `DivResultReady;
                    if(start_i == `DivStop) begin
                        state <= `DivFree;
                        ready_o <= `DivResultNotReady;
                        result_o <= {`ZeroWord,`ZeroWord};       	
                    end		  	
                end
            endcase
		end
	end

endmodule
