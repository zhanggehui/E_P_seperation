__author__ = "zhanggehui"
__date__ = "20210706"
__usage__ = ""
__version__ = "1"

import math
import os
import re
import sys


def readDistanceFile(distance_file):
    # Read file
    f = open(distance_file, 'r')
    lines = f.readlines()[25:]
    f.close()

    # Read the data from the bottom
    out_dict = {}
    for i in range(len(lines)):
        # Split on white-space; grab frame/distance
        if i % 200 == 0:
            columns = lines[i].split()
            key = str(i / 200)
            value = float(columns[1])
            if not math.isnan(value):
                out_dict[key] = value

    return out_dict


def sampleDistances(distance_table, sample_interval):
    target_distance = {}
    for i in range(50):
        str1 = 't' + str(i)
        target_distance[str1] = float(i * sample_interval)
    distance_table.update(target_distance)
    d_order = sorted(distance_table.items(), key=lambda x: x[1], reverse=False)

    sampled_indexes = []
    for i in range(len(d_order)):
        tup = d_order[i]
        if 't' in tup[0]:
            target = tup[1]
            v1 = d_order[i - 1][1]
            v2 = d_order[i + 1][1]
            index = (abs(v1 - target) < abs(v2 - target) and i - 1 or i + 1)
            sampled_indexes.append(d_order[index][0])

    return sampled_indexes


def createOutputFile(template_file, frame_number, search_string="XXX"):

    out_file = "./umbrella-frame-%i/sampling.sh" % (frame_number)

    # Read the contents of the template file
    f = open(template_file, 'r')
    file_contents = f.read()
    f.close()

    # Write out the template file contents, replacing all instances of 
    # the search string with the frame number
    f = open(out_file, 'w')
    f.write(re.sub(search_string, "%i" % frame_number, file_contents))
    f.close()


def main(argv=None):
    """
    Parse command line, etc.
    """

    if argv is None:
        argv = sys.argv[1:]

    # Parse required command line arguments
    try:
        distance_file = argv[0]
        sample_interval = float(argv[1])
    except (IndexError, ValueError):
        err = "Incorrect command line arguments!\n\n%s\n\n" % __usage__
        raise IOError(err)

    # See if a template file has been specified
    try:
        template_files = argv[2:]
    except IndexError:
        template_files = []

    # Figure out which frames to use
    distance_table = readDistanceFile(distance_file)
    sampled_indexes = sampleDistances(distance_table, sample_interval)

    # If any template files were specified, use them to make frame-specific
    # output
    if len(template_files) != 0:
        print("Creating frame-specific output for files:")
        print("\n".join(template_files))
        for t in template_files:
            for i in range(len(sampled_indexes)):
                frame = int(float(sampled_indexes[i]))
                if not os.path.exists('umbrella-frame-'+str(frame)):
                    os.system('mkdir umbrella-frame-'+str(frame))
                    createOutputFile(t, frame, search_string="XXX")

    # Print out summary of the frames we identified      
    out = ["%10s%10s%10s\n" % ("frame", "dist", "del_dist")]
    for i in range(len(sampled_indexes)):
        frame = int(float(sampled_indexes[i]))
        dist = distance_table[sampled_indexes[i]]
        if i == 0:
            delta_dist = "%10s" % "NA"
        else:
            prev_dist = distance_table[sampled_indexes[i - 1]]
            delta_dist = "%10.3f" % (dist - prev_dist)

        out.append("%10i%10.3f%s\n" % (frame, dist, delta_dist))
        
    f1 = open('tpr-files.dat', 'w')
    f2 = open('pullf-files.dat', 'w')
    for i in range(len(sampled_indexes)):
        frame = int(float(sampled_indexes[i]))
        f1.write('../umbrella-frame-'+str(frame)+'/umbrella'+str(frame)+'.tpr\n')
        f2.write('../umbrella-frame-'+str(frame)+'/umbrella'+str(frame)+'_pullf.xvg\n')
    f1.close()
    f2.close()

    return out


if __name__ == "__main__":
    out1 = main()
    print("".join(out1))
