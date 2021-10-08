import argparse
import numpy as np
import scipy.io as sio
import md_analyze as ma
import md_utils as mu

first_shell = {
    "LI": 0.278,
    "NA": 0.32,
    "K": 0.354,
    "CS": 0.396
}
Dphi=30

class RadDistribution(ma.MdAnalyze):
    def __init__(self, ingro, seltype, reftype):
        ma.MdAnalyze.__init__(self, ingro)
        self.seltype = seltype
        self.reftype = reftype
        self.radius = first_shell[self.reftype]
        self.r_list1 = []
        self.r_list2 = []

    def analyze_frame(self, df):
        count = 0
        cutoff = 2*self.radius
        mf = ma.MdFrame(df, self.seltype, self.reftype, cutoff)
        for results in mf.results_set:
            nearby_points = np.array(mf.sel_points[results])
            vectors = nearby_points - mf.ref_points[count]
            for vector in vectors:
                r = np.linalg.norm(vector)
                vector[2] = 0
                phiy = mu.cal_angle_in_deg(vector, np.array([0, 1, 0]))
                self.add_r(phiy, r)
            count = count + 1

    def add_r(self, phiy, r):
        if not np.isnan(phiy):
            if phiy < Dphi:
                self.r_list1.append(r)
            elif phiy > 180-Dphi:
                self.r_list2.append(r)

    def write_output(self):
        r_list1 = np.array(self.r_list1)
        r_list2 = np.array(self.r_list2)
        sio.savemat('r.mat', {'r_list1': r_list1,
                              'r_list2': r_list2})


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-ingro", type=str, default='a.gro')
    parser.add_argument("-seltype", type=str, default='OW')
    parser.add_argument("-reftype", type=str, default='NA')
    args = parser.parse_args()
    RadDistribution(args.ingro, args.seltype, args.reftype).analyze()
