`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/05/2023 04:55:20 PM
// Design Name: Inverse Cipher Testbench
// Module Name: inverse_cipher_tb
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Testbench for inverse cipher
// 
// Dependencies: inverse_cipher
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module inverse_cipher_tb(
    );
    
    reg [127:0] inverse_cipher_key_tb;
    reg [127:0] inverse_cipher_input_tb;
    wire [127:0] inverse_cipher_output_tb;
    
    inverse_cipher INVERSE_CIPHER1(
        .inverse_cipher_key(inverse_cipher_key_tb),
        .inverse_cipher_input(inverse_cipher_input_tb),
        .inverse_cipher_output(inverse_cipher_output_tb)
    );
    
    initial
    begin : CHP_TST
    
        inverse_cipher_key_tb = 128'h000102030405060708090a0b0c0d0e0f;
        inverse_cipher_input_tb = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        #20
        assert (inverse_cipher_output_tb == 128'h00112233445566778899aabbccddeeff) 
                $display ("Correct Value"); else $error("Incorrect value");
    
    $finish;
    end
    
endmodule