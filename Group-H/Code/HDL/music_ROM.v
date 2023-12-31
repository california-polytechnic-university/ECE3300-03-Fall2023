

/////////////////////////////////////////////////////
// Music ROM module
module music_ROM(
    input clk,
    input [7:0] address,
    output reg [7:0] note
);

always @(posedge clk)
    case(address)
                0, 1: note <= 8'd25;  // G
                2, 3: note <= 8'd30;  // C
                4, 5: note <= 8'd29;  // B
                6, 7: note <= 8'd30;  // C
                8, 9: note <= 8'd27;  // A
                10, 11: note <= 8'd27; // A
                12, 13: note <= 8'd27; // A
                14, 15: note <= 8'd27; // A
                16, 17: note <= 8'd27; // A
                18, 19: note <= 8'd27; // A
                20, 21: note <= 8'd30; // C
                22, 23: note <= 8'd27; // A
                24, 25: note <= 8'd25; // G
                26, 27: note <= 8'd25; // G
                28, 29: note <= 8'd25; // G
                30, 31: note <= 8'd25; // G
                32, 33: note <= 8'd25; // G
                34, 35: note <= 8'd25; // G
                36, 37: note <= 8'd30; // C
                38, 39: note <= 8'd29; // B
                40, 41: note <= 8'd30; // C
                42, 43: note <= 8'd27; // A
                44, 45: note <= 8'd27; // A
                46, 47: note <= 8'd23; // F
                48, 49: note <= 8'd27; // A
                50, 51: note <= 8'd27; // A
                52, 53: note <= 8'd25; // G
                54, 55: note <= 8'd25; // G
                56, 57: note <= 8'd27; // A
                58, 59: note <= 8'd25; // G
                60, 61: note <= 8'd23; // F
                62, 63: note <= 8'd23; // F
                64, 65: note <= 8'd22; // E
                66, 67: note <= 8'd22; // E
                68, 69: note <= 8'd22; // E
                70, 71: note <= 8'd22; // E
                72, 73: note <= 8'd22; // E
                74, 75: note <= 8'd22; // E
                76, 77: note <= 8'd25; // G
                78, 79: note <= 8'd30; // C
                80, 81: note <= 8'd29; // B
                82, 83: note <= 8'd30; // C
                84, 85: note <= 8'd27; // A
                86, 87: note <= 8'd27; // A
                88, 89: note <= 8'd27; // A
                90, 91: note <= 8'd27; // A
                92, 93: note <= 8'd27; // A
                94, 95: note <= 8'd27; // A
                96, 97: note <= 8'd30; // C
                98, 99: note <= 8'd27; // A
                100, 101: note <= 8'd25; // G
                102, 103: note <= 8'd25; // G
                104, 105: note <= 8'd25; // G
                106, 107: note <= 8'd25; // G
                108, 109: note <= 8'd25; // G
                110, 111: note <= 8'd25; // G
                112, 113: note <= 8'd30; // C
                114, 115: note <= 8'd29; // B
                116, 117: note <= 8'd30; // C
                118, 119: note <= 8'd27; // A
                120, 121: note <= 8'd27; // A
                122, 123: note <= 8'd23; // F
                124, 125: note <= 8'd27; // A
                126, 127: note <= 8'd27; // A
                128, 129: note <= 8'd25; // G
                130, 131: note <= 8'd25; // G
                132, 133: note <= 8'd27; // A
                134, 135: note <= 8'd25; // G
                136, 137: note <= 8'd23; // F
                138, 139: note <= 8'd23; // F
                140, 141: note <= 8'd22; // E
                142, 143: note <= 8'd22; // E
                144, 145: note <= 8'd22; // E
                146, 147: note <= 8'd22; // E
                148, 149: note <= 8'd22; // E
                150, 151: note <= 8'd22; // E
                //second part
                152,153: note <= 8'd34; // E;
                154,155: note <= 8'd34; // E;
                156,157: note <= 8'd34; // E;
                157,158: note <= 8'd32; // D;
                159,160: note <= 8'd30; // C;
                161,162: note <= 8'd30; // C;
                163, 164: note <= 8'd27; // A
                165, 166: note <= 8'd27; // A
                167,168: note <= 8'd30; // C;
                169,170: note <= 8'd30; // C;
                171,172: note <= 8'd32; // D;
                173,174: note <= 8'd32; // D;
                175,176: note <= 8'd32; // D;
                177,178: note <= 8'd30; // C;
                179, 180: note <= 8'd27; // A
                181, 182: note <= 8'd27; // A
                183, 184: note <= 8'd25; // G
                185, 186: note <= 8'd24; // F#
                187, 188: note <= 8'd25; // G
                189, 190: note <= 8'd25; // G
                191,192: note <= 8'd34; // E;
                193,194: note <= 8'd34; // E;
                195,196: note <= 8'd34; // E;
                197,198: note <= 8'd32; // D;
                199,200: note <= 8'd30; // C;
                201,202: note <= 8'd30; // C;
                203, 204: note <= 8'd27; // A
                205, 206: note <= 8'd27; // A
                207,208: note <= 8'd32; // D;
                209,210: note <= 8'd30; // C;
                211,212: note <= 8'd29; // B;
                213,214: note <= 8'd29; // B;
                215,216: note <= 8'd30; // C;
                217,218: note <= 8'd32; // D;
                219,220: note <= 8'd32; // D;
                221,222: note <= 8'd30; // C;
                223,224: note <= 8'd30; // C;
                225,226: note <= 8'd30; // C;
                227,228: note <= 8'd32; // D
                229,230: note <= 8'd34; // E;
                231,232: note <= 8'd35; // F;
                233,234: note <= 8'd37; // G;
                235,236: note <= 8'd39; // A;
                237,238: note <= 8'd41; // B;
                239,240: note <= 8'd42; // C;
                241,242: note <= 8'd42; // C;
                243,244: note <= 8'd42; // C;
                245,246: note <= 8'd42; // C;
                247,248: note <= 8'd42; // C;
                249,250: note <= 8'd42; // C;
                        default: note <= 8'd0;
    endcase
endmodule
