#!/bin/bash

module load plink/1.9.0
module load perl/5.38.0 vcftools/0.1.16  

filteredvcf=/pathtoproject/rangeExpansion/California/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.vcf.gz

plink --vcf /pathtoproject/rangeExpansion/California/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.vcf.gz --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 100 10 0.1 --out final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01noLD
#Pruning complete.  405148 of 417270 variants removed: 12,122 retained

#Replace : with tab in the pruned position list
sed -i 's/:/\t/g' final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01noLD.prune.in

#Filter the vcf file to include only pruned non-LD SNPs
vcftools --gzvcf /pathtoproject/rangeExpansion/California/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.vcf.gz --positions final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01noLD.prune.in --stdout --recode | gzip > final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.vcf.gz
