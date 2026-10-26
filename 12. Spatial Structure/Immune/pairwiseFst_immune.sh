#!/bin/bash

module load plink/2.0.0

vcffile=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz
popfile=/path_to_project/pca_final/popfile.tsv
immunereg=/path_to_project/heterozygosity_immune/PathogenRecognition.upstream_2kb.sorted.bed

plink2 --vcf $vcffile --double-id --allow-extra-chr \
--extract range $immunereg \
--within $popfile \
--fst CATPHENO method=hudson \
--out Pv_merged_HudsonFst_PR --threads 8
