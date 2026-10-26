#!/bin/bash

module load samtools/1.23.1
module load bwa/0.7.18  

outdir=/pathtoproject/mitogenome/bam_extract
bamlist=/pathtoproject/mitogenome/Pv.bam.orig.list.noNovoGene.nomisID.noThyout.norel_part3b.txt
mitoref=/pathtoproject/mitogenome/Pvmitogenome.fasta

bwa index ${mitoref}

cat ${bamlist} | while read file
do

    sample=$(echo ${file} | cut -d '/' -f6 | cut -f1 -d "." | cut -f1 -d "_")

    echo "Processing file: ${file}"
    echo "Aligning to reference mitogenome: ${sample}"

    #align to reference mitogenome
    bwa mem -t 8 ${mitoref} \
        ${sample}_R1.fastq.gz \
        ${sample}_R2.fastq.gz \
        | samtools sort -@ 8 \
    -o ${outdir}/${sample}_mtDNA_aligned_sorted.bam
         
    samtools index ${outdir}/${sample}_mtDNA_aligned_sorted_unique.bam

    bwa mem -t 8 ${mitoref} \
        ${sample}_singletons.fastq.gz \
        | samtools sort -@ 8 \
    -o ${outdir}/${sample}_singletons_mtDNA_aligned_sorted.bam
    
    samtools index ${outdir}/${sample}_singletons_mtDNA_aligned_sorted.bam

done
