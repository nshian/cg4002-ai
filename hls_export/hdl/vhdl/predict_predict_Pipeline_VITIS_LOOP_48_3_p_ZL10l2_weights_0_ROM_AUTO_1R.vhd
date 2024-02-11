-- ==============================================================
-- Generated by Vitis HLS v2023.2
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity predict_predict_Pipeline_VITIS_LOOP_48_3_p_ZL10l2_weights_0_ROM_AUTO_1R is 
    generic(
             DataWidth     : integer := 17; 
             AddressWidth     : integer := 8; 
             AddressRange    : integer := 256
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


architecture rtl of predict_predict_Pipeline_VITIS_LOOP_48_3_p_ZL10l2_weights_0_ROM_AUTO_1R is 
 
signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0);  
signal address1_tmp : std_logic_vector(AddressWidth-1 downto 0); 

type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 

signal mem0 : mem_array := (
    0 => "00001110010111001", 1 => "11110000010010000", 2 => "00000101111101011", 3 => "11011111000100011", 
    4 => "00000101010001010", 5 => "00001000100100011", 6 => "00100011111101010", 7 => "00001100001110011", 
    8 => "00100000010101100", 9 => "11010100101000000", 10 => "00001010000010101", 11 => "11111000000011110", 
    12 => "00011100011101110", 13 => "00000111010100001", 14 => "00001001001000100", 15 => "00010100100000110", 
    16 => "00001010110110100", 17 => "11100101011100110", 18 => "11111110000100100", 19 => "11110100100011010", 
    20 => "00100100100101000", 21 => "00010100011110000", 22 => "00001110101100011", 23 => "00010111001011001", 
    24 => "11101011000100111", 25 => "00001011110010110", 26 => "00011101110011001", 27 => "00111001001001100", 
    28 => "11100101001100011", 29 => "11101111010110110", 30 => "11101011011001000", 31 => "00000001011011000", 
    32 => "11111011111010100", 33 => "00010001000010110", 34 => "11100111010111111", 35 => "11101000101000001", 
    36 => "11010111010111111", 37 => "00001001100011010", 38 => "11111110101111101", 39 => "11111010101110111", 
    40 => "00010010101100111", 41 => "11010011010010000", 42 => "00000101110011000", 43 => "11011111001010010", 
    44 => "00000000111000000", 45 => "00011000011000100", 46 => "00110100000100111", 47 => "00000111011011001", 
    48 => "00100110011101111", 49 => "00011011000111001", 50 => "00011000101101101", 51 => "11101111101001000", 
    52 => "00100111111110001", 53 => "00010110001111111", 54 => "00001111001111001", 55 => "11101111111110101", 
    56 => "11100011000011101", 57 => "00000001100000011", 58 => "00000001110010111", 59 => "00100011001110100", 
    60 => "11110111011000001", 61 => "11010100011110000", 62 => "11110101110011011", 63 => "00011001100111100", 
    64 => "11101000000000101", 65 => "11101001100111000", 66 => "11110010111100010", 67 => "00100011000111011", 
    68 => "11111110101101011", 69 => "11100010110110110", 70 => "11101111000111000", 71 => "00011010000100101", 
    72 => "11110100110100011", 73 => "11111100010100000", 74 => "11110111000000110", 75 => "00000001100111101", 
    76 => "11110100000010011", 77 => "11110101110111101", 78 => "11101011111100100", 79 => "00011010001000001", 
    80 => "00011001010111101", 81 => "00010001100100011", 82 => "00000101001111111", 83 => "11111000111000101", 
    84 => "00100001101100110", 85 => "00011111100001011", 86 => "00011111000100001", 87 => "11111001111010100", 
    88 => "00010111000010100", 89 => "11100001001000100", 90 => "11111111001010011", 91 => "11100100110100110", 
    92 => "00010101001100111", 93 => "00001100101100110", 94 => "00011100101111001", 95 => "00000010110110110", 
    96 => "00001110101110100", 97 => "11100101000000111", 98 => "11111001110100010", 99 => "11101001011000100", 
    100 => "00010101101000011", 101 => "00011110010000111", 102 => "00011010111001001", 103 => "11110111110000000", 
    104 => "11111000111110000", 105 => "11101100011110000", 106 => "11110100101011010", 107 => "11011111000010110", 
    108 => "00001011110111000", 109 => "11111111001011110", 110 => "00011111111111001", 111 => "00010001111001011", 
    112 => "00000111010001001", 113 => "00011110101100010", 114 => "00000010010111010", 115 => "11101001010100010", 
    116 => "00010100011110101", 117 => "00011111011110101", 118 => "00100110110111110", 119 => "00000100010000110", 
    120 => "11101101000100110", 121 => "00010001111111101", 122 => "00000100100110010", 123 => "00011110101101101", 
    124 => "11110111101111000", 125 => "11110111100001010", 126 => "11010111111011000", 127 => "00010000110111101", 
    128 => "00000100001111011", 129 => "00000101101101010", 130 => "11111111111101111", 131 => "00010011110100100", 
    132 => "11110000101011010", 133 => "11110011100110101", 134 => "11111011100001010", 135 => "11111110101001100", 
    136 => "00010010010011111", 137 => "00010010110011010", 138 => "00000001000000010", 139 => "11110010100010000", 
    140 => "00100011110110100", 141 => "00010110111110100", 142 => "00001100011011001", 143 => "00010010110000011", 
    144 => "11101100101100101", 145 => "11100000101111111", 146 => "00010101011000101", 147 => "11100010101111111", 
    148 => "00100101110001001", 149 => "00010010111001011", 150 => "00100011111000010", 151 => "11100111101001011", 
    152 => "11111000100011011", 153 => "00010100010001011", 154 => "11100000110111101", 155 => "00001110011100000", 
    156 => "00001010000100000", 157 => "11111110011000000", 158 => "00001001001011000", 159 => "11111001110100111", 
    160 => "00000011000001001", 161 => "11110001011110100", 162 => "11100111010011011", 163 => "11110010010101000", 
    164 => "11110000001000110", 165 => "11011010011100101", 166 => "00001101000101011", 167 => "00010010111001100", 
    168 => "11110100110110100", 169 => "00100011111100001", 170 => "11110101101011000", 171 => "00110000101100011", 
    172 => "00000000110001111", 173 => "11101101001100010", 174 => "11101100110110100", 175 => "00010100110111001", 
    176 => "00000001110111100", 177 => "00000101111100100", 178 => "00011010001011001", 179 => "00110101110100011", 
    180 => "00010010011101110", 181 => "11101011010001001", 182 => "00000010110110011", 183 => "00000111000010111", 
    184 => "00000001111001000", 185 => "11111000001011110", 186 => "00001011010111110", 187 => "11011010010000000", 
    188 => "00100010111101110", 189 => "00100101110001010", 190 => "00010010111000101", 191 => "00011001110111110", 
    192 => "00001001010111010", 193 => "11111011100111111", 194 => "00000111010010110", 195 => "11110010110110010", 
    196 => "00010100001011001", 197 => "00010010000010110", 198 => "00010010001001010", 199 => "00000110011100011", 
    200 => "00010100100101001", 201 => "00000111101000110", 202 => "00010110000101100", 203 => "11110001110010010", 
    204 => "00010110000111001", 205 => "00010100110100001", 206 => "00010010110001000", 207 => "11111110000010011", 
    208 => "00000111110101011", 209 => "00010101001101111", 210 => "00010011101001111", 211 => "00011111011110111", 
    212 => "11011111010011011", 213 => "11100101110101011", 214 => "11100010110010101", 215 => "11111011100111100", 
    216 => "00011100101011101", 217 => "11110011001111001", 218 => "00000100111001110", 219 => "11110101001100100", 
    220 => "00011111101011000", 221 => "00011000010111001", 222 => "11111010101010100", 223 => "00000101110011001", 
    224 => "11100111101010111", 225 => "00011011100111001", 226 => "00011101001111110", 227 => "00100000000110101", 
    228 => "00001000001011001", 229 => "00000110101110011", 230 => "11100101101001101", 231 => "11110111110111001", 
    232 => "11110001100001110", 233 => "00110000011010001", 234 => "00011011000110101", 235 => "00101000000000010", 
    236 => "00001001011100001", 237 => "11101001110011001", 238 => "00000000001011010", 239 => "00000101011101100", 
    240 => "11111101000101111", 241 => "11110011110011110", 242 => "11101110001010101", 243 => "00000100110011100", 
    244 => "11010111011111011", 245 => "11111111110001111", 246 => "11111111000011011", 247 => "11101010111000010", 
    248 => "00000110000000111", 249 => "00011101100011000", 250 => "00001111100100101", 251 => "01101111111110001", 
    252 => "11111101110111100", 253 => "00000111011101110", 254 => "00000100000111001", 255 => "11110011101011110");



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

