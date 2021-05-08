import sys
from pathlib import Path

filenames = []


def jump_line(line):
    return line[0] == '#' or line[0] == '@'


class all_angle_file:

    def __init__(self, fname):
        self.fname = fname
        self.angle_list = []
        my_file = Path(fname)
        if my_file.exists():
            self.__readfile(fname)

    def __readfile(self, fname):
        with open(fname, 'r') as f:
            for line in f:
                if not jump_line(line):
                    linelist = line.strip().rstrip('\n').split()
                    for i in range(1, len(linelist)):
                        self.angle_list.append(float(linelist[i]))

    def extend_angle_list(self, filenames):
        for i in range(len(filenames)):
            fname = filenames[i]
            self.angle_list.extend(all_angle_file(fname).get_angle_list())

    def get_angle_list(self):
        return self.angle_list

    def write_new(self):
        with open('all_angle.xvg', 'w') as f:
            f.write('0.00   ')
            for angle in self.angle_list:
                f.write('%.3f   ' % angle)
            f.write('\n')


def all_angle_merge():
    angle_file = all_angle_file('all_angle.xvg')
    angle_file.extend_angle_list(filenames)
    angle_file.write_new()


if __name__ == '__main__':
    filenames = sys.argv[1:len(sys.argv)]
    all_angle_merge()
