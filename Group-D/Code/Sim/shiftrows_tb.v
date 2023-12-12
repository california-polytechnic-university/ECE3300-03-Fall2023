`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/03/2023 02:54:48 PM
// Design Name: Shift Rows Testbench
// Module Name: shiftrows_tb
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Teestbench for shift rows
// 
// Dependencies: shiftrows
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module shiftrows_tb(

    );
    
    reg [127:0] state_mem_tb;
    wire [127:0] state_mem_out_tb;
    
    shiftrows SHIFT1(
        .state_mem(state_mem_tb),
        .state_mem_out(state_mem_out_tb)
    );
    
    initial
    begin : CHP_TST
    
        state_mem_tb = 128'h63cab7040953d051cd60e0e7ba70e18c;
        #20
        assert (state_mem_out_tb == 128'h6353e08c0960e104cd70b751bacad0e7) 
                $display ("Correct Value"); else $error("Incorrect value");
    
    $finish;
    end
    
endmodule
