`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/06/2023 06:27:22 PM
// Design Name: Horizontal Counter
// Module Name: horizontal_counter
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Horizontal Counter for VGA
// 
// Dependencies: N/A
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: Code based on https://www.youtube.com/watch?v=4enWoVHCykI
// 
//////////////////////////////////////////////////////////////////////////////////


module horizontal_counter(
        input clk_25MHz,
        output reg enable_V_Counter = 0,
        output reg [15:0] H_Count_Value = 0
    );
    
    always@(posedge clk_25MHz) begin
    
        if (H_Count_Value < 799) begin
            H_Count_Value <= H_Count_Value + 1;
            enable_V_Counter <= 0;      
        end
        else begin
            H_Count_Value <= 0;
            enable_V_Counter <= 1;    
        end
    end
    
endmodule
