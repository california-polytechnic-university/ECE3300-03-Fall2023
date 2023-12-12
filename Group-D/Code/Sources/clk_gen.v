`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 10/02/2023 08:20:08 PM
// Design Name: CLK Gen
// Module Name: clk_gen
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Clock generator
// 
// Dependencies: N/A
// 
// Revision: 1.1
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_gen #(parameter SIZE = 32) 
        (
        input fsys,
        input clk_gen_rst,
        output [SIZE-1:0] clk_gen_out
         );
         
	reg [SIZE-1:0] clk_gen_tmp = 0;
	
	always@(posedge fsys)
      begin:CLK_GEN
		if(clk_gen_rst)
		   clk_gen_tmp <= 0;
		else
		   clk_gen_tmp <= clk_gen_tmp + 1;
      end
	      
    assign clk_gen_out = clk_gen_tmp;	     
        	
endmodule
