import argparse
import md_analyze as ma
import md_utils as mu
import numpy as np
import math
import scipy.io as sio

first_shell = {
    "LI": 0.278,
    "NA": 0.32,
    "K": 0.354,
    "CS": 0.396
}

ns = 100
dtheta = np.pi / ns
dphi = np.pi / ns  # 关于y轴对称，phi只需要[0, pi]


class AnalyzeAngle(ma.MdAnalyze):
    def __init__(self, ingro, seltype, reftype):
        ma.MdAnalyze.__init__(self, ingro)
        self.seltype = seltype
        self.reftype = reftype
        self.r_grid = np.zeros(shape=(ns, ns))
        self.n_grid = np.zeros(shape=(ns, ns))
        self.radius = first_shell[self.reftype]
        self.r_list1 = []
        self.r_list2 = []

    def analyze_frame(self, df):
        count = 0
        cutoff = self.radius
        lowedge = 0   # self.radius
        mf = ma.MdFrame(df, self.seltype, self.reftype, cutoff)
        for results in mf.results_set:
            nearby_points = np.array(mf.sel_points[results])
            vectors = nearby_points - mf.ref_points[count]
            
            for vector in vectors:
                r = np.linalg.norm(vector)
                if  r > lowedge:
                    theta = mu.cal_angle(vector, np.array([0, 0, 1]))
                    vector[2] = 0
                    phiy = mu.cal_angle(vector, np.array([0, 1, 0]))
                    self.add_r(theta, phiy, r)
            count = count + 1

    def add_r(self, theta, phiy, r):
        if not np.isnan(phiy):
            n1 = math.floor(theta / dtheta)
            n2 = math.floor(phiy / dphi)
            if n1 == 30 and n2==30:
                self.r_list1.append(r)
            if n1==70 and n2==70:
                self.r_list2.append(r)
            self.r_grid[n1][n2] = self.r_grid[n1][n2] + r
            self.n_grid[n1][n2] = self.n_grid[n1][n2] + 1
        else:
            self.r_grid[0][:] = self.r_grid[0][:] + r
            self.n_grid[0][:] = self.n_grid[0][:] + 1

    def write_output(self):
        r_list1 = np.array(self.r_list1)
        r_list2 = np.array(self.r_list2)
        try:
            self.r_grid = self.r_grid / self.n_grid
        except:
            print("除零，变为非数值nan")
        sio.savemat('r.mat', {'r_grid': self.r_grid,
                              'r_list1': r_list1,
                              'r_list2': r_list2
                             })


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-ingro", type=str, default='a.gro')
    parser.add_argument("-seltype", type=str, default='OW')
    parser.add_argument("-reftype", type=str, default='NA')
    args = parser.parse_args()
    AnalyzeAngle(args.ingro, args.seltype, args.reftype).analyze()
