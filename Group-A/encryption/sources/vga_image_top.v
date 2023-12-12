`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 11:25:34 AM
// Design Name: 
// Module Name: vga_image_top
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

module vga_image_top (
    input clk,
    input rst,
    input [8:0] sw,
    output hsync,
    output vsync,
    output [2:0] red,
    output [2:0] green,
    output [2:0] blue,
    output [2:0] pwmRGB,
    output [7:0] top_ssd_driver_port_cc,
    output [7:0] top_ssd_driver_port_an
);

parameter strip_hpixels = 800;    // Value of pixels in a horizontal line = 800
parameter strip_vlines = 512;    // Number of horizontal lines in the display = 521
parameter strip_hbp = 144;        // Horizontal back porch = 144 (128 + 16)
parameter strip_hfp = 784;        // Horizontal front porch = 784 (128+16 + 640)
parameter strip_vbp = 31;         // Vertical back porch = 31 (2 + 29)
parameter strip_vfp = 511;        // Vertical front porch = 511 (2+29+ 480)

wire clk25MHz;
wire locked_pll;
wire steady_clk25MHz;

wire [9:0] hc_top;
wire [9:0] vc_top;
wire video_on;

wire [23:0] IMG;
wire [23:0] IMG1, IMG2, IMG3, decrypted, encrypted;
wire [15:0] rom_addr4;
wire ssd_clk;

clk_wiz_0 CLK_GEN_PLL (
    .clk_out1(clk25MHz),
    .reset(rst),
    .locked(locked_pll),
    .clk_in1(clk)
);

clk_gen #(.SIZE(32)) clk_gen_top(
            .fsys(clk),
            .clk_gen_rst(rst),
            .clk_gen_speed_control(5'h19),
            //.clk_gen_out(top_clk),
            .clk_gen_out_ssd(ssd_clk)
        );

assign steady_clk25MHz = locked_pll & clk25MHz;

blk_mem_gen_0 bram (
  .clka(steady_clk25MHz),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(rom_addr4),  // input wire [17 : 0] addra
  .dina(24'd0),    // input wire [23 : 0] dina
  .douta(IMG1)  // output wire [23 : 0] douta
);

blk_mem_gen_1 bram1 (
  .clka(steady_clk25MHz),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(rom_addr4),  // input wire [17 : 0] addra
  .dina(24'd0),    // input wire [23 : 0] dina
  .douta(IMG3)  // output wire [23 : 0] douta
);

encryption encrypt_init(
    .clk(steady_clk25MHz),
    .rst(rst),
    .sw(sw[6:0]),
    .pixel_in(IMG),
    .encrypted_pixel_out(encrypted)
);

encryption decrypt_init(
    .clk(steady_clk25MHz),
    .rst(rst),
    .sw(sw[6:0]),
    .pixel_in(encrypted),
    .encrypted_pixel_out(decrypted)
);

vga_640x480 VGA_DRIVER (
    .clk(steady_clk25MHz),
    .clr(rst),
    .hsync(hsync),
    .vsync(vsync),
    .hc(hc_top),
    .vc(vc_top),
    .vidon(video_on)
);

assign IMG2 = sw[7] ? decrypted : encrypted;
assign IMG = sw[8] ? IMG3 : IMG1;
//assign IMG = {encrypted, IMG1};

vga_image INIT (
    .clk(steady_clk25MHz),
    .rst(rst),
    .vidon(video_on),
    .hc(hc_top),
    .vc(vc_top),
    .M(IMG),
    .N(IMG2),
    //.SW(sw),
    .rom_addr4(rom_addr4),
    .red(red),
    .green(green),
    .blue(blue)
);

top_pwm #(.SIZE(7)) pwmVGAImageTop(
    .sys_clk(clk),
    .rst(rst),
    .load_r(0),
    .load_g(0),
    .load_b(0),
    .duty(sw),
    .PWM_r(pwmRGB[0]),
    .PWM_g(pwmRGB[1]),
    .PWM_b(pwmRGB[2])
);

wire [31:0]ssd_input = {3'b0, sw[8], 3'b000, sw[7], 17'd0, sw[6:4], sw[3:0]};
    ssd_driver ssd_driver_top(
            .ssd_driver_port_inp(ssd_input),
            .ssd_clk(ssd_clk),
            .ssd_rst(rst),
            .ssd_driver_port_cc(top_ssd_driver_port_cc),
            .ssd_driver_port_an(top_ssd_driver_port_an)
    );




//// Instantiate RGB to YCbCr module
//RGBtoYCbCr rgb_to_ycbcr_inst (
//    .rgb(IMG),
//    .ycbcr(ycbcr_output)
//);
    
// Instantiate YCbCr to RGB module
//YCbCrtoRGB ycbcr_to_rgb_inst (
//    .clk(steady_clk25MHz),
//    .y(IMG[23:16]),
//    .cb(IMG[15:8]),
//    .cr(IMG[7:0]),
//    .rgb(rgb_output)
//);


endmodule


