import analysis as ay
import argparse
import sys
sys.path.append("/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle_distribution")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("ifile", type=str)
    parser.add_argument("ofile", type=str)
    parser.add_argument("omatfile", type=str)
    parser.add_argument("center", type=str)
    parser.add_argument("ori", type=str)
    args = parser.parse_args()
    ay.Analysis(args.ifile, args.ofile, args.omatfile, args.center, args.ori).analysis()
