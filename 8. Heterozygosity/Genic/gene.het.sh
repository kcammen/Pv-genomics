#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

genolist=/path_to_project/heterozygosity_immune/Pv.geno.list.noNovoGene.nomisID.noThyout.norel.txt
immunereg=/path_to_project/heterozygosity_immune/AllGenes.upstream_2kb.sorted.merged.bed
ref=/path_to_project/ref/GSC_HSeal_1.0_HiC.fasta

for file in $(cat ${genolist})
do
  shortID=$(echo ${file} | cut -d '/' -f7 | cut -f1 -d "_")

  echo "Processing file: ${file}, shortID: ${shortID}"

  bcftools view -g ^miss ${file} -R ${immunereg} | bcftools stats -F ${ref} -s- > ${shortID}_AllGenes.stats.txt

  nrefhom=$(grep '^PSC' ${shortID}_AllGenes.stats.txt | cut -f4)
  nnonrefhom=$(grep '^PSC' ${shortID}_AllGenes.stats.txt | cut -f5)
  nhets=$(grep '^PSC' ${shortID}_AllGenes.stats.txt | cut -f6)

  nsites=$(echo "$nrefhom + $nnonrefhom + $nhets" | bc)
  het=$(echo "scale=6; $nhets / $nsites" | bc)
  
  echo "${shortID} ${nsites} ${nhets} ${het}" > ${shortID}_AllGenes.het

done

cat *_AllGenes.het > AllGenes_all.het
