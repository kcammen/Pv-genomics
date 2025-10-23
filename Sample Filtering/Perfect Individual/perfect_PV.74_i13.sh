#!/bin/bash

module load angsd
module load samtools

output=results.PV.74.i13
outgroup_bam=/path_to_mapped_bams/PV-074_dedup_RepeatMasker.bam
perfect_bam=/path_to_mapped_bams/i13_dedup_RepeatMasker.bam
abbr_outgroup=PV-074
abbr_perf=i13
bamlist=/path_to_project/perfect_individual/Pv.bam.list.txt
scaffolds=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt

angsd -i ${perfect_bam} -doCounts 1 -nThreads 8 -doFasta 1 -minMapQ 30 -minQ 30 -out ${output}/${abbr_perf}
angsd -i ${outgroup_bam} -doCounts 1 -nThreads 8 -doFasta 1 -minMapQ 30 -minQ 30 -out ${output}/${abbr_outgroup}

gunzip ${output}/${abbr_perf}.fa.gz
gunzip ${output}/${abbr_outgroup}.fa.gz

samtools faidx ${output}/${abbr_perf}.fa
samtools faidx ${output}/${abbr_outgroup}.fa

angsd -doAncError 2 -anc ${output}/${abbr_outgroup}.fa -ref ${output}/${abbr_perf}.fa -nThreads 8 -out $output/error \
-bam ${bamlist} -uniqueOnly 1 -remove_bads 1 -minMapQ 30 -minQ 30 -rf ${scaffolds}
