`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/04/2023 05:22:10 PM
// Design Name: Shift Rows
// Module Name: shiftrows
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Shift rows for AES cipher
// 
// Dependencies: bsnbit
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module shiftrows(
        input [127:0] state_mem,
        output [127:0] state_mem_out
    );
    
    wire [8*(128/32) - 1:0] state_in_columns [3:0];
    wire [8*(128/32) - 1:0] state_out_rows [3:0];
    wire [8*(128/32) - 1:0] state_out_columns [3:0];
    
    assign state_in_columns[0] = state_mem[31:0];
    assign state_in_columns[1] = state_mem[63:32];
    assign state_in_columns[2] = state_mem[95:64];
    assign state_in_columns[3] = state_mem[127:96];
    
    wire [8*(128/32) - 1:0] state_in_rows [3:0];
    
    assign state_in_rows[0] = {state_in_columns[3][31:24], state_in_columns[2][31:24], state_in_columns[1][31:24], state_in_columns[0][31:24]};
    assign state_in_rows[1] = {state_in_columns[3][23:16], state_in_columns[2][23:16], state_in_columns[1][23:16], state_in_columns[0][23:16]};
    assign state_in_rows[2] = {state_in_columns[3][15:8], state_in_columns[2][15:8], state_in_columns[1][15:8], state_in_columns[0][15:8]};
    assign state_in_rows[3] = {state_in_columns[3][7:0], state_in_columns[2][7:0], state_in_columns[1][7:0], state_in_columns[0][7:0]};
    
    assign state_out_rows[0] = state_in_rows[0];
    
    bsnbit #(.SIZE(32)) BSGEN1(
        .bsnbit_data(state_in_rows[1]),
        .bsnbit_select(3 * 8),
        .bsnbit_sr(1),
        .bsnbit_output(state_out_rows[1])
    );
    
    bsnbit #(.SIZE(32)) BSGEN2(
        .bsnbit_data(state_in_rows[2]),
        .bsnbit_select(2 * 8),
        .bsnbit_sr(1),
        .bsnbit_output(state_out_rows[2])
    );
    
    bsnbit #(.SIZE(32)) BSGEN3(
        .bsnbit_data(state_in_rows[3]),
        .bsnbit_select(1 * 8),
        .bsnbit_sr(1),
        .bsnbit_output(state_out_rows[3])
    );
    
    assign state_out_columns[0] = {state_out_rows[0][31:24], state_out_rows[1][31:24], state_out_rows[2][31:24], state_out_rows[3][31:24]};
    assign state_out_columns[1] = {state_out_rows[0][23:16], state_out_rows[1][23:16], state_out_rows[2][23:16], state_out_rows[3][23:16]};
    assign state_out_columns[2] = {state_out_rows[0][15:8], state_out_rows[1][15:8], state_out_rows[2][15:8], state_out_rows[3][15:8]};
    assign state_out_columns[3] = {state_out_rows[0][7:0], state_out_rows[1][7:0], state_out_rows[2][7:0], state_out_rows[3][7:0]};
    
    assign state_mem_out = {state_out_columns[0], state_out_columns[1], state_out_columns[2], state_out_columns[3]};
    
endmodule
