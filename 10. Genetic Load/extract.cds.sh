#!/bin/bash

module load gffread/0.12.7

ref=/path_to_project/ref/GSC_HSeal_1.0_HiC.fasta
gff=/path_to_project/annotations/annotations/GSC_HSeal_1.0_HiC.fasta_v2.functional.gff3
out=/path_to_project/snpeff/snpEff/data/GSC_HSeal_1.0_HiC

#Extract CDS
gffread ${gff} -g ${ref} -x ${out}/GSC_HSeal_1.0_HiC.fasta_v2.functional.cds.fa

#Translate CDS into protein sequences
gffread ${gff} -g ${ref} -y ${out}/GSC_HSeal_1.0_HiC.fasta_v2.functional.proteins.fa
