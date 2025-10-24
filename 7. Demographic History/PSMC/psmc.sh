#!/bin/bash

module load gcc/13.2.0 gnuplot/6.0.0 psmc/0.6.5

samplelist=/path_to_project/psmc/PSMC_samples.csv

for file in $(cat ${samplelist})
do
  ID=`echo ${file} | cut -f1 -d ","`

 # fq2psmcfa ${ID}.dedup.RepeatMasker.consensus.bcftools.fq > ${ID}.dedup.RepeatMasker.consensus.bcftools.psmcfa

  psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o ${ID}.dedup.RepeatMasker.consensus.bcftools.psmc ${ID}.dedup.RepeatMasker.consensus.bcftools.psmcfa

done

