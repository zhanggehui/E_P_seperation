import scipy.io as sio
import sys

if __name__ == '__main__':
    files = sys.argv[1:]
    count=0
    for file in files:
        data = sio.loadmat(file)
        arr1 = data['n_grid'] 
        arr2 = data['v1_grid']
        arr3 = data['v2_grid']

        if count==0:
           n_grid = arr1
           v1_grid = arr2
           v2_grid = arr3
        else:
            n_grid = n_grid + arr1
            v1_grid = v1_grid + arr2
            v2_grid = v2_grid + arr3

    sio.savemat('out.mat', {'n_grid': n_grid,
                            'v1_grid': v1_grid,
                            'v2_grid': v2_grid})
