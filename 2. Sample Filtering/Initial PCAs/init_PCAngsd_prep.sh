#!/bin/bash

module load angsd

bamlist=/path_to_project/init_pcangsd/Pv.bam.list.noNovoGene.txt
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt
out=/path_to_project/init_pcangsd/Pv.mapQ30.autosomes

#minInd: 204 x 75% = 153

angsd -GL 2 -rf ${chrs} -P 10 -doGlf 2 -doMaf 1 -doMajorMinor 1 -minInd 153 -bam ${bamlist} -uniqueonly 1 -remove_bads 1 -only_proper_pairs 1 -skipTriallelic 1 -minmapq 30 -minq 30 -SNP_pval 1e-6 -out ${out}

