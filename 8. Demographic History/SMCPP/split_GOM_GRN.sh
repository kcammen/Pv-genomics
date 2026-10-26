#!/bin/bash

module load smcpp/1.15.5  

inputvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz
maskfile=/path_to_project/ref/GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.merged.bed.gz
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

#Copy individual datasets into joint folder
mkdir smc_files/GOM_GRN/
cp smc_files/GOM*.smc.gz smc_files/GOM_GRN/
cp smc_files/GRN*.smc.gz smc_files/GOM_GRN/

#Create datasets containing the joint frequency spectrum for both populations:
cat ${chrs} | while read chr
do
    echo smc++ vcf2smc ${inputvcf} -m ${maskfile} -d MME-20-080Pv MME-20-080Pv smc_files/GOM_GRN/GOM_GRN${chr}.smc.gz ${chr} GOM:COA200526Pv-02,IFAW18-261Pv,IFAW18-263Pv,IFAW18-312Pv,IFAW20-069Pv,IFAW21-025Pv,IFAW21-262Pv,MME-18-120Pv,MME-18-238Pv,MME-18-287Pv,MME-18-320Pv,MME-18-385Pv,MME-18-435Pv,MME-18-568Pv,MME-19-149Pv,MME-19-161Pv,MME-20-059Pv,MME-20-064Pv,MME-20-080Pv,MME-20-135Pv GRN:PV-T01,PV-T03,PV-T06,PV-T11,PV-T12,PV-T17,PV-T22,PV-T23,PV-T25,PV-T26,PV305,PV306,PV308,PV310,PV311,PV312,PV314,PV315,PV318,PV319
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo smc++ vcf2smc ${inputvcf} -m ${maskfile} -d PV-T26 PV-T26 smc_files/GOM_GRN/GRN_GOM${chr}.smc.gz ${chr} GRN:PV-T01,PV-T03,PV-T06,PV-T11,PV-T12,PV-T17,PV-T22,PV-T23,PV-T25,PV-T26,PV305,PV306,PV308,PV310,PV311,PV312,PV314,PV315,PV318,PV319 GOM:COA200526Pv-02,IFAW18-261Pv,IFAW18-263Pv,IFAW18-312Pv,IFAW20-069Pv,IFAW21-025Pv,IFAW21-262Pv,MME-18-120Pv,MME-18-238Pv,MME-18-287Pv,MME-18-320Pv,MME-18-385Pv,MME-18-435Pv,MME-18-568Pv,MME-19-149Pv,MME-19-161Pv,MME-20-059Pv,MME-20-064Pv,MME-20-080Pv,MME-20-135Pv
done | xargs -L 1 -I CMD -P 5 bash -c CMD

#Run split to refine the marginal estimates into an estimate of the joint demography:
mkdir split/GOM_GRN

smc++ split --cores 4 -o split/GOM_GRN/ results/GOM/model.final.json results/GRN/model.final.json smc_files/GOM_GRN/*.smc.gz
smc++ plot -g 14.8 -c plots/split/GOM_GRN_split.pdf split/GOM_GRN/model.final.json

smc++ split --cores 4 -o split/GRN_GOM/ results/GRN/model.final.json results/GOM/model.final.json smc_files/GOM_GRN/*.smc.gz
smc++ plot -g 14.8 -c plots/split/GRN_GOM_split.pdf split/GRN_GOM/model.final.json
