----------------------------------------------------------------------------------
-- Company: California State Polytechnic University Pomona, University of Illinois at Urbana-Champaign 
-- Engineer: Dr. Eng: Mohamed El-Hadedy
-- 
-- Create Date: 11/06/2019 04:54:07 PM
-- Design Name: 
-- Module Name: vga_initials_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.math_real.all; 
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           sw   : in STD_LOGIC_VECTOR (7 downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           red  : out STD_LOGIC_VECTOR (2 downto 0); 
           green: out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (2 downto 0)   
         );
end vga_initials_top;

architecture Behavioral of vga_initials_top is

--COMPONENT blk_mem_gen_0
--  PORT (
--    clka : IN STD_LOGIC;
--    ena : IN STD_LOGIC;
--    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
--    --dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
--  );
--END COMPONENT;

component vga_640x480 
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
            vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
            hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
            hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
            vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
            vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
           );
    Port ( clk   : in  STD_LOGIC;
           clr   : in  STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc    : out STD_LOGIC_VECTOR (9 downto 0);
           vc    : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC
        );
end component;

component clk_wiz_0 
     port (
           clk_out1  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic
          );
end component; 

component PROM_IMG
    generic(DEPTH    :positive:= 16; 
            DATA_SIZE:positive:= 32
           );
    Port   ( addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0)
           );
end component;


component vga_initials 
    generic (hbp:positive:=144; vbp:positive:=31; W:positive:=32; H:positive:= 16 );
    Port ( 
           clk      : in  STD_LOGIC; 
           rst      : in  STD_LOGIC; 
           vidon    : in  STD_LOGIC;
           hc       : in  STD_LOGIC_VECTOR (9  downto 0);
           vc       : in  STD_LOGIC_VECTOR (9  downto 0);
           M        : in  STD_LOGIC_VECTOR (31 downto 0);
           SW       : in  STD_LOGIC_VECTOR (7  downto 0);
           rom_addr4: out STD_LOGIC_VECTOR (3  downto 0);
           red      : out STD_LOGIC_VECTOR (2  downto 0); 
           green    : out STD_LOGIC_VECTOR (2  downto 0); 
           blue     : out STD_LOGIC_VECTOR (2  downto 0)
         );
end component;

signal clk25MHz       :std_logic; 
signal locked_pll     :std_logic; 
signal steady_clk25MHz:std_logic;

signal hc, vc:std_logic_vector(9 downto 0); 
signal video_on :std_logic; 

signal IMG:std_logic_vector(31 downto 0); 
signal rom_addr4:std_logic_vector(3 downto 0); 

begin
CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk_out1   => clk25MHz, 
                                   reset   => rst,
                                   locked  => locked_pll,
                                   clk_in1 => clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz;



VGA_DRIVER: vga_640x480 
                     generic map (
                                  hpixels => strip_hpixels,
                                  vlines  => strip_vlines,
                                  hbp     => strip_hbp,
                                  hfp     => strip_hfp,
                                  vbp     => strip_vbp,
                                  vfp     => strip_vfp
                        
                                  )   
                     port map (
                               clk   => steady_clk25MHz,
                               clr   => rst,
                               hsync => hsync,
                               vsync => vsync,
                               hc    => hc, 
                               vc    => vc, 
                               vidon => video_on
                              );
                              
INIT: vga_initials 
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>32, 
                  H   =>16 
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG,
                   SW        => sw,
                   rom_addr4 => rom_addr4,
                   red       =>  red,
                   green     =>  green,
                   blue      =>  blue
         );
         
--BRAM : blk_mem_gen_0
--  PORT MAP (
--    clka => steady_clk25MHz,
--    ena => '1',
--    wea => "0",
--    addra => rom_addr4,
--    --dina => dina,
--    douta => IMG
--  );
         
PROM: PROM_IMG generic map (
                            DEPTH     => 16 ,
                            DATA_SIZE => 32
                            )
               port map (
                          addr    => rom_addr4,
                          PROM_OP => IMG
                        );         
         

end Behavioral;
