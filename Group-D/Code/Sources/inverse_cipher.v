`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/05/2023 04:52:08 PM
// Design Name: Inverse Cipher
// Module Name: inverse_cipher
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Inverse of the AES cipher
// 
// Dependencies: key_expander, addroundkey, inverseshiftrows, inversesbox, inversemix_columns
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module inverse_cipher(
        input [127:0] inverse_cipher_key,
        input [127:0] inverse_cipher_input,
        output [127:0] inverse_cipher_output
    );
    
    wire [1407:0] inverse_cipher_keyschedule;
    key_expander EXPANSION(
        .key_expander_key(inverse_cipher_key),
        .key_expander_output(inverse_cipher_keyschedule)
    );
    
    wire [127:0] inverse_cipher_r1_ark;
    addroundkey ARK1(
        .addroundkey_block(inverse_cipher_input),
        .addroundkey_keyschedule(inverse_cipher_keyschedule),
        .addroundkey_round(10),
        .addroundkey_output(inverse_cipher_r1_ark)
    );
    
    wire [127:0] inverse_cipher_roundstart [9:0];
    assign inverse_cipher_roundstart[0] = inverse_cipher_r1_ark;
    
    genvar i;
    generate 
        for(i=0;i<9;i=i+1) 
        begin
        
            wire [127:0] inverse_cipher_shiftrow_ri;
            inverseshiftrows SHIFTRI(
                .state_mem(inverse_cipher_roundstart[i]),
                .state_mem_out(inverse_cipher_shiftrow_ri)
            );
        
            wire [127:0] inverse_cipher_subbyte_ri;
            inversesbox #(.ELEMENTS(16)) SBOXRI(
                .inversesbox_input(inverse_cipher_shiftrow_ri),
                .inversesbox_output(inverse_cipher_subbyte_ri)
            );
            
            
            wire [127:0] inverse_cipher_ri_ark;
            addroundkey ARKI(
                .addroundkey_block(inverse_cipher_subbyte_ri),
                .addroundkey_keyschedule(inverse_cipher_keyschedule),
                .addroundkey_round(9-i),
                .addroundkey_output(inverse_cipher_ri_ark)
            );
            
            wire [127:0] inverse_cipher_mix_ri;
            inversemix_columns MIXRI(
                .state_in(inverse_cipher_ri_ark),
                .state_out(inverse_cipher_mix_ri)
            );
            
            assign inverse_cipher_roundstart[i+1] = inverse_cipher_mix_ri;
        
        end
    endgenerate
    
    wire [127:0] inverse_cipher_shiftrow_r10;
    inverseshiftrows SHIFTRI(
        .state_mem(inverse_cipher_roundstart[9]),
        .state_mem_out(inverse_cipher_shiftrow_r10)
    );
    
    wire [127:0] inverse_cipher_subbyte_r10;
    inversesbox #(.ELEMENTS(16)) SBOXR10(
        .inversesbox_input(inverse_cipher_shiftrow_r10),
        .inversesbox_output(inverse_cipher_subbyte_r10)
    );
    
    wire [127:0] inverse_cipher_r10_ark;
    addroundkey ARK10(
        .addroundkey_block(inverse_cipher_subbyte_r10),
        .addroundkey_keyschedule(inverse_cipher_keyschedule),
        .addroundkey_round(0),
        .addroundkey_output(inverse_cipher_r10_ark)
    );
    
    
    assign inverse_cipher_output = inverse_cipher_r10_ark;
    
endmodule