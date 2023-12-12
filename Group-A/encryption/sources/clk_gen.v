`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California Polytechnic State University Pomona
// Engineer: Shawn Keelin
// 
// Create Date: 10/02/2023 08:20:11 PM
// Design Name: Clock Generator
// Module Name: clk_gen
// Project Name: clk_gen Project
// Target Devices: Digilent Nexys-A7-100T
// Tool Versions: Xilinx Vivado 2018.3
// Description: Generates a clock signal to be used in other projects.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////



module clk_gen #(parameter SIZE = 32)(
    input fsys,
    input clk_gen_rst,
    input [$clog2(SIZE)-1:0] clk_gen_speed_control,
    //output clk_gen_locked,
    output clk_gen_out,
    output clk_gen_out_ssd
    );

   /*clk_wiz_0 instance_name
   (
        // Clock out ports
        .clkdiv(clk_gen_out),     // output clkdiv
        // Status and control signals
        .reset(clk_gen_rst), // input reset
        .locked(clk_gen_locked),       // output locked
       // Clock in ports
        .sysclk(fsys)
    ); */     // input sysclk
    
    reg[SIZE-1:0] clk_gen_temp;
    
    always@(posedge fsys)
        begin: CLK_GEN
            if(clk_gen_rst)
                clk_gen_temp <= 0;
            else
                clk_gen_temp <= clk_gen_temp + 1;
        end
    assign clk_gen_out = clk_gen_temp[clk_gen_speed_control];
    assign clk_gen_out_ssd = clk_gen_temp[16];

    
endmodule
