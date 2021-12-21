import argparse
import md_analyze as ma
import md_utils as mu
import numpy as np

first_shell = {
    "LI": 0.274,
    "NA": 0.322,
    "K": 0.354,
    "CS": 0.394
}


class AnalyzeAngle(ma.MdAnalyze):
    def __init__(self, ingro, seltype, reftype, angletype):
        ma.MdAnalyze.__init__(self, ingro)
        self.seltype = seltype
        self.reftype = reftype
        self.radius = first_shell[self.reftype]
        self.angletype = angletype
        self.angle_list = []

    def analyze_frame(self, df):
        count = 0
        
        mf = ma.MdFrame(df, self.seltype, self.reftype, self.radius)
        for results in mf.results_set:
            nearby_points = np.array(mf.sel_points[results])
            vectors = nearby_points - mf.ref_points[count]

            if self.angletype == 'phix':
                axis = np.array([1, 0, 0])
            elif self.angletype == 'phiy':
                axis = np.array([0, 1, 0])
            else:  # self.angletype == 'theta':
                axis = np.array([0, 0, 1])

            for vector in vectors:
                if self.angletype != 'theta':
                    vector[2] = 0
                self.angle_list.append(mu.cal_angle_in_deg(vector, axis))
            count = count + 1

    def write_output(self):
        n, bins = np.histogram(self.angle_list, bins=180, range=[0, 180])
        bins = bins[0: len(bins) - 1]
        arr = np.vstack([bins, n]).T
        np.savetxt(self.angletype + '.csv', arr, fmt='%g', delimiter=',')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-ingro", type=str, default='a.gro')
    parser.add_argument("-seltype", type=str, default='OW')
    parser.add_argument("-reftype", type=str, default='NA')
    parser.add_argument("-angletype", type=str, default='theta')
    args = parser.parse_args()
    AnalyzeAngle(args.ingro, args.seltype, args.reftype, args.angletype).analyze()
