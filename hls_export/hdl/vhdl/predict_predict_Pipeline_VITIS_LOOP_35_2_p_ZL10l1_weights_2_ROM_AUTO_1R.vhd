-- ==============================================================
-- Generated by Vitis HLS v2023.2
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity predict_predict_Pipeline_VITIS_LOOP_35_2_p_ZL10l1_weights_2_ROM_AUTO_1R is 
    generic(
             DataWidth     : integer := 17; 
             AddressWidth     : integer := 9; 
             AddressRange    : integer := 288
    ); 
    port (
 
          address0        : in std_logic_vector(AddressWidth-1 downto 0); 
          ce0             : in std_logic; 
          q0              : out std_logic_vector(DataWidth-1 downto 0);
 
          address1        : in std_logic_vector(AddressWidth-1 downto 0); 
          ce1             : in std_logic; 
          q1              : out std_logic_vector(DataWidth-1 downto 0);

          reset               : in std_logic;
          clk                 : in std_logic
    ); 
end entity; 


architecture rtl of predict_predict_Pipeline_VITIS_LOOP_35_2_p_ZL10l1_weights_2_ROM_AUTO_1R is 
 
signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0);  
signal address1_tmp : std_logic_vector(AddressWidth-1 downto 0); 

type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 

signal mem0 : mem_array := (
    0 => "00100010111100011", 1 => "00011111000100000", 2 => "00000011010110100", 3 => "00101101011111111", 
    4 => "00000000010100110", 5 => "00000100101111101", 6 => "11110111100100100", 7 => "00001101110111011", 
    8 => "00000010100000101", 9 => "11011111010000101", 10 => "11100101111000011", 11 => "00001000010101101", 
    12 => "11001001011111011", 13 => "00001101111101010", 14 => "00000110001100001", 15 => "00000110001011000", 
    16 => "00100010100011110", 17 => "00010001010000111", 18 => "11101010011000001", 19 => "00010000011010011", 
    20 => "00000100111101110", 21 => "00001011011110101", 22 => "00000001001100010", 23 => "11111001110101001", 
    24 => "11110000101001100", 25 => "11110111111001010", 26 => "11110110111100010", 27 => "11110001001010110", 
    28 => "10110100111010010", 29 => "11100001001101000", 30 => "11011011111010110", 31 => "11110000001111110", 
    32 => "00001001101001111", 33 => "11111100111001001", 34 => "00010001011100001", 35 => "00011010010011111", 
    36 => "11011100110111111", 37 => "11110100100010010", 38 => "00110001111011101", 39 => "11101001111110100", 
    40 => "11111111110010101", 41 => "11110111101010011", 42 => "11100001000111111", 43 => "11101110111000101", 
    44 => "00001000001001111", 45 => "11011100101100011", 46 => "11001100001001101", 47 => "11111001001111100", 
    48 => "11010101101100100", 49 => "00001000011010110", 50 => "00000000101101011", 51 => "11110111100000100", 
    52 => "00110100001111101", 53 => "00000000000101011", 54 => "00101001000010001", 55 => "00010110001101111", 
    56 => "00001010011011010", 57 => "00001111101111101", 58 => "00011000100011011", 59 => "11110010011001101", 
    60 => "00000100110100001", 61 => "11101010010101010", 62 => "11111101110001001", 63 => "11101010110100110", 
    64 => "00000001000000010", 65 => "00011101000001010", 66 => "11110101000100101", 67 => "00000001110010110", 
    68 => "00011111100101010", 69 => "11111110101001111", 70 => "00000010010101100", 71 => "11110101010010110", 
    72 => "11111111101000001", 73 => "11110100011101111", 74 => "11110101001011011", 75 => "11110111100101000", 
    76 => "00001000101001111", 77 => "00001010111011110", 78 => "00010010001001101", 79 => "11111001100011110", 
    80 => "00001011111101010", 81 => "00100011010101111", 82 => "01000111100010010", 83 => "11111011000111011", 
    84 => "00011101100000101", 85 => "00000000101010111", 86 => "00011010001100010", 87 => "00001011100110101", 
    88 => "11100000011001100", 89 => "11101110101010001", 90 => "11001101001010101", 91 => "11011111110101111", 
    92 => "01000000110111000", 93 => "11011100111010011", 94 => "00011101110010010", 95 => "00000101110000100", 
    96 => "11011011001101101", 97 => "11101000100111010", 98 => "00010001101110111", 99 => "11111110101000100", 
    100 => "11111010000000111", 101 => "11110011101000001", 102 => "11110010000110101", 103 => "00010110111001010", 
    104 => "11111001011110010", 105 => "11101000010100100", 106 => "00000011111101111", 107 => "00010001101111101", 
    108 => "11001010011011011", 109 => "11000101101010010", 110 => "11110110111001001", 111 => "11011001111110001", 
    112 => "00000101110100010", 113 => "11111010010000001", 114 => "00000100111011001", 115 => "00010010011011100", 
    116 => "11101010111011100", 117 => "11101110000001110", 118 => "11000101111011000", 119 => "00000100101111001", 
    120 => "11010111110110010", 121 => "00011011100110101", 122 => "11111110111111100", 123 => "11111000000011101", 
    124 => "11111010010010010", 125 => "11111110111001111", 126 => "10111111111011100", 127 => "11001110110001011", 
    128 => "11110111101110100", 129 => "11100101111101110", 130 => "00001001011010001", 131 => "11111101101110101", 
    132 => "00000010100010111", 133 => "00101010000001111", 134 => "11101111100101001", 135 => "11100010011101011", 
    136 => "11111000110100010", 137 => "00010001000001000", 138 => "11110100011100001", 139 => "00100001011010000", 
    140 => "00000010011110010", 141 => "11101000111001011", 142 => "11110000100010101", 143 => "00001101001101100", 
    144 => "00011101010100010", 145 => "00101111111111110", 146 => "11100011100011101", 147 => "00110000000010101", 
    148 => "11110011101110011", 149 => "00001111101101101", 150 => "11110101001010111", 151 => "11010101110000100", 
    152 => "00000010100100001", 153 => "11111111110111000", 154 => "00000000100100000", 155 => "11110101111110010", 
    156 => "11110101101011011", 157 => "11111001100101001", 158 => "00000001110110110", 159 => "11100101101000100", 
    160 => "00001010111100001", 161 => "00001110101001010", 162 => "00110100001001001", 163 => "00101100010010011", 
    164 => "11110011010001100", 165 => "00000111100010010", 166 => "00001111000010011", 167 => "00001011110000011", 
    168 => "11110010011000000", 169 => "11100010011101101", 170 => "11111011100001111", 171 => "00010011011110110", 
    172 => "00101001111000001", 173 => "00001100000101101", 174 => "00010011111001101", 175 => "11110011101001011", 
    176 => "00010001011111111", 177 => "00000000100111000", 178 => "11111010110000111", 179 => "11111110101110001", 
    180 => "00110101100010101", 181 => "00111101011101101", 182 => "00000111111001100", 183 => "00111101000100011", 
    184 => "00000111000010111", 185 => "00010010011001010", 186 => "00001111010011010", 187 => "11101111110010110", 
    188 => "00010010010110100", 189 => "11101001100101011", 190 => "00000001111010100", 191 => "00001101010110101", 
    192 => "00000000011101111", 193 => "00000100011101110", 194 => "00001001110011101", 195 => "11111101110111010", 
    196 => "00010010110110100", 197 => "11111110000010011", 198 => "00101010000001010", 199 => "00001111010110010", 
    200 => "11111110110111000", 201 => "00010101110010011", 202 => "00000100010010110", 203 => "00011001111100010", 
    204 => "11110111011110001", 205 => "11010111110100011", 206 => "00011010101101110", 207 => "00110010101001100", 
    208 => "00011010000011011", 209 => "00001101100011001", 210 => "00011000010100000", 211 => "00010000100110110", 
    212 => "00010100110010000", 213 => "11110101101100110", 214 => "11110111100011111", 215 => "00010111010101101", 
    216 => "00111100110101011", 217 => "00111101101111110", 218 => "11101000010111101", 219 => "00110000010101111", 
    220 => "11111101110111001", 221 => "00010111000110010", 222 => "00001000110011110", 223 => "11111100100010001", 
    224 => "11111010101010000", 225 => "00111001101000000", 226 => "00010110100100011", 227 => "11101000100010101", 
    228 => "00111111110111111", 229 => "11101011100111010", 230 => "00000100110001001", 231 => "00000001011110000", 
    232 => "00001000110111101", 233 => "11110010110010111", 234 => "00101101011000001", 235 => "00011100010001011", 
    236 => "11110000000001110", 237 => "00011110011010011", 238 => "00010101000111010", 239 => "00010110101010011", 
    240 => "11111000010001000", 241 => "11110100101010000", 242 => "00000101011000111", 243 => "00001010100000011", 
    244 => "00011011111101111", 245 => "00010001111110001", 246 => "11101001100110001", 247 => "11110110011001010", 
    248 => "00011000111011000", 249 => "11110110101011001", 250 => "11111100101011110", 251 => "00000000111010011", 
    252 => "00011000001111010", 253 => "00011101011000100", 254 => "00000101010101110", 255 => "00000011101010011", 
    256 => "00001101011110011", 257 => "00001100111011101", 258 => "11111011011011011", 259 => "11111010100101000", 
    260 => "00001010001111111", 261 => "11010110000101001", 262 => "11010011111100110", 263 => "00001101111100011", 
    264 => "11011011110001011", 265 => "00011000110001011", 266 => "11101011110101011", 267 => "00001011111100001", 
    268 => "00011011111101111", 269 => "11100011111010010", 270 => "11001000001110000", 271 => "11011000111110111", 
    272 => "00001100011011000", 273 => "11100110011010001", 274 => "00010000101010011", 275 => "11100011001111010", 
    276 => "00000111101100100", 277 => "11111100010111000", 278 => "11110001111010111", 279 => "00000101000101001", 
    280 => "00001000011111010", 281 => "00010001001110000", 282 => "11110011001010001", 283 => "00011100101111110", 
    284 => "11111000111001100", 285 => "11111101001110100", 286 => "11111101001100101", 287 => "11110101101001101");



begin 

 
memory_access_guard_0: process (address0) 
begin
      address0_tmp <= address0;
--synthesis translate_off
      if (CONV_INTEGER(address0) > AddressRange-1) then
           address0_tmp <= (others => '0');
      else 
           address0_tmp <= address0;
      end if;
--synthesis translate_on
end process;
 
memory_access_guard_1: process (address1) 
begin
      address1_tmp <= address1;
--synthesis translate_off
      if (CONV_INTEGER(address1) > AddressRange-1) then
           address1_tmp <= (others => '0');
      else 
           address1_tmp <= address1;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
 
        if (ce0 = '1') then  
            q0 <= mem0(CONV_INTEGER(address0_tmp)); 
        end if;
 
        if (ce1 = '1') then  
            q1 <= mem0(CONV_INTEGER(address1_tmp)); 
        end if;

end if;
end process;

end rtl;

