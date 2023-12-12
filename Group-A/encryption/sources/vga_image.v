`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 10:55:55 AM
// Design Name: 
// Module Name: vga_image
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_image (
    input clk,
    input rst,
    input vidon,
    input [9:0] hc,
    input [9:0] vc,
    input [23:0] M, // [0:153601],  // BRAM with width 24 bits and depth 153602
    input [23:0] N,
    //input [6:0] SW,
    output [17:0] rom_addr4,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);

parameter hbp = 144;
parameter vbp = 31;
// Horizontal back porch = 144 (128 +16)
parameter hfp = 10'd784; 
parameter W = 32;
parameter H = 16;
parameter DISPLAY_WIDTH = 640;
parameter DISPLAY_HEIGHT = 480;
parameter IMAGE_WIDTH = 160;
parameter IMAGE_HEIGHT = 240;

reg [15:0] R1, C1, rom_addr, rom_pix;
reg spriteon;
reg [23:0] R, G, B;  // Adjust width for 24 bits
//// Calculate the centering offsets
//reg [9:0] h_offset = (DISPLAY_WIDTH - IMAGE_WIDTH) / 2;
//reg [9:0] v_offset = (DISPLAY_HEIGHT - IMAGE_HEIGHT) / 2;
// Adjust horizontal and vertical counters for centering
//reg [9:0] hc_centered;
//reg [9:0] vc_centered;

reg [3:0] red_temp_pre, green_temp_pre, blue_temp_pre;
reg [3:0] red_temp, green_temp, blue_temp;

reg [9:0] hc_adjusted;
reg [9:0] vc_adjusted;
/*
parameter WIDTH = 12;  // Assuming 12-bit resolution
parameter GAMMA = 2.2;  // Adjust this value based on your gamma correction requirement
parameter FIXED_POINT = 8;  // Adjust this value based on precision needs

reg [WIDTH-1:0] gamma_table [0:(1 << WIDTH)-1];

// Initialize gamma correction table
integer i;
real gamma_value;
initial begin
    for (i = 0; i < (1 << WIDTH); i = i + 1) begin
        gamma_value = (i / (1.0 * (1 << WIDTH - 1))) ** (1.0 / GAMMA);
        gamma_table[i] = (gamma_value * (1 << FIXED_POINT));
    end
end*/

always @(posedge rst or posedge clk) begin
    //if(SW[0]) begin
        //hc_centered <= hc - h_offset;
        //vc_centered <= vc - v_offset;
        hc_adjusted = hc - hbp;
        vc_adjusted = vc - vbp;
    
        if (rst) begin
            spriteon <= 1'b0;
        end else begin
            spriteon <= ((hc_adjusted <= IMAGE_WIDTH) && vc_adjusted <= (2*IMAGE_HEIGHT)) ? 1:0;
        end
    //end 
    //else begin
//        hc_adjusted = hc - hbp;
//        vc_adjusted = vc - vbp;
    
//        if (rst) begin
//            spriteon <= 1'b0;
//        end else begin
//            spriteon <= ((hc_adjusted <= IMAGE_WIDTH) && vc_adjusted <= IMAGE_HEIGHT) ? 1:0;
//        end
    //end

end

// recreates the gamma corrected curve using a piecewise linear function of shift-and-add operations
    // Gamma = 2.2
/*function automatic [7:0] correct_gamma22;
    input [7:0] color;
    if      (color <= 3)
        correct_gamma22 = (color << 2) + 0;
    else if (color <= 18)
        correct_gamma22 = (color << 1) + 5;
    else if (color <= 33)
        correct_gamma22 = (color     ) + 21;
    else if (color <= 153)
        correct_gamma22 = (color     ) + 28;
    else if (color <= 187)
        correct_gamma22 = (color >> 1) + 105;
    else if (color <= 227)
        correct_gamma22 = (color >> 1) + 115;
    else
        correct_gamma22 = (color >> 1) + 124;
endfunction*/

always @(posedge rst or posedge clk) begin
    if (rst | (vidon & !spriteon)) begin
        //red_temp_pre <= 4'd0;
        //green_temp_pre <= 4'd0;
        //blue_temp_pre <= 4'd0;
        red_temp <= 4'd0;
        green_temp <= 4'd0;
        blue_temp <= 4'd0;
        
    end else if (vidon & spriteon) begin
         // Weighted Averaging
         if (hc_adjusted <= IMAGE_WIDTH)
            begin
                if(vc_adjusted <= IMAGE_HEIGHT)
                    begin
                        red_temp <= (M[7:0] + (M[7:0] >> 1)) >> 4;  // Divide red by 2
                        green_temp <= (M[15:8] + (M[15:8] >> 1)) >> 4;  // Divide green by 2
                        blue_temp <= (M[23:16] + (M[23:16] >> 1)) >> 4;  // Divide blue by 2
                    end
                else if (vc_adjusted > IMAGE_HEIGHT && vc_adjusted <= (2*IMAGE_HEIGHT))
                    begin
                        red_temp <= (N[7:0] + (N[7:0] >> 1)) >> 4;  // Divide red by 2
                        green_temp <= (N[15:8] + (N[15:8] >> 1)) >> 4;  // Divide green by 2
                        blue_temp <= (N[23:16] + (N[23:16] >> 1)) >> 4;  // Divide blue by 2
                    end
            end
//        else if (hc_adjusted <= (IMAGE_WIDTH) && hc_adjusted > IMAGE_WIDTH_1)
//            begin
//                red_temp <= (N[7:0] + (N[7:0] >> 1)) >> 4;  // Divide red by 2
//                green_temp <= (N[15:8] + (N[15:8] >> 1)) >> 4;  // Divide green by 2
//                blue_temp <= (N[23:16] + (N[23:16] >> 1)) >> 4;  // Divide blue by 2
//            end
        //red_temp <= red_temp_pre;
        //green_temp <= green_temp_pre;
        //blue_temp <= blue_temp_pre;
        
        
        // Gamma Correction Lookup Table
        /*red_temp <= gamma_table[red_temp_pre];
        green_temp <= gamma_table[green_temp_pre];
        blue_temp <= gamma_table[blue_temp_pre];*/


        // Gamma Correction
        // Simple Gamma Correction (bit-shifting approximation)
        /*red_temp <= red_temp >> 1;  // Gamma correction for red (dividing by 2)
        green_temp <= green_temp >> 1;  // Gamma correction for green (dividing by 2)
        blue_temp <= blue_temp >> 1;  // Gamma correction for blue (dividing by 2)*/
        
        /**red_temp <= (M[7:0] + (M[7:0] >> 1)) >> 4;  // Divide red by 2
        green_temp <= (M[15:8] + (M[15:8] >> 1)) >> 4;  // Divide green by 2
        blue_temp <= (M[23:16] + (M[23:16] >> 1)) >> 4;  // Divide blue by 2*/
    
        /*red_temp <= {M[4], M[5], M[6], M[7]}; 
        green_temp <= {M[12], M[13], M[14], M[15]}; 
        blue_temp <= {M[20], M[21], M[22], M[23]}; */
        /*red_temp <= {M[0]&M[1], M[2]&M[3], M[4]&M[5], M[6]&M[7]}; 
        green_temp <= {M[8]&M[9], M[10]&M[11], M[12]&M[13], M[14]&M[15]}; 
        blue_temp <= {M[17]&M[16], M[19]&M[18], M[21]&M[20], M[23]&M[22]};  */
    end

end

always @(posedge rst or posedge clk) begin
    if(rst | (vc_adjusted <= (2*IMAGE_HEIGHT) && vc_adjusted == IMAGE_HEIGHT && hc_adjusted >= IMAGE_WIDTH) | (vc_adjusted >= (2*IMAGE_HEIGHT) && hc_adjusted >= IMAGE_WIDTH))
        rom_addr = 0;
    else if(vidon & spriteon)
        rom_addr = rom_addr + 1; 
        
    
   // C1 = {2'b00, SW[3:0], 5'b00001};  // Removed SW[3:0]
   // R1 = {2'b00, SW[7:4], 5'b00001};  // Removed SW[7:4]
    //rom_addr = vc - vbp;
    //rom_pix = hc - hbp;
end

assign rom_addr4 = rom_addr;
assign red = red_temp;
assign green = green_temp;
assign blue = blue_temp;

endmodule

