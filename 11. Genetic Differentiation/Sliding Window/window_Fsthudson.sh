#!/bin/bash

module load scikit-allel/1.3.9
module load tabix/1.11

vcffile=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz
chrfile=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt
popfile=/path_to_project/selection_scan_fst/popfile.tsv
popnames=/path_to_project/selection_scan_fst/popnames.txt
windowsize=100000
factor=1 #Proportion of step size to window size; 1 = non-overlapping windows

npops=($(cat $popnames | wc -l))
echo $npops

# Loop over all population pairs
for ((i=1; i<$npops; i++)); do
  for ((j=i+1; j<($npops+1); j++)); do
    pop1=$(awk "NR==${i}" ${popnames})
    pop2=$(awk "NR==${j}" ${popnames})
    pair="${pop1}_vs_${pop2}"
    echo "Running FST for $pair"
    clean_pair=$(echo "$pair" | tr ' ' '_') #removes spaces between population names. 

    python window_Fsthudson.py -v ${vcffile}  -c ${chrfile} -p ${popfile} -p1 "${pop1}" -p2 "${pop2}" -w ${windowsize} -f ${factor} -t 30 > ${clean_pair}.100k_100k.fst.tsv

  done
done
