import numpy as np

def cal_angle(a, b):
    a_norm = np.linalg.norm(a)
    b_norm = np.linalg.norm(b)
    a_dot_b = np.dot(a, b)
    return np.arccos(a_dot_b / (a_norm * b_norm))


def cal_angle_in_deg(a, b):
    return np.rad2deg(cal_angle(a, b))
