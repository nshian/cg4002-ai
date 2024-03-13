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
        self.ol = Overlay('/home/xilinx/ai/integration.bit')
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


    def test_performance_raw(self):
        print("TESTING MODEL ON RAW DATA")
        with open('/home/xilinx/ai/raw_test_data.json', ) as test_data_json:
            labelled_test_data = json.load(test_data_json)
        x_test = np.array([d['x'] for d in labelled_test_data])
        y_test = np.array([d['y'] for d in labelled_test_data])
        wrong_preds = []
        start_time = time.time()
        for idx, x in enumerate(x_test):
            if idx % 100 == 0:
                print(f"Example {idx} reached")
            pred = self.get_prediction(x)
            if pred != y_test[idx]:
                wrong_preds.append({'idx': idx, 'truth': y_test[idx], 'pred': pred})
        end_time = time.time()
        execution_time = end_time - start_time
        print("Execution time:", execution_time, "seconds")
        print(f"Accuracy: {100.0 * (len(x_test) - len(wrong_preds))/len(x_test)}%")
        print(f"No. of wrong predictions: {len(wrong_preds)} out of {len(x_test)}")


    def test_performance_augmented(self):
        print("TESTING MODEL ON AUGMENTED DATA")
        with open('/home/xilinx/ai/test_data.json', ) as test_data_json:
        # with open('/home/xilinx/ai/not_working.json', ) as test_data_json:
        # with open('/home/xilinx/ai/working.json', ) as test_data_json:
        # with open('/home/xilinx/ai/idx14to25.json', ) as test_data_json:
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
    # clf.test_performance_augmented()
    clf.test_performance_raw()
    # raw_input = [ # shield
    #     [-0.332,-10.079,-9.49,0.0,-0.968,-1.16,-0.167,-9.729,-11.402,0.0,0.0,0.0],
    #     [-1.287,-10.78,-9.896,0.0,-0.946,-1.35,-0.395,-9.828,-11.4,0.0,0.0,0.0],
    #     [-1.887,-10.951,-9.597,-0.177,0.0,-0.905,-0.515,-9.835,-11.405,0.0,0.0,0.0],
    #     [-1.815,-10.589,-9.774,-0.102,0.0,-0.561,-0.385,-9.783,-11.437,0.0,0.0,0.0],
    #     [-2.186,-10.449,-9.983,-0.123,0.0,-0.298,-0.363,-9.789,-11.387,0.0,0.0,0.0],
    #     [-2.526,-10.702,-10.383,-0.189,-0.232,0.0,-0.214,-9.742,-11.405,0.0,0.0,0.0],
    #     [-5.312,-12.719,-11.047,0.0,-0.94,0.252,-0.208,-9.825,-11.408,0.0,0.0,0.0],
    #     [-6.899,-12.437,-13.399,0.538,-2.756,1.603,-0.388,-9.837,-11.412,0.0,0.0,0.0],
    #     [-7.972,-14.458,-16.73,-1.235,-1.402,3.212,-0.341,-9.748,-11.463,0.0,0.0,0.0],
    #     [-7.489,-16.922,-17.715,-2.441,-3.801,3.841,-0.408,-9.753,-11.474,0.0,0.0,0.0],
    #     [-6.269,-14.852,-16.462,-3.143,-1.493,4.394,-0.345,-9.729,-11.497,0.0,0.0,0.0],
    #     [-2.712,-11.011,-12.658,-3.672,-0.109,4.394,-0.262,-9.772,-11.468,0.0,0.0,0.0],
    #     [0.528,-5.35,-7.48,-2.975,0.0,2.868,-0.239,-9.795,-11.435,0.0,0.0,0.0],
    #     [-2.142,0.789,-5.577,0.309,-1.457,-0.766,-0.231,-9.753,-11.424,0.0,0.0,0.0],
    #     [-10.695,0.448,-12.32,0.473,0.766,-2.442,-0.303,-9.77,-11.522,0.0,0.0,0.0],
    #     [-15.698,-1.065,-16.055,-0.699,0.33,0.188,-0.397,-9.801,-11.479,0.0,0.0,0.0],
    #     [-11.016,-1.867,-5.08,0.447,-0.585,1.063,-0.309,-9.768,-11.455,0.0,0.0,0.0],
    #     [-7.33,0.0,-10.275,-0.152,1.463,1.608,-0.347,-9.792,-11.445,0.0,0.0,0.0],
    #     [-1.567,-1.478,-6.703,0.714,0.205,0.294,-0.275,-9.741,-11.442,0.0,0.0,0.0],
    #     [1.779,-5.273,-6.826,4.074,-0.928,-3.228,-0.306,-9.774,-11.431,0.0,0.0,0.0],
    #     [-1.117,-17.699,-14.027,4.431,-0.477,-4.336,-0.355,-9.865,-11.443,0.0,0.0,0.0],
    #     [2.637,-20.155,-15.161,1.807,-0.432,-4.336,-0.329,-9.7,-11.376,0.0,0.0,0.0],
    #     [-4.252,-20.155,-11.76,-0.188,1.51,-4.336,-0.181,-9.795,-11.295,0.0,0.0,0.0],
    #     [-9.171,-13.416,-12.595,-1.273,-0.378,-1.072,-0.164,-9.76,-11.218,0.0,0.0,0.0],
    #     [1.432,-13.802,-9.216,-1.627,4.171,2.335,-0.102,-9.789,-11.311,0.0,0.0,0.0]
    # ]
    # pred = clf.get_prediction(raw_input)
    # print(f"Prediction is {pred}")
