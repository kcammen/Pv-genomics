#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21
module load tabix/1.11

#To get list of original sample names: bcftools query -l merged_depthmask2_bialleleSNPsonly_maf05_HiC_scaffold_7.bcf.gz

bcftools concat -Oz -o final_merged_depthmask2_bialleleSNPsonly_maf05_w16.vcf.gz $(ls merged_depthmask2_bialleleSNPsonly_maf05_*.bcf.gz) --threads 30 

#To check for duplicates: 
#Remove second instance of any duplicated sites: 
bcftools norm -d all -Oz -o final_merged_depthmask2_bialleleSNPsonly_maf05_dedup_w16.vcf.gz final_merged_depthmask2_bialleleSNPsonly_maf05_w16.vcf.gz

bcftools reheader -s Pv.sample.list.noNovoGene.nomisID.noThyout.norel.txt -o final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz final_merged_depthmask2_bialleleSNPsonly_maf05_dedup_w16.vcf.gz
tabix -p vcf final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz

#rm final_merged_depthmask2_bialleleSNPsonly_maf05.vcf.gz*
