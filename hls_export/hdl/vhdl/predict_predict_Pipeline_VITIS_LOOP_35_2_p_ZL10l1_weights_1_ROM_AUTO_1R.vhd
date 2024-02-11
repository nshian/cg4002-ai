-- ==============================================================
-- Generated by Vitis HLS v2023.2
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity predict_predict_Pipeline_VITIS_LOOP_35_2_p_ZL10l1_weights_1_ROM_AUTO_1R is 
    generic(
             DataWidth     : integer := 16; 
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


architecture rtl of predict_predict_Pipeline_VITIS_LOOP_35_2_p_ZL10l1_weights_1_ROM_AUTO_1R is 
 
signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0);  
signal address1_tmp : std_logic_vector(AddressWidth-1 downto 0); 

type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 

signal mem0 : mem_array := (
    0 => "0110001011110101", 1 => "0011111001000001", 2 => "1111011110001100", 3 => "0011000000001111", 
    4 => "0010010000010010", 5 => "0001000000100010", 6 => "1101110001010011", 7 => "1100001001000101", 
    8 => "0011011011101001", 9 => "1101111010101000", 10 => "1100001111000101", 11 => "1001111100001000", 
    12 => "1011010011111011", 13 => "1111111110111100", 14 => "1110010101010001", 15 => "1111011110000011", 
    16 => "0000010101011011", 17 => "1100001011101000", 18 => "1101010001111000", 19 => "0000010110010011", 
    20 => "1111001010001100", 21 => "1110101110010010", 22 => "0000000110100010", 23 => "0010000110101110", 
    24 => "1101111110111011", 25 => "1111101000101001", 26 => "1101110001101110", 27 => "1011001100001100", 
    28 => "1010100011100001", 29 => "1000100100000011", 30 => "1101000001000001", 31 => "1101001011011110", 
    32 => "1111100011111100", 33 => "0100001111001001", 34 => "1111000001011110", 35 => "1010001010101110", 
    36 => "1100011100000000", 37 => "1011010000001100", 38 => "1111011110000010", 39 => "1111010001110011", 
    40 => "0000001010101101", 41 => "0001010100000100", 42 => "1100110011101001", 43 => "1110001100001110", 
    44 => "0000111100010000", 45 => "1110000000110000", 46 => "1110001101010011", 47 => "1101001001100010", 
    48 => "1111101011011101", 49 => "1101111111011010", 50 => "1101101100010000", 51 => "1111111000011101", 
    52 => "0010101100000011", 53 => "1001101111101001", 54 => "0010101001101110", 55 => "0101000011010111", 
    56 => "0011101001000101", 57 => "0000010111111000", 58 => "0100101000100000", 59 => "1111100001111110", 
    60 => "1111001000110111", 61 => "1110011000101111", 62 => "0001111001010000", 63 => "1101000100111110", 
    64 => "1100011111010100", 65 => "1110101111001110", 66 => "0000101111100011", 67 => "1100010010000100", 
    68 => "0000101001111011", 69 => "1111010000000110", 70 => "1100111011111010", 71 => "1101110010010000", 
    72 => "1111111100000100", 73 => "1101011101100011", 74 => "0000000011010010", 75 => "1111011100000110", 
    76 => "0010010101110000", 77 => "1111111111000010", 78 => "0001110111000011", 79 => "0011010110001001", 
    80 => "1111110110101100", 81 => "0010100000100010", 82 => "0100000001011001", 83 => "1111010111000100", 
    84 => "0100100011110000", 85 => "0010001110101010", 86 => "0000000110011011", 87 => "1111111110100111", 
    88 => "0001010000010101", 89 => "0010011110111011", 90 => "1010111110011111", 91 => "1101001111101010", 
    92 => "0001010010111001", 93 => "1101011111101000", 94 => "1111110010111100", 95 => "1011101101011001", 
    96 => "0000101111000100", 97 => "1101111110000111", 98 => "1110001100100000", 99 => "1111010100111101", 
    100 => "0000110101110001", 101 => "1100100111111101", 102 => "1111110111101011", 103 => "1111111101111101", 
    104 => "0000000001001111", 105 => "1110000100000101", 106 => "1111011110001100", 107 => "0001101000111100", 
    108 => "1110110000011011", 109 => "1101101110100110", 110 => "1111110110101110", 111 => "1110000111110001", 
    112 => "1101101111110100", 113 => "0001011100001111", 114 => "0011111001100111", 115 => "0010000101111100", 
    116 => "1011001010111100", 117 => "1110010010000110", 118 => "1100011100010000", 119 => "1011001010000110", 
    120 => "1100010001000011", 121 => "1100001000010101", 122 => "0000100001011001", 123 => "0000001001001001", 
    124 => "0010100101010001", 125 => "1100111000001100", 126 => "1011110101101010", 127 => "1011100000000101", 
    128 => "1010100111110011", 129 => "1010001110101100", 130 => "1111011111010110", 131 => "1100000111110110", 
    132 => "0001101100111100", 133 => "0011011000110111", 134 => "1101000011011001", 135 => "1101100100100010", 
    136 => "1110110010100011", 137 => "0000111110011000", 138 => "0000100110001111", 139 => "0000000011111111", 
    140 => "1110100101010110", 141 => "1101111111111111", 142 => "1101000111110100", 143 => "0100000100010111", 
    144 => "0101010101100110", 145 => "0001110101101001", 146 => "0010111100100110", 147 => "0011111000111101", 
    148 => "0010111110110110", 149 => "1111011111011000", 150 => "0001011111100100", 151 => "1101111001110101", 
    152 => "0110000101010110", 153 => "0001010111011100", 154 => "1100111001010101", 155 => "1110111001111101", 
    156 => "1101011000100000", 157 => "1111110101001100", 158 => "0001001010001110", 159 => "1101101010100000", 
    160 => "1100100010100111", 161 => "1111101011111101", 162 => "0010011100001010", 163 => "0011101001011110", 
    164 => "1111011000011111", 165 => "0010110100111100", 166 => "0001011010111001", 167 => "0000000011100100", 
    168 => "0000010011011100", 169 => "1110100010000000", 170 => "0011001110010011", 171 => "0110011011011000", 
    172 => "0010011110110110", 173 => "0101011011000001", 174 => "0100111000110010", 175 => "0000100111111111", 
    176 => "1111100100111100", 177 => "1111111001000110", 178 => "1100101100111000", 179 => "0000101000011010", 
    180 => "0101100101010000", 181 => "0100111101111000", 182 => "1111111011001100", 183 => "0101001001110111", 
    184 => "0000111111001011", 185 => "0010011110110000", 186 => "1101010010111101", 187 => "0000110000010001", 
    188 => "0100011000101110", 189 => "0000010011101011", 190 => "1110011001100001", 191 => "0000100010101111", 
    192 => "0001101011001011", 193 => "1101110111101011", 194 => "1111010000100100", 195 => "1101111110110111", 
    196 => "1100011001010001", 197 => "0011100001111000", 198 => "0000110010011001", 199 => "0010011101101010", 
    200 => "0010000110010000", 201 => "1110101111111000", 202 => "1101011010110110", 203 => "1110011001001110", 
    204 => "0000101111011111", 205 => "0001000011001000", 206 => "0011000100000000", 207 => "0010111111010011", 
    208 => "0010110100100011", 209 => "0010010101110100", 210 => "0001000010111100", 211 => "0010001011011101", 
    212 => "0010101011101001", 213 => "1111011101110101", 214 => "1111110101101101", 215 => "0001100000000111", 
    216 => "0110100001110111", 217 => "0010000110010011", 218 => "0000011110001010", 219 => "0010101001101000", 
    220 => "0010100001100111", 221 => "0010111100100100", 222 => "0000001001110101", 223 => "1111110000000001", 
    224 => "0010111001011001", 225 => "0100100011000001", 226 => "0011111000101100", 227 => "1111110100010011", 
    228 => "0101000101111001", 229 => "0100011010101010", 230 => "0010101110111000", 231 => "1101010100011100", 
    232 => "1110011100010110", 233 => "0011000101110011", 234 => "0101011100100011", 235 => "0011100101110111", 
    236 => "0010111111111000", 237 => "0100111000111010", 238 => "0100100000011011", 239 => "0001000111110011", 
    240 => "1111110100110001", 241 => "0010011000010011", 242 => "0011101000000010", 243 => "1101111111110111", 
    244 => "0000101100110100", 245 => "1101111101011111", 246 => "1110101100010101", 247 => "1110011011101101", 
    248 => "1110101101001110", 249 => "1111010000111011", 250 => "1101110010100011", 251 => "1111110000111101", 
    252 => "0001000010000111", 253 => "0000111110010010", 254 => "0001110001100001", 255 => "1111010101101101", 
    256 => "1111010011111011", 257 => "1110101100110011", 258 => "1100111010101110", 259 => "1101100110111010", 
    260 => "0000100100111100", 261 => "1010100011110010", 262 => "1011011000011011", 263 => "1011000110111101", 
    264 => "1100101100100001", 265 => "0000001011001010", 266 => "0000100010001100", 267 => "0011001001010111", 
    268 => "0010000110000011", 269 => "1110101001011110", 270 => "1010111011001110", 271 => "1110100100010101", 
    272 => "1011001011111100", 273 => "1101110101000000", 274 => "0000001011001110", 275 => "1111011000000111", 
    276 => "0011100000000100", 277 => "0010110001111110", 278 => "1110010001000010", 279 => "0001000010100001", 
    280 => "1100110111000011", 281 => "1100011110100001", 282 => "1111111100101100", 283 => "1100100011000010", 
    284 => "0001011110101110", 285 => "1110101011101010", 286 => "1101110110100110", 287 => "0001011110010011");



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

