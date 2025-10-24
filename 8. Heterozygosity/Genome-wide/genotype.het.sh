#!/bin/bash

genostatslist=/path_to_project/heterozygosity_bcftools/Pv.genostats.list_BGI5.Greenland.txt

for file in $(cat ${genostatslist})
do
  shortID=$(echo ${file} | cut -d '/' -f7 | cut -f1 -d "_")

  echo "Processing file: ${file}, shortID: ${shortID}"

  nrefhom=$(grep '^PSC' ${file} | cut -f4)
  nnonrefhom=$(grep '^PSC' ${file} | cut -f5)
  nhets=$(grep '^PSC' ${file} | cut -f6)

  nsites=$(echo "${nrefhom} + ${nnonrefhom} + ${nhets}" | bc)
  het=$(echo "scale=6; ${nhets} / ${nsites}" | bc)
  
  echo "${shortID} ${nsites} ${nhets} ${het}" > ${shortID}_noindel_bialleleonly_depthmask2.het

done

cat *_noindel_bialleleonly_depthmask2.het > merged_noindel_bialleleonly_depthmask2.het
