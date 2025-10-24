#!/bin/bash

module load gffread/0.12.7

gff=/path_to_project/annotations/annotations/GSC_HSeal_1.0_HiC.fasta_v2.functional.gff3
out=/path_to_project/snpeff/snpEff/data/GSC_HSeal_1.0_HiC

gffread ${gff} -T -o ${out}/GSC_HSeal_1.0_HiC.fasta_v2.functional.gtf
