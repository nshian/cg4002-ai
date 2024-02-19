from pynq import Overlay, allocate
import numpy as np
from numpy import median, var
from scipy.stats import iqr, skew, kurtosis
import json

INPUT_SIZE = 36
# NUM_CLASSES = 2

overlay = Overlay('/home/xilinx/ai/indiv_test.bit')
print(overlay.ip_dict.keys())
dma = overlay.axi_dma_0
nn = overlay.predict_0
nn.write(0x00, 0x81)
dma_send = dma.sendchannel
dma_recv = dma.recvchannel
input_stream = allocate(shape=(INPUT_SIZE, ), dtype='i4')
output_stream = allocate(shape=(1, ), dtype='i4')

# def prepare_features_xyz(x, y, z):
#     def rms(x):
#         return np.sqrt(np.mean(x**2))
#     x_med, y_med, z_med = median(x), median(y), median(z)
#     x_iqr, y_iqr, z_iqr = iqr(x), iqr(y), iqr(z)
#     x_var, y_var, z_var = var(x), var(y), var(z)
#     x_skew, y_skew, z_skew = skew(x), skew(y), skew(z)
#     x_kur, y_kur, z_kur = kurtosis(x), kurtosis(y), kurtosis(z)
#     x_rms, y_rms, z_rms = rms(x), rms(y), rms(z)
#     return [x_med, y_med, z_med, x_iqr, y_iqr, z_iqr, x_var, y_var, z_var, x_skew, y_skew, z_skew, x_kur, y_kur, z_kur, x_rms, y_rms, z_rms]


# def process_data(raw_input):
#     acc_data_hand, gyro_data_hand = prepare_features_xyz(...), prepare_features_xyz(...)
#     acc_data_leg, gyro_data_leg = prepare_features_xyz(...), prepare_features_xyz(...)
#     return acc_data_hand + gyro_data_hand + acc_data_leg + gyro_data_leg


def predict(input_data):
    for i in range(INPUT_SIZE):
        input_stream[i] = input_data[i]
    # print(input_stream)
    dma_send.transfer(input_stream)
    dma_recv.transfer(output_stream)
    dma_send.wait()
    dma_recv.wait()
    # print("Output stream:", output_stream)
    action = output_stream[0]
    return action


def run_model():
    # FUTURE IMPLEMENTATION: for each example in test data, run process_data() and the output goes into predict()
    print("RUNNING MODEL")
    with open('/home/xilinx/ai/run_or_walk_test_data.json', ) as test_data_json:
        labelled_test_data = json.load(test_data_json)
    x_test = [d['x'] for d in labelled_test_data]
    y_test = [d['y'] for d in labelled_test_data]
    wrong_preds = []
    for idx, x in enumerate(x_test):
        print(f"Example {idx + 1}")
        # print("Start of iteration: dma send running?", dma_send.running)
        # print("Start of iteration: dma rcv running?", dma_recv.running)
        # print("Before predict: dma send idle?", dma_send.idle)
        # print("Before predict: dma recv idle?", dma_recv.idle)
        pred = predict(x)
        print("Pred:", pred)
        print("Ground truth:", y_test[idx])
        # print("After predict: dma send idle?", dma_send.idle)
        # print("After predict: dma recv idle?", dma_recv.idle)
        if pred != y_test[idx]:
            wrong_preds.append({'idx': idx, 'truth': y_test[idx], 'pred': pred})
        # print("End of iteration: dma send running?", dma_send.running)
        # print("End of iteration: dma rcv running?", dma_recv.running)
    print(f"Accuracy: {100.0 * (len(x_test) - len(wrong_preds))/len(x_test)}%")
    print("Wrong predictions:", wrong_preds)

if __name__ == "__main__":
    run_model()
