#!/bin/bash

module load bedtools

bedall=/path_to_project/depth/GSC_HSeal_1.0_HiC.autosomes.bed

badlow=/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.lowcov.depthfilter
badhigh=/path_to_project/depth/bedFiles/Pv.mapQ30.autosomes.lowcov.depthfilter

badall=/path_to_project/depth/bedFiles/remove_depth_all

keep=/path_to_project/depth/bedFiles/keep_depth.bed

# make sure everything is fine
bedtools sort -i ${badlow}.bed > ${badlow}_sorted.bed
bedtools merge -i ${badlow}_sorted.bed > ${badlow}_sorted_merged.bed

bedtools sort -i ${badhigh}.bed > ${badhigh}_sorted.bed
bedtools merge -i ${badhigh}_sorted.bed > ${badhigh}_sorted_merged.bed

# make list of bad sites combining both
cat $badlow.bed $badhigh.bed > ${badall}_unmerged_unsorted.bed

bedtools sort -i ${badall}_unmerged_unsorted.bed > ${badall}_unmerged.bed
bedtools merge -i ${badall}_unmerged.bed > ${badall}.bed

# make list of good sites to keep
bedtools subtract -a $bedall -b $badall.bed > $keep

