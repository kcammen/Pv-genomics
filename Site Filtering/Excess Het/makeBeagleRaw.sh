#!/bin/bash

module load angsd

bamlist=/path_to_project/excess_het/Pv.bam.list.noNovoGene.nomisID.noThyout.txt
chrs=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt
depth_bed=/path_to_project/depth/bedFiles/keep_depth.bed
depth_sites=/path_to_project/excess_het/keep_depth_loci.txt
out=/path_to_project/excess_het/results
bgl=${out}/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes

awk '{print $1"\t"$2+1"\t"$3}' ${depth_bed} > ${depth_sites}
angsd sites index ${depth_sites}

#minInd: 183 x 75% = 137
angsd -GL 2 -rf ${chrs} -P 10 -doGlf 2 -doMaf 1 -minMaf 0.05 -doMajorMinor 1 -minInd 137 -bam ${bamlist} -sites ${depth_sites} -uniqueonly 1 -remove_bads 1 -only_proper_pairs 1 -skipTriallelic 1 -minmapq 30 -minq 30 -SNP_pval 1e-6 -out ${bgl}

