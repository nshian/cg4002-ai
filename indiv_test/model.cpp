/*
help:
https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/Arbitrary-Precision-Fixed-Point-Data-Types
https://huggingface.co/docs/optimum/concept_guides/quantization
https://github.com/smosanu/axi_stream_tutorial/blob/master/core.cpp
https://developer.arm.com/documentation/ihi0051/a/Introduction/About-the-AXI4-Stream-protocol
https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/pragma-HLS-interface
https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/Unrolling-Loops
https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/pragma-HLS-dataflow
https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/pragma-HLS-pipeline
*/
#include "hls_stream.h"
#include "model.h"

void predict(hls::stream<ap_axis<32,2,5,6>> &input_stream, hls::stream<ap_axis<32,2,5,6>> &output_stream) {
    #pragma HLS interface mode=axis port=input_stream // AXI4-Stream interface
    #pragma HLS interface mode=axis port=output_stream // AXI4-Stream interface
    #pragma HLS interface mode=s_axilite port=return // AXI4-Lite interface, produces an associated set of C driver files when exporting the generated RT for the HLS component
    ap_axis<32,2,5,6> in, out;

    fixed_pt input_layer[INPUT_SIZE];
    fixed_pt hidden_layer1[HIDDEN_SIZE1];
    fixed_pt hidden_layer2[HIDDEN_SIZE2];
    fixed_pt output_layer[NUM_CLASSES];

    for (unsigned char i = 0; i < INPUT_SIZE; i++) {
        input_stream.read(in);
        input_layer[i] = in.data;
    }

    // Forward passes
    matmul1: for (unsigned char j = 0; j < HIDDEN_SIZE1; j++) { // follow conventional Wij notation
        //#pragma HLS dataflow
    	hidden_layer1[j] = (fixed_pt)0;
        for (unsigned char i = 0; i < INPUT_SIZE; i++) {
		    //#pragma HLS pipeline II=1
		    #pragma HLS unroll factor=8
            hidden_layer1[j] += l1_weights[j][i] * input_layer[i];
        }
        hidden_layer1[j] += l1_bias[j];
        if (hidden_layer1[j] <= 0) // ReLU
            hidden_layer1[j] = (fixed_pt)0;
    }

    matmul2: for (unsigned char j = 0; j < HIDDEN_SIZE2; j++) { // follow conventional Wij notation
        //#pragma HLS dataflow
    	hidden_layer2[j] = (fixed_pt)0;
        for (unsigned char i = 0; i < HIDDEN_SIZE1; i++) {
		    //#pragma HLS pipeline II=1
		    #pragma HLS unroll factor=8
            hidden_layer2[j] += l2_weights[j][i] * hidden_layer1[i];
        }
        hidden_layer2[j] += l2_bias[j];
        if (hidden_layer2[j] <= 0) // ReLU
            hidden_layer2[j] = (fixed_pt)0;
    }

    matmul3: for (unsigned char j = 0; j < NUM_CLASSES; j++) { // follow conventional Wij notation
        //#pragma HLS dataflow
    	output_layer[j] = (fixed_pt)0;
        for (unsigned char i = 0; i < HIDDEN_SIZE2; i++) {
		    //#pragma HLS pipeline II=1
		    #pragma HLS unroll factor=8
            output_layer[j] += l3_weights[j][i] * hidden_layer2[i];
        }
        output_layer[j] += l3_bias[j];
    }

    unsigned char pred = 0;
    fixed_pt max = output_layer[0];
    for (unsigned char i = 1; i < NUM_CLASSES; i++) {
        if (output_layer[i] > max) {
            pred = i;
            max = output_layer[i];
        }
    }
    
    out.data = pred;
    out.keep = 1;
    out.strb = 1;
    out.last = 1;
    output_stream.write(out);
}
