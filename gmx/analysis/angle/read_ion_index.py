import sys
import os

filenames = []


class ndxfile:

    def __init__(self, fname):
        self.fname = fname
        self.index_list = []
        self.__readfile(fname)

    def __readfile(self, fname):
        count = 0
        with open(fname, 'r') as f:
            for line in f:
                if line.find('[') != -1:
                    bname = line[2:-2]
                else:
                    linelist = line.rstrip('\n').split()
                    for i in range(len(linelist)):
                        self.index_list.append(int(linelist[i]))

    def getindexes(self):
        return self.index_list


def ndx_merge():
    ndx_dic = {}

    for i in range(len(filenames)):
        fname = filenames[i]
        front, _ = os.path.splitext(fname)
        ndx_dic[front] = ndxfile(fname).getindexes()

    with open('vector.ndx', 'w') as f:
        f.write('[ vector ]\n')
        count_line = 0
        for k, v in ndx_dic.items():
            for index in v:
                count_line += 2
                if count_line % 16 == 0:
                    f.write('%d %d\n' % (index, int(k)))
                else:
                    f.write('%d %d ' % (index, int(k)))
        f.write('\n')


if __name__ == '__main__':
    filenames = sys.argv[1:len(sys.argv)]
    ndx_merge()
