#!/bin/bash

module load angsd

bamlist=/path_to_project/related/Pv.bam.list.noNovoGene.nomisID.noThyout.txt
chrs=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt
out=/path_to_project/related/Pv.nomisID.noThy.mapQ30.autosomes
keep_bed=/path_to_project/excess_het/results/keep_depth_het.BED
keep_sites=/path_to_project/related/keep_depth_het_loci.txt

awk '{print $1"\t"$2+1"\t"$3}' ${keep_bed} > ${keep_sites}
angsd sites index ${keep_sites}

#minInd: 183 x 75% = 137
angsd -GL 2 -rf ${chrs} -P 10 -doGlf 3 -doMaf 1 -minMaf 0.05 -doMajorMinor 1 -minInd 137 -bam ${bamlist} -sites ${keep_sites} -uniqueonly 1 -remove_bads 1 -only_proper_pairs 1 -skipTriallelic 1 -minmapq 30 -minq 30 -SNP_pval 1e-6 -out ${out}

zcat ${out}.mafs.gz | cut -f5 | sed 1d > ${out}.freqs.txt
