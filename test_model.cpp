#include <iostream>
#include "hls_stream.h"
#include "model.h"

#define NUM_SAMPLES 3

hls::stream<ap_axis<32,2,5,6>> input_stream;
hls::stream<ap_axis<32,2,5,6>> output_stream;

const float inputs[NUM_SAMPLES][INPUT_SIZE] = {
    {
        -0.6597,  1.4905,  1.1292, -0.8895,  0.0495,  1.4024, -0.0539,  1.2648,
        0.4714,  0.2248, -1.1441,  0.6872, -0.2166,  0.3822,  0.0839, -0.3841,
        -0.3065,  0.3401, -0.1535,  2.7359,  2.9191,  0.3071, -0.8620,  1.6928,
        -0.0325,  1.4258,  1.3051, -0.0915,  0.2707,  1.1326, -0.1174,  3.6341,
        5.0856, -0.1085, -0.6930,  2.2342
    },
    {
        -0.2370,  0.0952,  0.0066,  0.0844, -0.2791,  0.2567, -1.0134,  0.3572,
         0.0380,  0.2207, -1.1719,  0.9948, -0.2502,  0.1086,  0.0074, -0.1148,
        -0.8330,  0.2585,  0.0729,  1.8080,  1.1800,  0.0373, -1.0033,  1.0836,
         0.1388,  0.9615,  0.8721, -1.2849,  2.7091,  0.9257, -0.0154,  1.4992,
         0.9894, -0.3096, -0.6002,  0.9904
    },
    {
        -0.8002,  1.5165,  1.3595, -0.7871, -0.2717,  1.5323,  0.1059,  0.9780,
         0.3564,  0.3691, -0.4444,  0.6018, -0.1098,  0.3516,  0.0638,  0.3766,
         1.4343,  0.2568,  0.1688,  3.3041,  2.6861, -0.0934, -1.3690,  1.6253,
        -0.2851,  1.5648,  1.3183,  0.0804, -0.3086,  1.1816, -0.2178,  2.3242,
         3.2745,  0.2481, -0.2331,  1.7938
    }
};

const int truth[NUM_SAMPLES] = {1, 0, 1};

int main() {
	ap_axis<32,2,5,6> in, out;
    for (int i = 0; i < NUM_SAMPLES; i++) {
        for (int j = 0; j < INPUT_SIZE; j++) {
        	in.data = inputs[i][j];
			in.keep = 1;
			in.strb = 1;
            in.last = (j == INPUT_SIZE - 1) ? 1 : 0;
            input_stream.write(in);
        }
        predict(input_stream, output_stream);
        output_stream.read(out);
        int pred = out.data;
        printf("Ground truth: %d, predicted: %d\n", truth[i], pred);
    }
}
