#!/bin/bash

module load plink/1.9.0

mergedvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz

plink --vcf $mergedvcf --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--make-bed --pca --out Pv_merged_woLDprune
