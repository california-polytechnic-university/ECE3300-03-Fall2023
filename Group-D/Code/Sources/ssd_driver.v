`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 09/20/2023 08:13:13 PM
// Design Name: SSD Driver
// Module Name: ssd_driver
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Driver for a Seven Segment Display
// 
// Dependencies: N/A
// 
// Revision: 1.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module ssd_driver(
    input [3:0] ssd_driver_port_inp,
    input ssd_driver_port_idp,
    output [3:0] ssd_driver_port_led,
    output [6:0] ssd_driver_port_cc,
    output ssd_driver_port_odp
    );
    
    assign ssd_driver_port_odp = !ssd_driver_port_idp;
    assign ssd_driver_port_led = ssd_driver_port_inp;
    
    reg [6:0] ssd_driver_tmp_cc;
    wire [3:0] ssd_driver_digit;
    assign ssd_driver_digit = ssd_driver_port_inp;
    
    always@(ssd_driver_port_inp)
        begin:SEG_ENC
            case(ssd_driver_digit)
                4'h0: ssd_driver_tmp_cc = 7'b1000000;
                4'h1: ssd_driver_tmp_cc = 7'b1111001;
                4'h2: ssd_driver_tmp_cc = 7'b0100100;
                4'h3: ssd_driver_tmp_cc = 7'b0110000;
                4'h4: ssd_driver_tmp_cc = 7'b0011001;
                4'h5: ssd_driver_tmp_cc = 7'b0010010;
                4'h6: ssd_driver_tmp_cc = 7'b0000010;
                4'h7: ssd_driver_tmp_cc = 7'b1111000;
                4'h8: ssd_driver_tmp_cc = 7'b0000000;
                4'h9: ssd_driver_tmp_cc = 7'b0010000;
                4'hA: ssd_driver_tmp_cc = 7'b0001000;
                4'hB: ssd_driver_tmp_cc = 7'b0000011;
                4'hC: ssd_driver_tmp_cc = 7'b1000110;
                4'hD: ssd_driver_tmp_cc = 7'b0100001;
                4'hE: ssd_driver_tmp_cc = 7'b0000110;
                4'hF: ssd_driver_tmp_cc = 7'b0001110;
                
                default: ssd_driver_tmp_cc = 7'bZZZZ;
            endcase
        end
    
        assign ssd_driver_port_cc = ssd_driver_tmp_cc;
    
endmodule
