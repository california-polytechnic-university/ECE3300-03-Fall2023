`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/04/2023 06:11:37 PM
// Design Name: Cipher Testbench
// Module Name: cipher_tb
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Testbench for AES-128 cipher
// 
// Dependencies: cipher
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module cipher_tb(
    );
    
    reg [127:0] cipher_key_tb;
    reg [127:0] cipher_input_tb;
    wire [127:0] cipher_output_tb;
    
    cipher CIPHER1(
        .cipher_key(cipher_key_tb),
        .cipher_input(cipher_input_tb),
        .cipher_output(cipher_output_tb)
    );
    
    initial
    begin : CHP_TST
    
        cipher_key_tb = 128'h000102030405060708090a0b0c0d0e0f;
        cipher_input_tb = 128'h00112233445566778899aabbccddeeff;
        #20
        assert (cipher_output_tb == 128'h69c4e0d86a7b0430d8cdb78070b4c55a) 
                $display ("Correct Value"); else $error("Incorrect value");
    
    $finish;
    end
    
endmodule
