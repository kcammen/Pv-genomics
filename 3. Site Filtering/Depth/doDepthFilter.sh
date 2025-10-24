#!/bin/bash

module load python/

lowdepth=/path_to_project/depth/lowDepth
highdepth=/path_to_project/depth/highDepth
medianlow=/path_to_project/depth/lowDepth/autoChr_lowDepth.depthMedian
medianhigh=/path_to_project/depth/highDepth/autoChr_highDepth.depthMedian
chrs=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt
outlow=/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.lowcov.depthfilter
outhigh=/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.highcov.depthfilter

python3 doDepthFilter.py 
