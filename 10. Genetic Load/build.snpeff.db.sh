#!/bin/bash

module load openjdk/21.0.2

#Had to first rename files in /path/to/snpEff/data/GSC_HSeal_1.0_HiC as follows: 
#cds.fa  genes.gtf  protein.fa  sequences.fa

java -jar snpEff.jar build -gtf22 -v GSC_HSeal_1.0_HiC

  
