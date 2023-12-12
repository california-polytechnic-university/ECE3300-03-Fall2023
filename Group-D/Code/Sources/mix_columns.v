`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// https://github.com/michaelehab/AES-Verilog/blob/main/mixColumns.v
//////////////////////////////////////////////////////////////////////////////////


module mix_columns(
        input [127:0] mix_columns_in,
        output[127:0] mix_columns_out
    );

    function [7:0] mb2;
        input [7:0] x;
        begin 
                if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
                else mb2 = x << 1; 
        end 	
    endfunction
    
    function [7:0] mb3;
        input [7:0] x;
        begin 
                
                mb3 = mb2(x) ^ x;
        end 
    endfunction

    genvar i;
    
    generate 
    for(i=0;i< 4;i=i+1) begin : m_col
    
       assign mix_columns_out[(i*32 + 24)+:8]= mb2(mix_columns_in[(i*32 + 24)+:8]) ^ mb3(mix_columns_in[(i*32 + 16)+:8]) ^ mix_columns_in[(i*32 + 8)+:8] ^ mix_columns_in[i*32+:8];
       assign mix_columns_out[(i*32 + 16)+:8]= mix_columns_in[(i*32 + 24)+:8] ^ mb2(mix_columns_in[(i*32 + 16)+:8]) ^ mb3(mix_columns_in[(i*32 + 8)+:8]) ^ mix_columns_in[i*32+:8];
       assign mix_columns_out[(i*32 + 8)+:8]= mix_columns_in[(i*32 + 24)+:8] ^ mix_columns_in[(i*32 + 16)+:8] ^ mb2(mix_columns_in[(i*32 + 8)+:8]) ^ mb3(mix_columns_in[i*32+:8]);
       assign mix_columns_out[i*32+:8]= mb3(mix_columns_in[(i*32 + 24)+:8]) ^ mix_columns_in[(i*32 + 16)+:8] ^ mix_columns_in[(i*32 + 8)+:8] ^ mb2(mix_columns_in[i*32+:8]);
    
    end
    
    endgenerate
    
endmodule
