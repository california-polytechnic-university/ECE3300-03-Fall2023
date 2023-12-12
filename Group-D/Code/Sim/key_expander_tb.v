`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/03/2023 06:31:27 PM
// Design Name: Key Expander Testbench
// Module Name: key_expander_tb
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Testbench for key expander
// 
// Dependencies: key_expander
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module key_expander_tb(
    );
    
    reg [127:0] key_expander_key_tb;
    wire [1407:0] key_expander_output_tb;
    
    key_expander KEY_EXP1(
        .key_expander_key(key_expander_key_tb),
        .key_expander_output(key_expander_output_tb)
    );
    
    initial
        begin : CHP_TST
        
        key_expander_key_tb = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        #20
        assert (key_expander_output_tb == 1408'hb6630ca6e13f0cc8c9ee2589d014f9a8575c006e28d1294119fadc21ac7766f37f8d292f312bf560b58dbad2ead273214ea6dc4f84a64fb25f5fc9f34e54f70eca0093fddbf98641110b3efd6d88a37a11f915bccaf2b8bc7c839d87d4d1c6f8db0bad00b671253ba8525b7fef44a5416d7a883b1e237e444716fe3e3d80477d7359f67f5935807a7a96b943f2c295f22a6c760523a3393988542cb1a0fafe1709cf4f3cabf7158828aed2a62b7e1516) 
                $display ("Correct Value"); else $error("Incorrect value");
        
        $finish;
        end
    
endmodule
