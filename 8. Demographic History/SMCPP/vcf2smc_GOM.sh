#!/bin/bash

module load smcpp/1.15.5  

inputvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz
maskfile=/path_to_project/ref/GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.merged.bed.gz
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

#To get list of original sample names: bcftools query -l /path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz
#Set distinguished lineage as highest coverage individual from that population

cat ${chrs} | while read chr
do
    echo smc++ vcf2smc ${inputvcf} -m ${maskfile} -d MME-20-080Pv MME-20-080Pv smc_files/GOM_${chr}.smc.gz ${chr} GOM:COA200526Pv-02,IFAW18-261Pv,IFAW18-263Pv,IFAW18-312Pv,IFAW20-069Pv,IFAW21-025Pv,IFAW21-262Pv,MME-18-120Pv,MME-18-238Pv,MME-18-287Pv,MME-18-320Pv,MME-18-385Pv,MME-18-435Pv,MME-18-568Pv,MME-19-149Pv,MME-19-161Pv,MME-20-059Pv,MME-20-064Pv,MME-20-080Pv,MME-20-135Pv
done | xargs -L 1 -I CMD -P 5 bash -c CMD
