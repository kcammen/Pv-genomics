#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.16
module load samtools/1.21

samplelist=/path_to_project/psmc/PSMC_samples.csv
ref=/path_to_project/ref/GSC_HSeal_1.0_HiC.fasta
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

for file in $(cat ${samplelist})
do
  ID=`echo ${file} | cut -f1 -d ","`
  min=`echo ${file} | cut -f4 -d ","`
  max=`echo ${file} | cut -f5 -d ","`

  bam=/path_to_project/mapped_bams/${ID}_dedup_RepeatMasker.bam

  echo ${file}
  echo "Processing file: ${ID}"
  echo $min
  echo $max

  bcftools mpileup -C 50 -Q 30 -q 30 -f ${ref} -R ${chrs} --threads 20 -Ou ${bam} \
  | bcftools call -c --threads 20 \
  | vcfutils.pl vcf2fq -d ${min} -D ${max} > ${ID}.dedup.RepeatMasker.consensus.bcftools.fq
done
