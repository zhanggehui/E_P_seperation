import numpy as np

def main():
    grofile= 'renameGO.gro'
    newgrofile = 'resizeGO.gro'
    ratio=1.42/3
    grpname = ['GRA','EPO','HYD','CAR']
    grpcount = [0,0,0,0]
    grpanum = [1,1,2,4]

    grpcount_dict={}
    grpanum_dict={}

    for i in range(len(grpname)):
        grpcount_dict[grpname[i]] = grpcount[i]
        grpanum_dict[grpname[i]] = grpanum[i]

    count=0
    with open(grofile, 'r') as gro:
        with open(newgrofile, 'w') as newgro:
            for line in gro:
                count += 1 
                if count == 1:
                    newgro.write(line)
                elif count == 2:
                    natoms=float(line[0:5])
                    newgro.write(line)
                elif count == natoms+3:
                    x=ratio*float(line[0:10])
                    y=ratio*float(line[10:20])
                    z=float(line[20:30])
                    newgro.write('%10.5f%10.5f%10.5f\n'% (x,y,z))
                else :
                    grpnm=line[12:15] 
                    grpcount_dict[grpnm] += 1
                    if grpcount_dict[grpnm]%grpanum_dict[grpnm] == 1 or grpanum_dict[grpnm] == 1:
                        c_center = getcoordinates(line)
                        A = np.array([ratio*c_center[0], ratio*c_center[1], c_center[2]])
                        C = A
                    else :
                        c_a = getcoordinates ( line )
                        B = A + np.array(c_a) - np.array(c_center)
                        C = B
                    left=line[0:20]
                    newgro.write('%s%8.3f%8.3f%8.3f\n'%(left,C[0],C[1],C[2]))

def getcoordinates(line):
    coordinates = []
    for i in range(3):
            coordinates.append(float(line[20 + i * 8: 28 + i * 8]))
    return coordinates

if __name__ == "__main__":
    main()
