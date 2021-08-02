import pandas as pd
import numpy as np
import sys

if __name__ == '__main__':
    files = sys.argv[1:]
    count=0
    for file in files:
        data = pd.read_csv(file) 
        df = pd.read_csv(file, header=None)
        n = df[1]
        if count==0:
            bins = df[0]
            num = n
        else:
            num = num + n

    arr = np.vstack([bins, num]).T
    np.savetxt('theta.csv', arr, fmt='%g', delimiter=',')
