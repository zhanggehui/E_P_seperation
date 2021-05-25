import numpy as np
from scipy import spatial
import math

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
        self.x = 210
        self.grid = np.zeros(shape=(self.x, self.x))
        self.v_grid = np.zeros(shape=(self.x, self.x))
        self.__prepare()

    def __prepare(self):
        rows = self.df['atomName'] == 'OW'
        self.ow_points = np.array(self.df.loc[rows][['x', 'y', 'z']])
        self.ow_vels = np.array(self.df.loc[rows][['vx', 'vy', 'vz']])
        self.tree = spatial.KDTree(self.ow_points)

    def analyze_theta(self):
        rows = self.df['atomName'] == self.center
        ion_points = np.array(self.df.loc[rows][['x', 'y', 'z']])
        count = 0
        radius = first_shell[self.center]
        radius=1
        for results in self.tree.query_ball_point(ion_points, radius):
            nearby_points = np.array(self.ow_points[results])
            nearby_points_vels = np.array(self.ow_vels[results])
            vectors = nearby_points - ion_points[count]
            if self.ori == 'phix':
                axis = np.array([1, 0, 0])
            elif self.ori == 'phiy':
                axis = np.array([0, 1, 0])
            else:  # self.ori == 'theta':
                axis = np.array([0, 0, 1])

            count_vel=0
            for vector in vectors:
                vel=nearby_points_vels[count_vel]
                if self.ori != 'theta':
                    vector[2] = 0
                self.angle_list.append(cal_angle_in_deg(vector, axis))
                n1 = math.floor(vector[0] / 0.01 + self.x / 2)
                n2 = math.floor(vector[1] / 0.01 + self.x / 2)
                self.grid[n1, n2] = self.grid[n1, n2] + 1
                self.v_grid[n1, n2] = self.v_grid[n1, n2] + vel[1]
                count_vel=count_vel+1
            count = count + 1

        return self.angle_list, self.grid, self.v_grid


def cal_angle(a, b):
    a_norm = np.linalg.norm(a)
    b_norm = np.linalg.norm(b)
    a_dot_b = np.dot(a, b)
    return np.arccos(a_dot_b / (a_norm * b_norm))


def cal_angle_in_deg(a, b):
    return np.rad2deg(cal_angle(a, b))
