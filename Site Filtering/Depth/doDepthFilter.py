import gzip
import sys
import glob
import os

def is_within_thresholds(x, min_thres, max_thres):
    global nout
    global nin
    
    if x == 'NA\n':
        nout += 1
        return False

    x = int(x)
    if x < min_thres or x > max_thres:
        nout += 1
        return False
    
    nin += 1
    return True


def get_bad_ranges(infile, out, min_thres, max_thres):

    #out = open(outfile, 'w+')
    is_out = False
    with gzip.open(infile, 'rt') as f:
        first_line = True
        for line in f:
            if first_line:
                first_line = False
                continue
            chrr, pos, d = line.split('\t')
            if not is_out:
                if is_within_thresholds(d, min_thres, max_thres):
                    continue
                elif not is_within_thresholds(d, min_thres, max_thres):
                    start = int(pos) - 1
                    is_out = True
            elif is_out:
                if is_within_thresholds(d, min_thres, max_thres):
                    end = int(pos) - 1
                    out.write(f'{chrr}\t{start}\t{end}\n')
                    is_out = False

                elif not is_within_thresholds(d, min_thres, max_thres):
                    continue

        if is_out:
             end = int(pos)
             out.write(f'{chrr}\t{start}\t{end}\n')
             
    #out.close()

lowDepthDir = "/path_to_project/depth/lowDepth" 
highDepthDir = "/path_to_project/depth/highDepth"
lowmedianfile = "/path_to_project/depth/lowDepth/autoChr_lowDepth.depthMedian"
highmedianfile = "/path_to_project/depth/highDepth/autoChr_highDepth.depthMedian"
chromfile = "/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt"
lowoutpre = "/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.lowcov.depthfilter"
highoutpre = "/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.highcov.depthfilter"

lowoutfile = lowoutpre + ".bed"
lowlogfile = lowoutpre + ".log"

lowout = open(lowoutfile, 'w+')
lowlog = open(lowlogfile, 'w+')

highoutfile = highoutpre + ".bed"
lowlogfile = highoutpre + ".log"

highout = open(highoutfile, 'w+')
highlog = open(lowlogfile, 'w+')

with open(lowmedianfile, 'r') as fh:
    lowmedian = int(fh.read().rstrip())

minl = lowmedian * 0.5
maxl = lowmedian * 1.5

with open(highmedianfile, 'r') as fh:
    highmedian = int(fh.read().rstrip())

minh = highmedian * 0.5
maxh = highmedian * 1.5

lowlog.write(f"# Will create bed list with regions to remove {lowoutfile}.\n")
lowlog.write(f"# Median total depth per site is {lowmedian}, will only keep sites with depth between {minl} and {maxl}.\n")
lowlog.write("#Summary\n\nChromosome\tKept\tRemoved\tTotal\n")

highlog.write(f"# Will create bed list with regions to remove {highoutfile}.\n")
highlog.write(f"# Median total depth per site is {highmedian}, will only keep sites with depth between {minh} and {maxh}.\n")
highlog.write("#Summary\n\nChromosome\tKept\tRemoved\tTotal\n")


with open(chromfile, 'rt') as f:
    for line in f:
        
        nout = 0
        nin = 0
         
        chrr = line.strip('\n')

        lowinfile = glob.glob(os.path.join(lowDepthDir, chrr + "_*.pos.gz"))[0]
        get_bad_ranges(lowinfile, lowout, minl, maxl)
        lowlog.write(f"{chrr}\t{nin}\t{nout}\t{nin+nout}\n")

        highinfile = glob.glob(os.path.join(highDepthDir, chrr + "_*.pos.gz"))[0]
        get_bad_ranges(highinfile, highout, minh, maxh)
        highlog.write(f"{chrr}\t{nin}\t{nout}\t{nin+nout}\n")


out.close()
log.close()
