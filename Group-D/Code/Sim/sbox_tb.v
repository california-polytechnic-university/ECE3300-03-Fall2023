`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/03/2023 02:13:28 PM
// Design Name: S-Box Testbench
// Module Name: sbox_tb
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Testbench for s-box
// 
// Dependencies: sbox
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module sbox_tb(
    );
    
    reg [127:0] sbox_input_tb;
    wire [127:0] sbox_output_tb;
    
    sbox #(.ELEMENTS(16)) SBOX1(
        .sbox_input(sbox_input_tb),
        .sbox_output(sbox_output_tb)
    );
    
    initial
        begin : CHP_TST
        
        sbox_input_tb = 128'h00102030405060708090a0b0c0d0e0f0;
        #20
        assert (sbox_output_tb == 128'h63cab7040953d051cd60e0e7ba70e18c) 
                $display ("Correct Value"); else $error("Incorrect value");
        
        $finish;
        end
    
endmodule
