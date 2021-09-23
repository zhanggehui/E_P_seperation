import argparse
import md_analyze as ma
import numpy as np
import scipy.io as sio
import math

radius = 1.05
girdBinWidth = 0.01
gridLength = int(2 * radius / girdBinWidth)


class DensityMap(ma.MdAnalyze):
    def __init__(self, ingro, seltype, reftype):
        ma.MdAnalyze.__init__(self, ingro)
        self.seltype = seltype
        self.reftype = reftype
        self.n_grid = np.zeros(shape=(gridLength, gridLength))

    def analyze_frame(self, df):
        count = 0
        mf = ma.MdFrame(df, self.seltype, self.reftype, radius)
        for results in mf.results_set:
            nearby_points = np.array(mf.sel_points[results])
            vectors = nearby_points - mf.ref_points[count]

            for vector in vectors:
                n1 = math.floor(vector[0] / girdBinWidth + gridLength / 2)
                n2 = math.floor(vector[1] / girdBinWidth + gridLength / 2)
                self.n_grid[n1, n2] = self.n_grid[n1, n2] + 1
            count = count + 1

    def write_output(self):
        sio.savemat('density.mat', {'n_grid': self.n_grid})


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-ingro", type=str, default='a.gro')
    parser.add_argument("-seltype", type=str, default='OW')
    parser.add_argument("-reftype", type=str, default='NA')
    args = parser.parse_args()
    DensityMap(args.ingro, args.seltype, args.reftype).analyze()
