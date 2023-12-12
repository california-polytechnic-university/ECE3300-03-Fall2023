`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 10/25/2023 06:27:53 PM
// Design Name: Display Manager
// Module Name: displaymanager
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Shifts though which AN value is enabled for SSDs
// 
// Dependencies: 
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module displaymanager(
        input displaymanager_clk,
        output [7:0] displaymanager_an
    );
    
    reg [7:0] displaymanager_ansel = 8'b00000001;
    always@(posedge displaymanager_clk)
    begin : ANSEL_OP
    
        if(displaymanager_ansel != 8'b10000000)
            displaymanager_ansel <= displaymanager_ansel << 1;
        else
            displaymanager_ansel <= 8'b00000001;
        
    end

    assign displaymanager_an = ~displaymanager_ansel;
    
endmodule
