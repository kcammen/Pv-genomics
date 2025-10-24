#!/bin/bash

module load bedtools

genelist=/path_to_project/annotations/GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable2.autochr.txt
chrsize=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.size.txt
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

shortID="AllGenes"

#Convert to 6 column BED file, adjusts start pos by 1 because BED is 0-based, but not end pos because BED end is exclusive
awk -F'\t' 'BEGIN{OFS="\t"} {print $2, $3-1, $4, $1, 0, $5}' ${genelist} > ${shortID}.genes.bed

#expand the genomic regions to include 2Kb upstream
bedtools slop -i ${shortID}.genes.bed -g ${chrsize} -l 2000 -r 0 -s > ${shortID}.upstream_2kb.bed

#sort file
bedtools sort -i ${shortID}.upstream_2kb.bed -faidx ${chrs} > ${shortID}.upstream_2kb.sorted.bed

#merge to remove any overlapping regions
bedtools merge -i ${shortID}.upstream_2kb.sorted.bed > ${shortID}.upstream_2kb.sorted.merged.bed
