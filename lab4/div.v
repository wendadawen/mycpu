//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  div
// File:    div.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: ����ģ��
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.vh"

module div(
	input wire					clk,
	input wire					rst,
	input wire                  signed_div_i,	//是否是有符号除法
	input wire[31:0]            opdata1_i,		//被除数
	input wire[31:0]		   	opdata2_i,		//除数
	input wire                  start_i,		//是否开始除法运算
	input wire                  annul_i,		//是否取消除法运算
	output reg[63:0]            result_o,		//除法运算结果
	output reg			        ready_o			//是否结束， 1表示
);

	wire[32:0] div_temp;		//存储dividend[63:32]与除数的差,做有符号减法,最高位为符号位
	reg[5:0] cnt;				//试商法的迭代次数：0 -> 32， 一共33轮
	reg[64:0] dividend;			//{余数,商}
	reg[1:0] state;				
	reg[31:0] divisor;	 		//除数原码用来运算
	reg[31:0] temp_op1;			//被除数原码
	reg[31:0] temp_op2;			//除数原码
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
		  	/* --------------------除法模块空闲，可以执行除法-------------------- */
		  	`DivFree:	begin
				/* ---------------准备好除法运算，规范被除数、除数--------------- */
		  		if(start_i == `DivStart && annul_i == 1'b0) begin // 当准备开始除法运算且没有取消除法运算
		  			if(opdata2_i == `ZeroWord) begin    //除数为0
		  				state <= `DivByZero;
		  			end else begin
		  				state <= `DivOn;				//状态切换为除法运算进行中
		  				cnt <= 6'b000000;				//从0开始计数
		  				/* ----------被除数、除数补码还原原码---------- */
						if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1 ) begin	//被除数为负
		  					temp_op1 = ~opdata1_i + 1;	//补码还原原码
		  				end else begin
		  					temp_op1 = opdata1_i;		//正数原码=补码
		  				end
		  				if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1 ) begin	//除数为负
		  					temp_op2 = ~opdata2_i + 1;
		  				end else begin
		  					temp_op2 = opdata2_i;
		  				end
						/* ----------被除数、除数赋初值并执行第一次运算---------- */
		  				dividend <= {`ZeroWord,`ZeroWord};
						dividend[32:1] <= temp_op1; // 初始化的时候，商为被除数
						divisor <= temp_op2;
						reg_op1 <= opdata1_i;
						reg_op2 <= opdata2_i;
             		end
				/* ---------------还未准备好除法运算--------------- */
				end else begin
					ready_o <= `DivResultNotReady;
					result_o <= {`ZeroWord,`ZeroWord};
				end          	
		  	end
			/* --------------------上一步除数是0，此时取值并修改状态-------------------- */
		  	`DivByZero:	begin
				dividend <= {`ZeroWord,`ZeroWord};
				state <= `DivEnd;		 		
		  	end
			/* --------------------除法运算正在进行中-------------------- */
		  	`DivOn:	begin
				/* ---------------除法运算没被取消--------------- */
		  		if(annul_i == 1'b0) begin
					/* ----------除法运算还没完成---------- */
		  			if(cnt != 6'b100000) begin
						if(div_temp[32] == 1'b1) begin				//差值为负,不够除
							dividend <= {dividend[63:0] , 1'b0};	//被除数不变,左移补0
						end else begin								//差值为正,够除
							dividend <= {div_temp[31:0] , dividend[31:0] , 1'b1};	//被除数变为div_temp
						end
               			cnt <= cnt + 1;
					/* ----------除法运算完成---------- */
             		end else begin
						/* -----有符号除法且被除数与除数异号----- */
						if((signed_div_i == 1'b1) && ((reg_op1[31] ^ reg_op2[31]) == 1'b1)) begin
							dividend[31:0] <= (~dividend[31:0] + 1);
						end
						/* -----有符号除法且被除数与除数同号----- */
						if((signed_div_i == 1'b1) && ((reg_op1[31] ^ dividend[64]) == 1'b1)) begin              
							dividend[64:33] <= (~dividend[64:33] + 1);
						end
						state <= `DivEnd;
						cnt <= 6'b000000;
             		end
				/* ---------------取消除法运算--------------- */
		  		end else begin
		  			state <= `DivFree;
		  		end	
		  	end
			/* --------------------除法运算结束-------------------- */
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