#!/bin/bash

module load plink/1.9.0
module load perl/5.38.0 vcftools/0.1.16  

mergedvcf=/path_to_project/genotype_merge/California/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_w16.vcf.gz

#First remove individuals with > 0.5 missing data: After filtering, kept 147 out of 161 Individuals
vcftools --gzvcf ${mergedvcf} --missing-indv --out missing_data_ind
awk '$5 <= 0.5 {print $1}' missing_data_ind.imiss > keep_individuals_miss05.txt
vcftools --gzvcf ${mergedvcf} --keep keep_individuals_miss05.txt --recode --recode-INFO-all --stdout | gzip > final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05.vcf.gz

#Then remove sites with >10% missing data: retains 417270 sites
vcftools --gzvcf final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05.vcf.gz --max-missing 0.9 --recode --stdout | gzip > final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.vcf.gz
