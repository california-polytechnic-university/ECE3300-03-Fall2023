`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/04/2023 04:55:00 PM
// Design Name: Add Round Key
// Module Name: addroundkey
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Add Round Key module for cipher
// 
// Dependencies: N/A
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module addroundkey(
        input [127:0] addroundkey_block,
        input [1407:0] addroundkey_keyschedule,
        input [3:0] addroundkey_round,
        output [127:0] addroundkey_output
    );
    
    wire [127:0] addroundkey_roundkey = {addroundkey_keyschedule[addroundkey_round*128 +: 32], addroundkey_keyschedule[addroundkey_round*128+32 +: 32], addroundkey_keyschedule[addroundkey_round*128+64 +: 32], addroundkey_keyschedule[addroundkey_round*128+96 +: 32]};
    
    assign addroundkey_output = addroundkey_block ^ addroundkey_roundkey;
    
endmodule
