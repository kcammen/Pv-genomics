#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

samplelist=/path_to_project/heterozygosity_window/popfile.tsv
windowbedfile=/path_to_project/heterozygosity_window/slidingwindows.100kb.100kb.bed
ref=/path_to_project/ref/GSC_HSeal_1.0_HiC.fasta
population="Gulf of Maine"
pop=GOM
popsamplelist="${pop// /_}_samplelist.tsv"
outfile="${pop}_combined_slidingwindow.het"

#Only need to run once to create the window bed file from the sliding windows used for the fst analysis
awk -F'\t' 'NR > 15 {print $1, $2, $3}' OFS='\t' /path_to_project/selection_scan_fst/Baltic_Sea_vs_Greenland.100k_100k.fst.tsv > ${windowbedfile}

cp ${windowbedfile} ${pop}_combined_slidingwindow.het
awk -F'\t' -v popv="$population" '$2 == popv' $samplelist > $popsamplelist

for sample in $(awk '{print $1}' "$popsamplelist"); do

  echo $sample
  genofile=/path_to_project/genotype_calling/${sample}_noindel_bialleleonly_depthmask2.bcf.gz
  echo $genofile

  cat ${windowbedfile} | while read chr start end; do
    
    region="${chr}:${start}-${end}"
    echo $region

    bcftools view -g ^miss ${genofile} -r "$region" | bcftools stats -F ${ref} -s- > ${pop}_temp.stats.txt

    nrefhom=$(grep '^PSC' ${pop}_temp.stats.txt | cut -f4)
    nnonrefhom=$(grep '^PSC' ${pop}_temp.stats.txt | cut -f5)
    nhets=$(grep '^PSC' ${pop}_temp.stats.txt | cut -f6)

    nsites=$(echo "$nrefhom + $nnonrefhom + $nhets" | bc)
    het=$(echo "scale=6; $nhets / $nsites" | bc)
  
    echo "${het}" >> individual_het_files/${sample}_slidingwindow.het
    
  done

  paste ${pop}_combined_slidingwindow.het individual_het_files/${sample}_slidingwindow.het > ${pop}_tmp && mv ${pop}_tmp ${pop}_combined_slidingwindow.het

done
