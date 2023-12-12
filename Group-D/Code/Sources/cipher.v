`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/04/2023 05:44:18 PM
// Design Name: Cipher
// Module Name: cipher
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Main cipher module
// 
// Dependencies: key_expander, addroundkey, sbox, shiftrows, mix_columns
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module cipher(
        input [127:0] cipher_key,
        input [127:0] cipher_input,
        output [127:0] cipher_output
    );
    
    wire [1407:0] cipher_keyschedule;
    key_expander EXPANSION(
        .key_expander_key(cipher_key),
        .key_expander_output(cipher_keyschedule)
    );
    
    wire [127:0] cipher_r1_ark;
    addroundkey ARK1(
        .addroundkey_block(cipher_input),
        .addroundkey_keyschedule(cipher_keyschedule),
        .addroundkey_round(0),
        .addroundkey_output(cipher_r1_ark)
    );
    
    wire [127:0] cipher_roundstart [9:0];
    assign cipher_roundstart[0] = cipher_r1_ark;
    
    genvar i;
    generate 
        for(i=0;i<9;i=i+1) 
        begin
        
            wire [127:0] cipher_subbyte_ri;
            sbox #(.ELEMENTS(16)) SBOXRI(
                .sbox_input(cipher_roundstart[i]),
                .sbox_output(cipher_subbyte_ri)
            );
            
            wire [127:0] cipher_shiftrow_ri;
            shiftrows SHIFTRI(
                .state_mem(cipher_subbyte_ri),
                .state_mem_out(cipher_shiftrow_ri)
            );
            
            wire [127:0] cipher_mix_ri;
            mix_columns MIXRI(
                .mix_columns_in(cipher_shiftrow_ri),
                .mix_columns_out(cipher_mix_ri)
            );
            
            wire [127:0] cipher_ri_ark;
            addroundkey ARKI(
                .addroundkey_block(cipher_mix_ri),
                .addroundkey_keyschedule(cipher_keyschedule),
                .addroundkey_round(i+1),
                .addroundkey_output(cipher_ri_ark)
            );
            
            assign cipher_roundstart[i+1] = cipher_ri_ark;
        
        end
    endgenerate
    
    wire [127:0] cipher_subbyte_r10;
    sbox #(.ELEMENTS(16)) SBOXR10(
        .sbox_input(cipher_roundstart[9]),
        .sbox_output(cipher_subbyte_r10)
    );
    
    wire [127:0] cipher_shiftrow_r10;
    shiftrows SHIFTRI(
        .state_mem(cipher_subbyte_r10),
        .state_mem_out(cipher_shiftrow_r10)
    );
    
    wire [127:0] cipher_r10_ark;
    addroundkey ARK10(
        .addroundkey_block(cipher_shiftrow_r10),
        .addroundkey_keyschedule(cipher_keyschedule),
        .addroundkey_round(10),
        .addroundkey_output(cipher_r10_ark)
    );
    
    
    assign cipher_output = cipher_r10_ark;
    
endmodule
