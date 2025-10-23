#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

cat ${chrs} | while read chr
do
    echo bcftools view merged_depthmask2_bialleleSNPsonly_${chr}.bcf.gz -q 0.05:minor -Ob -o merged_depthmask2_bialleleSNPsonly_maf05_${chr}.bcf.gz --threads 10
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo bcftools index merged_depthmask2_bialleleSNPsonly_maf05_${chr}.bcf.gz --threads 10
done | xargs -L 1 -I CMD -P 5 bash -c CMD
