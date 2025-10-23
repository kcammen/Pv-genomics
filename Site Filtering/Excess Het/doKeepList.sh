#!/bin/bash

module load bedtools

bed_depth=/path_to_project/depth/bedFiles/keep_depth.bed

exclude=/path_to_project/excess_het/results/excludelistInbreedSites_minF-0.9_rm20000
keep=/path_to_project/excess_het/results/keep_depth_het

bedtools sort -i ${exclude}_unmerged_unsorted.BED > ${exclude}_unmerged.BED
bedtools merge -i ${exclude}_unmerged.BED > ${exclude}.BED

bedtools subtract -a ${bed_depth} -b ${exclude}.BED > ${keep}.BED

