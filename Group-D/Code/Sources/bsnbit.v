`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 10/10/2023 05:37:40 PM
// Design Name: Barrel Shifter N-Bit
// Module Name: bsnbit
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: N-bit barrel shifter
// 
// Dependencies: mux2x1
// 
// Revision: 1.1
// Revision 0.01 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module bsnbit #(parameter SIZE = 128)(
        input [SIZE-1:0] bsnbit_data,
        input [$clog2(SIZE)-1:0] bsnbit_select,
        input bsnbit_sr,
        output [SIZE-1:0] bsnbit_output
    );
    
    //Wires for inputs, inbetween values, and outputs
    wire [SIZE-1:0] bsnbit_tmp [$clog2(SIZE):0];
    //Index 0 is inputs, Index size-1 is outputs
    assign bsnbit_tmp[0] = bsnbit_data;
    
    //Levels
    genvar i;
    //Number of normal multiplexers
    genvar j;
    //Number of "extra" multiplexers
    genvar k;
    //Number of "special" multiplexers
    genvar l;
    generate
        for (i = 0; i < $clog2(SIZE); i = i+1)
           begin : GENBSLAYERS
                for (j = 0; j < SIZE-(2**i); j = j+1)
                    begin : GENNORMAL
                    mux2x1 CELL(
                        .mux2x1_port_sel(bsnbit_select[i]),
                        .mux2x1_port_i0(bsnbit_tmp[i][j]),
                        .mux2x1_port_i1(bsnbit_tmp[i][((2**i)+j)%SIZE]),
                        .mux2x1_port_output(bsnbit_tmp[i+1][j])
                    );
                    end
                    
                wire [2**i-1:0] bsnbit_extra_tmp;
                    
                for (k = SIZE-(2**i); k < SIZE; k = k+1)
                    begin : GENEXTRA
                    mux2x1 CELL(
                        .mux2x1_port_sel(bsnbit_sr),
                        .mux2x1_port_i0(0),
                        .mux2x1_port_i1(bsnbit_tmp[i][((2**i)+k)%SIZE]),
                        .mux2x1_port_output(bsnbit_extra_tmp[SIZE-k-1])
                    );
                    end
                    
                for (l = SIZE-(2**i); l < SIZE; l = l+1)
                    begin : GENSPECIAL
                    mux2x1 CELL(
                        .mux2x1_port_sel(bsnbit_select[i]),
                        .mux2x1_port_i0(bsnbit_tmp[i][l]),
                        .mux2x1_port_i1(bsnbit_extra_tmp[SIZE-l-1]),
                        .mux2x1_port_output(bsnbit_tmp[i+1][l])
                    );
                    end
            end
    endgenerate
    
    assign bsnbit_output = bsnbit_tmp[$clog2(SIZE)];
    
endmodule