#!/bin/bash

module load openjdk/21.0.2
module load perl/5.38.0 gsl/2.5 bcftools/1.21

mergedvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz

java -Xmx8g -jar snpEff.jar GSC_HSeal_1.0_HiC ${mergedvcf} -no-downstream -no-intergenic -no-intron -no-upstream -no-utr > final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.ann.vcf

gzip final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.ann.vcf
  
bcftools view -i 'ANN~"HIGH"' final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.ann.vcf.gz -Oz -o high_impact.vcf.gz
