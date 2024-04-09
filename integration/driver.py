from pynq import Overlay, allocate
import numpy as np
from statistics import median, variance
from scipy.stats import iqr, skew, kurtosis
from math import sqrt
import json
import time
# import pandas as pd # throws error on ultra96 due to some missing file in cache

INPUT_SIZE = 36
NUM_COLS = 6

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
        self.ol = Overlay('/home/xilinx/ai/handonly.bit')
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
        Takes in a 2D list (25 x 6) of floats where each row represents a time step and each col is one of 6 raw sensor readings.
        Engineers 6 features per raw sensor reading.
        Returns a list of 36 floats for input to NN model.
        '''
        features = []
        # SMALL_NON_ZERO_VALUE = 1e-2
        for col in range(NUM_COLS):
            column_values = [row[col] for row in raw_input]
            # # some actions do not require leg movement, resulting in zero variance. replace zero variance with small value.
            # if col >= 6: # leg columns
            #     var = variance(column_values)
            #     if var == 0:
            #         column_values += np.random.normal(scale=SMALL_NON_ZERO_VALUE, size=len(column_values))
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
