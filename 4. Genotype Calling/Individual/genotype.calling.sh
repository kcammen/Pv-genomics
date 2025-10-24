#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.16

bamlist=/path_to_project/genotype_calling/Pv.bam.list_BGI5.Greenland.txt
ref=/path_to_project/ref/GSC_HSeal_1.0_HiC.fasta
finalsites=/path_to_project/related/keep_depth_het_loci.txt

for file in $(cat ${bamlist})
do
  shortID=$(echo ${file} | cut -d '/' -f7 | cut -f1 -d "_")

  echo "Processing file: ${file}, shortID: ${shortID}"

  bcftools mpileup -B -q 30 -Q 30 -a FORMAT/AD,FORMAT/DP,FORMAT/SP \
    -f ${ref} -Ou -R ${finalsites} --threads 20 ${file} \
  | bcftools call -Ob --threads 20 --multiallelic-caller -o ${shortID}.bcf.gz

  bcftools index --threads 20 ${shortID}.bcf.gz

done
