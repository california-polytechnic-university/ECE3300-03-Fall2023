`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group D
// Engineer: Jason Molina
// 
// Create Date: 12/05/2023 06:10:57 PM
// Design Name: AES Encryption Top
// Module Name: top
// Project Name: AES Encryption
// Target Devices: Nexys A7 100T
// Tool Versions: 2023.1
// Description: Top file for AES Encryption
// 
// Dependencies: debounce, cipher, inverse_cipher, clk_gen, ssd_driver, displaymanager, PWM_CORE, horizontal_counter, vertical_counter
// 
// Revision: 5.0
// Revision 1.0 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
        input top_clk,
        
        input [1:0] top_mode,
        output [1:0] top_mode_led,
        input top_enable,
        
        input top_display_mode,
        input top_autoscroll,
        input top_scroll_left,
        input top_scroll_right,
        output top_ssdd_odp,
        
        input top_clk_gen_rst,
        
        output [7:0] top_dm_an,
        output [6:0] top_cc_out,
        
        input top_rst,
        
        output PWM_r,
        output PWM_g,
        output PWM_b,
        
        output Hsynq,
        output Vsynq,
        output [3:0] Red,
        output [3:0] Green,
        output [3:0] Blue
    );
    
//////////////////////////////////////////////////////////////////////////////////    
    //Encryption and Decryption Management
    
    wire [127:0] top_key = 128'h000102030405060708090a0b0c0d0e0f;
    wire [127:0] top_input = 128'h00112233445566778899aabbccddeeff;
    
    reg [127:0] top_data;
    wire [127:0] top_data_wire = top_data;
    
    debounce DB1(
        .pb_1(top_enable),
        .clk(top_clk),
        .pb_out(top_db_out)
    );
    
    wire [127:0] top_cipher_input = top_cipher_input_tmp;
    wire [127:0] top_cipher_output;
    cipher CIPHER1(
        .cipher_key(top_key),
        .cipher_input(top_cipher_input),
        .cipher_output(top_cipher_output)
    );
    
    wire [127:0] top_inverse_cipher_input = top_inverse_cipher_input_tmp;
    wire [127:0] top_inverse_cipher_output;
    inverse_cipher INVERSE_CIPHER1(
        .inverse_cipher_key(top_key),
        .inverse_cipher_input(top_inverse_cipher_input),
        .inverse_cipher_output(top_inverse_cipher_output)
    );
    
    reg [127:0] top_cipher_input_tmp;
    reg [127:0] top_inverse_cipher_input_tmp;
    always@(posedge top_clk)
    begin
    
        if(top_db_out)
        begin
            top_cipher_input_tmp <= top_cipher_input;
            top_inverse_cipher_input_tmp <= top_inverse_cipher_input;
            
            if(top_mode == 2'd2)
                top_data <= top_input;
            else if(top_mode == 2'd0)
                top_data <= top_cipher_output;
            else if(top_mode == 2'd1)
                top_data <= top_inverse_cipher_output;
        end
        else
        begin
            top_cipher_input_tmp <= top_data_wire;
            top_inverse_cipher_input_tmp <= top_data_wire;
        end
            
    end
    
    assign top_mode_led[0] = top_mode[0];
    assign top_mode_led[1] = top_mode[1];

//////////////////////////////////////////////////////////////////////////////////    
    //Seven Segment Display Management
    
    wire [31:0] top_clk_out;
    clk_gen #(.SIZE(32)) CLK1(
        .fsys(top_clk),
        .clk_gen_rst(top_clk_gen_rst),
        .clk_gen_out(top_clk_out)
    );
    
    //Array of values to display
    wire [6:0] top_ssdd_cc [7:0];
    
    //Scroll through output nibbles to display
    reg [4:0] top_j = 31;
    always@(posedge top_clk_out[23])
    begin : DATA_SEL
    
        if(top_enable)
            top_j <= 31;
        else if((top_autoscroll || top_scroll_right) && top_j > 0)
            top_j <= top_j - 1;
        else if(top_autoscroll || top_scroll_right)
            top_j <= 31;
        else if(top_scroll_left && top_j < 31)
            top_j <= top_j + 1;
        else if(top_scroll_left)
            top_j <= 0;    
        
    end
    
    //Wires with size [4:0] used so that negative indices arent tried ie j=6 -> index 0 = [-1], instead rollover
    //When j-value was used directly there were errors in what the SSD drivers outout
    wire [4:0] indices [7:0];
    assign indices[7] = top_j;
    assign indices[6] = top_j-1;
    assign indices[5] = top_j-2;
    assign indices[4] = top_j-3;
    assign indices[3] = top_j-4;
    assign indices[2] = top_j-5;
    assign indices[1] = top_j-6;
    assign indices[0] = top_j-7;
    
    wire [127:0] top_display_data = top_display_data_tmp;
    reg [127:0] top_display_data_tmp;
    always@(top_display_mode)
    begin
    
        top_display_data_tmp <= top_display_mode ? top_key : top_data;
    
    end
    
    //Display output data 
    ssd_driver SSDD1(
            .ssd_driver_port_inp(top_display_data[indices[7]*4 +: 4]),
            .ssd_driver_port_idp(0),
            .ssd_driver_port_cc(top_ssdd_cc[7]),
            .ssd_driver_port_odp(top_ssdd_odp)
    );
    
    ssd_driver SSDD2(
            .ssd_driver_port_inp(top_display_data[indices[6]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[6])
    );
    
    ssd_driver SSDD3(
            .ssd_driver_port_inp(top_display_data[indices[5]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[5])
    );
    
    ssd_driver SSDD4(
            .ssd_driver_port_inp(top_display_data[indices[4]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[4])
    );
    
    ssd_driver SSDD5(
            .ssd_driver_port_inp(top_display_data[indices[3]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[3])
    );
    
    ssd_driver SSDD6(
            .ssd_driver_port_inp(top_display_data[indices[2]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[2])
    );
    
    ssd_driver SSDD7(
            .ssd_driver_port_inp(top_display_data[indices[1]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[1])
    );
    
    ssd_driver SSDD8(
            .ssd_driver_port_inp(top_display_data[indices[0]*4 +: 4]),
            .ssd_driver_port_cc(top_ssdd_cc[0])
    );
    
    //Loops though array of values to display
    reg [2:0] top_i = 0;
    always@(posedge top_clk_out[16])
    begin : CC_SEL
        
        top_i <= top_i + 1;
        
    end
    assign top_cc_out = top_ssdd_cc[top_i];
    
    //Loops through AN values to select which display is active
    displaymanager DM1(
        .displaymanager_clk(top_clk_out[16]),
        .displaymanager_an(top_dm_an)
    );
    
//////////////////////////////////////////////////////////////////////////////////    
    //RGB PWM Management
    
    wire clk_slow;
    wire lock;
    wire clk_locked;
    
    clk_wiz_0 CLK_GEN_SLOW(
        .clk_out(clk_slow),
        .reset(top_rst),
        .locked(lock),
        .clk_in1(top_clk)
    );
    
    assign clk_locked = clk_slow & lock;
    
    reg [12:0] duty_r_tmp;
    reg [12:0] duty_g_tmp;
    reg [12:0] duty_b_tmp;
    always@(top_data)
    begin
    
        if(top_data == top_input)
        begin
        
            duty_r_tmp <= 13'b0011111111;
            duty_g_tmp <= 13'd0;
            duty_b_tmp <= 13'd0;
        
        end
        else
        begin
        
            duty_r_tmp <= 13'd0;
            duty_g_tmp <= 13'b0011111111;
            duty_b_tmp <= 13'd0;
        
        end
    
    end
    
    wire [12:0] duty_r = duty_r_tmp;
    PWM_CORE #(.R_SIZE(13)) pwm_r(
        .clk(clk_locked),
        .rst(top_rst),
        .load(1),
        .duty(duty_r),
        .PWM(PWM_r)
    );
    
    wire [12:0] duty_g = duty_g_tmp;
    PWM_CORE #(.R_SIZE(13)) pwm_g(
        .clk(clk_locked),
        .rst(top_rst),
        .load(1),
        .duty(duty_g),
        .PWM(PWM_g)
    );
    
    wire [12:0] duty_b = duty_b_tmp;
    PWM_CORE #(.R_SIZE(13)) pwm_b(
        .clk(clk_locked),
        .rst(top_rst),
        .load(1),
        .duty(duty_b),
        .PWM(PWM_b)
    );
    
//////////////////////////////////////////////////////////////////////////////////    
    //VGA Management
    
    wire clk_25MHz;
    wire enable_V_Counter;
    wire [15:0] H_Count_Value;
    wire [15:0] V_Count_Value;
    
    clk_wiz_1 CLKDIV (.clk_out1(clk_25MHz),
                       .clk_in1(top_clk)
                       );
    
    horizontal_counter VGA_Horiz(.clk_25MHz(clk_25MHz), .enable_V_Counter(enable_V_Counter), .H_Count_Value(H_Count_Value));
    vertical_counter VGA_Verti(.clk_25MHz(clk_25MHz), .enable_V_Counter(enable_V_Counter), .V_Count_Value(V_Count_Value));
    
    assign Hsynq = (H_Count_Value < 96) ? 1'b1 : 1'b0;
    assign Vsynq = (V_Count_Value < 2) ? 1'b1 : 1'b0;
    
    reg [3:0] input_r_tmp;
    reg [3:0] input_g_tmp;
    reg [3:0] input_b_tmp;
    always@(top_data)
    begin
    
        if(top_data == top_input)
        begin
        
            input_r_tmp <= 4'b1111;
            input_g_tmp <= 4'd0;
            input_b_tmp <= 4'd0;
        
        end
        else
        begin
        
            input_r_tmp <= 4'd0;
            input_g_tmp <= 4'b1111;
            input_b_tmp <= 4'd0;
        
        end
    
    end
    
    assign input_r = input_r_tmp;
    assign input_g = input_g_tmp;
    assign input_b = input_b_tmp;
    assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34) ? input_r : 4'h0;
    assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34) ? input_g : 4'h0;
    assign Blue = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34) ? input_b : 4'h0;
    
endmodule
