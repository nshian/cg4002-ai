from pynq import Overlay, allocate
import numpy as np
from statistics import median, variance
from scipy.stats import iqr, skew, kurtosis
from math import sqrt
import json
import time
# import pandas as pd # throws error on ultra96 due to some missing file in cache

INPUT_SIZE = 72
NUM_COLS = 12

# overlay = Overlay('/home/xilinx/ai/design_1.bit') # does not divide by 65536.0
# overlay = Overlay('/home/xilinx/ai/integration.bit')
# dma = overlay.axi_dma_0
# nn = overlay.predict_0
# nn.write(0x00, 0x81) # start and auto restart
# dma_send = dma.sendchannel
# dma_recv = dma.recvchannel
# input_stream = allocate(shape=(INPUT_SIZE, ), dtype='int32')
# output_stream = allocate(shape=(1, ), dtype='int32')


class ActionClassifier():
    def __init__(self):
        self.ol = Overlay('/home/xilinx/ai/newlogout.bit')
        self.dma = self.ol.axi_dma_0
        self.nn = self.ol.predict_0
        self.nn.write(0x00, 0x81) # start and auto restart
        self.dma_send = self.dma.sendchannel
        self.dma_recv = self.dma.recvchannel
        self.input_stream = allocate(shape=(INPUT_SIZE, ), dtype='int32')
        self.output_stream = allocate(shape=(1, ), dtype='int32')
        
        self.hacky_start_nn()


    def hacky_start_nn(self):
        with open('/home/xilinx/ai/first10toresetnn.json', ) as reset_json:
            data = json.load(reset_json)
        dummy = [d['x'] for d in data]
        for x in dummy:
            self.predict(x)

    
    def process_data(self, raw_input):
        '''
        Takes in a 2D list (25 x 12) of floats where each row represents a time step and each col is one of 12 raw sensor readings.
        Engineers 6 features per raw sensor reading.
        Returns a list of 72 floats for input to NN model.
        '''
        features = []
        SMALL_NON_ZERO_VALUE = 1e-2
        for col in range(NUM_COLS):
            column_values = [row[col] for row in raw_input]
            # some actions do not require leg movement, resulting in zero variance. replace zero variance with small value.
            if col >= 6: # leg columns
                var = variance(column_values)
                if var == 0:
                    column_values += np.random.normal(scale=SMALL_NON_ZERO_VALUE, size=len(column_values))
            features.append(median(column_values))
            features.append(iqr(column_values))
            features.append(variance(column_values))
            features.append(skew(column_values))
            features.append(kurtosis(column_values))
            features.append(sqrt(sum(x**2 for x in column_values) / len(column_values)))
        features = np.array(features)
        features = (features * (2 ** 16)).astype(np.int32)
        return features


    def predict(self, input_data):
        # assumes features generated and already scaled by 65536
        for i in range(INPUT_SIZE):
            self.input_stream[i] = input_data[i]
        self.dma_send.transfer(self.input_stream)
        self.dma_recv.transfer(self.output_stream)
        self.dma_send.wait()
        self.dma_recv.wait()
        action = self.output_stream[0]
        return action


    def get_prediction(self, raw_input):
        features = self.process_data(raw_input)
        pred = self.predict(features)
        return pred


    # def test_performance_raw(self):
    #     print("TESTING MODEL ON RAW DATA")
    #     with open('/home/xilinx/ai/raw_test_data.json', ) as test_data_json:
    #         labelled_test_data = json.load(test_data_json)
    #     x_test = np.array([d['x'] for d in labelled_test_data])
    #     y_test = np.array([d['y'] for d in labelled_test_data])
    #     wrong_preds = []
    #     start_time = time.time()
    #     for idx, x in enumerate(x_test):
    #         if idx % 100 == 0:
    #             print(f"Example {idx} reached")
    #         pred = self.get_prediction(x)
    #         if pred != y_test[idx]:
    #             wrong_preds.append({'idx': idx, 'truth': y_test[idx], 'pred': pred})
    #     end_time = time.time()
    #     execution_time = end_time - start_time
    #     print("Execution time:", execution_time, "seconds")
    #     print(f"Accuracy: {100.0 * (len(x_test) - len(wrong_preds))/len(x_test)}%")
    #     print(f"No. of wrong predictions: {len(wrong_preds)} out of {len(x_test)}")


    def test_performance_augmented(self):
        print("TESTING MODEL ON AUGMENTED DATA")
        with open('/home/xilinx/ai/test_data.json', ) as test_data_json:
            labelled_test_data = json.load(test_data_json)
        x_test = np.array([d['x'] for d in labelled_test_data])
        x_test = (x_test * (2 ** 16)).astype(np.int32)
        y_test = np.array([d['y'] for d in labelled_test_data])
        wrong_preds = []
        start_time = time.time()
        for idx, x in enumerate(x_test):
            pred = self.predict(x)
            if pred != y_test[idx]:
                wrong_preds.append({'idx': idx, 'truth': y_test[idx], 'pred': pred})
        end_time = time.time()
        execution_time = end_time - start_time
        print("Execution time:", execution_time, "seconds")
        print(f"Accuracy: {100.0 * (len(x_test) - len(wrong_preds))/len(x_test)}%")
        print(f"No. of wrong predictions: {len(wrong_preds)} out of {len(x_test)}")
        # print("Wrong predictions:", wrong_preds)
        # random_to_valid = [d for d in wrong_preds if d['truth'] == 5]
        # random_to_shield = [d for d in wrong_preds if d['truth'] == 5 and d['pred'] == 8]
        # valid_to_random = [d for d in wrong_preds if d['pred'] == 5]
        # print("No. of random -> valid:", len(random_to_valid))
        # print("Random actions -> valid:", random_to_valid)
        # print("No. of random -> shield:", len(random_to_shield))
        # print("No. of valid -> random:", len(valid_to_random))
        # print("Valid actions -> random:", valid_to_random)


if __name__ == "__main__":
    clf = ActionClassifier()
    clf.test_performance_augmented()
    # clf.test_performance_raw()
    # raw_input = [ # capt america
    #     [-0.838, -9.325, -8.511, 0.0, 0.0, 0.0, -0.25, -9.531, -11.736, 0.0, 0.0, 0.0],
    #     [-0.742, -9.33, -8.404, 0.0, 0.0, 0.0, -0.325, -9.536, -11.681, 0.0, 0.0, 0.0],
    #     [-0.771, -9.343, -8.342, 0.0, 0.0, 0.0, -0.283, -9.547, -11.702, 0.0, 0.0, 0.0],
    #     [-0.842, -9.37, -8.439, 0.0, 0.0, 0.0, -0.257, -9.529, -11.739, 0.0, 0.0, 0.0],
    #     [-0.871, -9.42, -8.323, 0.0, 0.0, 0.0, -0.264, -9.534, -11.71, 0.0, 0.0, 0.0],
    #     [-0.967, -9.279, -8.363, 0.0, 0.0, 0.0, -0.28, -9.521, -11.683, 0.0, 0.0, 0.0],
    #     [-1.087, -9.218, -8.404, 0.0, -0.19, 0.0, -0.325, -9.476, -11.572, 0.0, 0.0, 0.0],
    #     [-1.147, -9.47, -8.167, 0.157, -0.117, 0.0, -0.27, -9.759, -11.806, 0.162, 0.0, 0.0],
    #     [-1.342, -9.419, -8.675, 0.301, 0.257, 0.0, -0.551, -10.094, -12.607, 0.592, 0.141, -0.517],
    #     [-1.784, -9.11, -8.167, 0.0, 0.0, 0.165, 1.485, -16.141, -12.495, 1.483, 0.0, -1.527],
    #     [-1.295, -9.518, -8.072, 0.0, 0.0, 0.0, -1.891, -12.467, -14.736, 1.789, -0.312, -1.679],
    #     [-6.468, -7.894, -6.201, 0.482, 1.604, -0.669, -5.631, 0.178, -12.105, -0.432, 0.0, 0.527],
    #     [-20.381, -17.024, -7.999, -0.132, 4.375, 1.081, -2.79, -3.983, -10.901, -2.173, -0.299, 2.539],
    #     [-20.381, -19.298, -8.173, -4.294, 3.24, 4.357, 0.313, -15.908, -7.857, -2.158, -1.865, 3.37],
    #     [-18.744, -19.298, -9.188, -4.294, 0.356, 4.357, 12.883, -9.239, -15.042, -0.331, -2.573, 0.617],
    #     [-1.208, -19.298, -6.798, -0.425, -4.355, 4.357, -1.272, -10.374, -6.572, 0.0, -0.224, -1.339],
    #     [18.844, -19.298, -19.482, 4.436, -1.778, 4.357, 0.301, -8.109, -11.495, 0.382, 1.803, 0.0],
    #     [18.844, -19.298, -30.719, -0.866, -4.355, -4.373, -0.245, -9.201, -12.731, 0.0, 0.0, -0.137],
    #     [-4.208, -19.298, -21.97, 2.87, -0.42, -4.373, -1.994, -9.461, -11.693, 0.0, -0.195, 0.254],
    #     [2.637, -19.298, -30.895, -4.294, -4.046, -4.373, -2.62, -9.53, -11.994, 0.0, -0.342, 0.193],
    #     [0.399, -19.298, 3.356, -4.294, -4.355, 4.357, -1.984, -9.141, -11.52, 0.0, -0.21, 0.108],
    #     [18.844, -19.298, 4.138, -3.591, -4.355, 4.357, -2.363, -9.552, -11.706, -0.174, -0.106, 0.0],
    #     [18.844, -19.298, -8.992, 1.42, -2.67, 0.549, -2.647, -9.254, -12.579, 0.0, -0.206, -0.159],
    #     [18.844, -19.298, -9.607, 0.178, 1.645, -4.373, -1.149, -8.847, -12.03, 0.0, 0.22, 0.0],
    #     [18.844, -19.298, -10.33, -2.054, 4.375, -4.373, -2.477, -9.469, -11.401, 0.0, 0.25, 0.0]
    # ]
    # pred = clf.get_prediction(raw_input)
    # print(f"Prediction is {pred}")
