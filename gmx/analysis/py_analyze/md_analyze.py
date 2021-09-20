import pandas as pd
import numpy as np
from scipy import spatial


class MdAnalyze:
    def __init__(self, ingro):
        self.ingro = ingro
        self.df_list = []
        self.__read_gro_file()

    def __read_gro_file(self):
        count = 0
        frame = 0
        atom_name_list = []
        with open(self.ingro, 'r') as f:
            for line in f:
                count = count + 1
                if count == 1:
                    pass
                elif count == 2:
                    if frame == 0:
                        n_atoms = int(line[0:5])
                        x_arry = np.empty(n_atoms, dtype=float)
                        y_arry = np.empty(n_atoms, dtype=float)
                        z_arry = np.empty(n_atoms, dtype=float)
                        v_x_arry = np.empty(n_atoms, dtype=float)
                        v_y_arry = np.empty(n_atoms, dtype=float)
                        v_z_arry = np.empty(n_atoms, dtype=float)
                    if frame % 1000 == 0:
                        print("------ 正在读入第", frame, "帧 ------")
                elif 3 <= count <= n_atoms + 2:
                    if frame == 0:
                        atom_name_list.append(line[10:15].lstrip())
                    index = count - 3
                    x_arry[index] = float(line[20 + 0 * 8: 28 + 0 * 8])
                    y_arry[index] = float(line[20 + 1 * 8: 28 + 1 * 8])
                    z_arry[index] = float(line[20 + 2 * 8: 28 + 2 * 8])
                    v_x_arry[index] = float(line[44 + 0 * 8: 52 + 0 * 8])
                    v_y_arry[index] = float(line[44 + 1 * 8: 52 + 1 * 8])
                    v_z_arry[index] = float(line[44 + 2 * 8: 52 + 2 * 8])
                else:
                    df_tmp = pd.DataFrame({
                        'atomName': atom_name_list,
                        'x': x_arry,
                        'y': y_arry,
                        'z': z_arry,
                        'vx': v_x_arry,
                        'vy': v_y_arry,
                        'vz': v_z_arry
                    })
                    self.df_list.append(df_tmp)
                    frame = frame + 1
                    count = 0

    def analyze(self):
        for i in range(len(self.df_list)):
            if i % 1000 == 0:
                print("------ 正在分析第", i, "帧 ------")
            df = self.df_list[i]
            self.analyze_frame(df)
        self.finish_analysis()

    def analyze_frame(self, df):
        pass

    def finish_analysis(self):
        self.write_output()

    def write_output(self):
        pass


class MdFrame:
    def __init__(self, df, seltype, reftype, cutoff):
        sel_rows = df['atomName'] == seltype
        self.sel_points = np.array(df.loc[sel_rows][['x', 'y', 'z']])
        self.sel_vels = np.array(df.loc[sel_rows][['vx', 'vy', 'vz']])
        self.selpoints_tree = spatial.KDTree(self.sel_points)

        ref_rows = df['atomName'] == reftype
        self.ref_points = np.array(df.loc[ref_rows][['x', 'y', 'z']])
        self.ref_vels = np.array(df.loc[ref_rows][['vx', 'vy', 'vz']])
        self.results_set = self.selpoints_tree.query_ball_point(self.ref_points, cutoff)
