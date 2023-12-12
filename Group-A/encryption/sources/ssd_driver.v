`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 08:15:00 PM
// Design Name: 
// Module Name: ssd_driver
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


module ssd_driver(
    input [31:0] ssd_driver_port_inp,
    input ssd_clk,
    input ssd_rst,
    output [7:0] ssd_driver_port_cc,
    output [7:0]ssd_driver_port_an
    );
    
    //assign ssd_driver_port_cc[7] = ssd_driver_port_idp;
    //assign ssd_driver_port_cc[7] = 0;
    //assign ssd_driver_port_led[4:0] = 0;//ssd_driver_port_inp;
    //assign ssd_driver_port_led[4] = 0;//ssd_driver_port_idp;
    
    reg[7:0] ssd_driver_tmp_cc;
    reg [7:0]ssd_driver_tmp_an;
    reg [3:0] ssd_driver_digit = 0;

    reg[2:0] count32_tmp = 3'd0;
    
    always@(posedge ssd_clk)
        begin:count32_operation
            if (ssd_rst == 1)
                count32_tmp <= 0;
            else
                count32_tmp <= count32_tmp + 1; 
        end
        
    
       
    always@(count32_tmp)
    //always@(count8_tmp)
        begin:digit_input_select
            case(count32_tmp)
                3'h0: ssd_driver_digit <= ssd_driver_port_inp[3:0];
                3'h1: ssd_driver_digit <= ssd_driver_port_inp[7:4];
                3'h2: ssd_driver_digit <= ssd_driver_port_inp[11:8];
                3'h3: ssd_driver_digit <= ssd_driver_port_inp[15:12];
                3'h4: ssd_driver_digit <= ssd_driver_port_inp[19:16];
                3'h5: ssd_driver_digit <= ssd_driver_port_inp[23:20];
                3'h6: ssd_driver_digit <= ssd_driver_port_inp[27:24];
                3'h7: ssd_driver_digit <= ssd_driver_port_inp[31:28];
            endcase
        end
    
    integer i;
    always@(ssd_driver_digit)
        begin      
              if(ssd_rst)
                    ssd_driver_tmp_cc <= 1;
              else
              begin
                    case(ssd_driver_digit)
                        4'h0: ssd_driver_tmp_cc <= 8'b10000001;
                        4'h1: ssd_driver_tmp_cc <= 8'b11001111;
                        4'h2: ssd_driver_tmp_cc <= 8'b10010010;
                        4'h3: ssd_driver_tmp_cc <= 8'b10000110;
                        4'h4: ssd_driver_tmp_cc <= 8'b11001100;
                        4'h5: ssd_driver_tmp_cc <= 8'b10100100;
                        4'h6: ssd_driver_tmp_cc <= 8'b10100000;
                        4'h7: ssd_driver_tmp_cc <= 8'b10001111;
                        4'h8: ssd_driver_tmp_cc <= 8'b10000000;
                        4'h9: ssd_driver_tmp_cc <= 8'b10001100;
                        4'hA: ssd_driver_tmp_cc <= 8'b10001000;
                        4'hB: ssd_driver_tmp_cc <= 8'b11100000;
                        4'hC: ssd_driver_tmp_cc <= 8'b10110001;
                        4'hD: ssd_driver_tmp_cc <= 8'b11000010;
                        4'hE: ssd_driver_tmp_cc <= 8'b10110000;
                        4'hF: ssd_driver_tmp_cc <= 8'b10111000;
                        
                        default: ssd_driver_tmp_cc <= 8'hFF;
                    endcase
                end
            end
    always@(count32_tmp)
        begin
            case(count32_tmp)
                3'h0: ssd_driver_tmp_an <= 8'b11111110;
                3'h1: ssd_driver_tmp_an <= 8'b11111101;
                3'h2: ssd_driver_tmp_an <= 8'b11111011;
                3'h3: ssd_driver_tmp_an <= 8'b11110111;
                3'h4: ssd_driver_tmp_an <= 8'b11101111;
                3'h5: ssd_driver_tmp_an <= 8'b11011111;
                3'h6: ssd_driver_tmp_an <= 8'b10111111;
                3'h7: ssd_driver_tmp_an <= 8'b01111111;
                
                default: ssd_driver_tmp_an <= 8'b11111111;
            endcase
        end
        assign ssd_driver_port_an = ssd_driver_tmp_an;
        assign ssd_driver_port_cc = ssd_driver_tmp_cc;
        

        
endmodule
