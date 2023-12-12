`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 10/04/2023 06:33:13 PM
// Design Name: Mux 2x1
// Module Name: mux2x1
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: 2x1 multiplexer
// 
// Dependencies: N/A
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2x1(
    input mux2x1_port_sel,
    input mux2x1_port_i0,
    input mux2x1_port_i1,
    output mux2x1_port_output
    );
    
    assign mux2x1_port_output = (mux2x1_port_i0 & !mux2x1_port_sel) | (mux2x1_port_i1 & mux2x1_port_sel);
    
endmodule