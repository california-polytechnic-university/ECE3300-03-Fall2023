`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/06/2023 06:23:50 PM
// Design Name: Vertical Counter
// Module Name: vertical_counter
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Vertical Counter for VGA
// 
// Dependencies: N/A
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: Code based on https://www.youtube.com/watch?v=4enWoVHCykI
// 
//////////////////////////////////////////////////////////////////////////////////


module vertical_counter(
        input clk_25MHz,
        input enable_V_Counter,
        output reg [15:0] V_Count_Value = 0
    );
    
    always@(posedge clk_25MHz) begin
    
        if (enable_V_Counter == 1'b1) begin
            if (V_Count_Value < 524)
                V_Count_Value <= V_Count_Value + 1;
            else V_Count_Value <= 0;
        end
        
    end
    
endmodule
