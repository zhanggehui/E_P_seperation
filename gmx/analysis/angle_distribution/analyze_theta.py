import numpy as np
from scipy import spatial

first_shell = {
    "LI": 0.278,
    "NA": 0.32,
    "K": 0.354,
    "CS": 0.396
}


class Theta:
    def __init__(self, df, center, ori):
        self.df = df
        self.center = center
        self.ori = ori
        self.angle_list = []
        self.__prepare()

    def __prepare(self):
        rows = self.df['atomName'] == 'OW'
        self.ow_points = np.array(self.df.loc[rows][['x', 'y', 'z']])
        self.tree = spatial.KDTree(self.ow_points)

    def analyze_theta(self):
        rows = self.df['atomName'] == self.center
        ion_points = np.array(self.df.loc[rows][['x', 'y', 'z']])
        count = 0
        for results in self.tree.query_ball_point(ion_points, first_shell[self.center]):
            nearby_points = np.array(self.ow_points[results])
            vectors = nearby_points - ion_points[count]
            if self.ori == 'phix':
                axis = np.array([1, 0, 0])
            elif self.ori == 'phiy':
                axis = np.array([0, 1, 0])
            elif self.ori == 'theta':
                axis = np.array([0, 0, 1])
            for vector in vectors:
                if self.ori != 'theta':
                    zaxis=np.array([0, 0, 1])
                    theta=cal_angle(vector, zaxis)
                    vector=vector*np.sin(theta)
                self.angle_list.append(cal_angle_in_deg(vector, axis))
            count = count + 1

        return self.angle_list

def cal_angle(a, b):
    a_norm = np.linalg.norm(a)
    b_norm = np.linalg.norm(b)
    a_dot_b = np.dot(a, b)
    return np.arccos(a_dot_b / (a_norm * b_norm))

def cal_angle_in_deg(a, b):
    return np.rad2deg(cal_angle(a, b))
