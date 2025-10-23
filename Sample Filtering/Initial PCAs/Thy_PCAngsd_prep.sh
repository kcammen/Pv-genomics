#!/bin/bash

module load angsd

bamlist=/path_to_project/init_pcangsd/Pv.bam.list.noNovoGene.nomisID.txt
chrs=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt
out=/path_to_project/init_pcangsd/Pv.nomisID.mapQ30.autosomes

#minInd: 195 x 75% = 146
angsd -GL 2 -rf ${chrs} -P 10 -doGlf 2 -doMaf 1 -doMajorMinor 1 -minInd 146 -bam ${bamlist} -uniqueonly 1 -remove_bads 1 -only_proper_pairs 1 -skipTriallelic 1 -minmapq 30 -minq 30 -SNP_pval 1e-6 -out ${out}

