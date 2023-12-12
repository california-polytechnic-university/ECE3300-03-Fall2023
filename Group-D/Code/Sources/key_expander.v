`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/03/2023 05:08:56 PM
// Design Name: Key Expander
// Module Name: key_expander
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Key expander for AES-128
// 
// Dependencies: sbox
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module key_expander (
        input [127:0] key_expander_key,
        output [1407:0] key_expander_output
    );
    
    wire [31:0] key_expander_output_temp [43:0];
    
    reg [31:0] key_expander_rcon [0:9];
    initial begin
        key_expander_rcon[0] = 32'h01000000;
        key_expander_rcon[1] = 32'h02000000;
        key_expander_rcon[2] = 32'h04000000;
        key_expander_rcon[3] = 32'h08000000;
        key_expander_rcon[4] = 32'h10000000;
        key_expander_rcon[5] = 32'h20000000;
        key_expander_rcon[6] = 32'h40000000;
        key_expander_rcon[7] = 32'h80000000;
        key_expander_rcon[8] = 32'h1b000000;
        key_expander_rcon[9] = 32'h36000000;
    end
    
    assign key_expander_output_temp[3] = key_expander_key[31:0];
    assign key_expander_output_temp[2] = key_expander_key[63:32];
    assign key_expander_output_temp[1] = key_expander_key[95:64];
    assign key_expander_output_temp[0] = key_expander_key[127:96];
    
    genvar i;
    generate 
    for(i=4;i<44;i=i+1) 
    begin
    
        if (i%4 == 0)
        begin
            
            wire [31:0] key_expander_rotated_left;
            assign key_expander_rotated_left = {key_expander_output_temp[i-1][23:16], key_expander_output_temp[i-1][15:8], key_expander_output_temp[i-1][7:0], key_expander_output_temp[i-1][31:24]};
            
            wire [31:0] key_expander_sub;
            sbox #(.ELEMENTS(4)) SBOX(
                .sbox_input(key_expander_rotated_left),
                .sbox_output(key_expander_sub)
            );
        
            assign key_expander_output_temp[i] = (key_expander_sub ^ key_expander_rcon[(i/4)-1]) ^ key_expander_output_temp[i-4];
        end 
        else begin
            assign key_expander_output_temp[i] = key_expander_output_temp[i-1] ^ key_expander_output_temp[i-4];
        end
        
        assign key_expander_output[i*32 +: 32] = key_expander_output_temp[i];
        
    end
    endgenerate
    
    assign key_expander_output[31:0] = key_expander_output_temp[0];
    assign key_expander_output[63:32] = key_expander_output_temp[1];
    assign key_expander_output[95:64] = key_expander_output_temp[2];
    assign key_expander_output[127:96] = key_expander_output_temp[3];
    
endmodule
