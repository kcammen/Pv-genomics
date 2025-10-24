#!/bin/bash

module load perl/5.38.0
module load gcc/13.2.0 gnuplot/6.0.0
module load texlive/2023

samplelist=/path_to_project/psmc/PSMC_samples_wopilot.csv

#Mutation rate and generation time from Peart et al. 2020

for file in $(cat ${samplelist})
do
  ID=`echo ${file} | cut -f1 -d ","`
  mkdir plots/${ID}

 # ./psmc_plot.pl -u 7.0e-9 -g 14.8 -R -p PSMC_pilot ${ID}.dedup.RepeatMasker.consensus.bcftools.psmc
  
  ./psmc_plot.pl -u 7.0e-9 -g 14.8 -R -p plots/${ID}/${ID} ${ID}.dedup.RepeatMasker.consensus.bcftools.psmc bootstraps/${ID}/round_${ID}-*.psmc

done



