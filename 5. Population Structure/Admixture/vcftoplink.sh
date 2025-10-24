#!/bin/bash

module load plink/1.9.0

mergedvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz

plink --vcf ${mergedvcf} --double-id --allow-extra-chr --set-missing-var-ids @:# --make-bed --out Pv_merged_noLDfilter

#Replace chromosome names in .bim file so they are only integers:
awk 'BEGIN{OFS="\t"} {gsub(/^HiC_scaffold_/, "", $1); gsub(/^HiC_scaffold_/, "", $2); print}' Pv_merged_noLDfilter.bim > Pv_merged_noLDfilter.bim
