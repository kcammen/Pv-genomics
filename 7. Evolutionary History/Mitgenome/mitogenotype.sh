#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

outdir=/pathtoproject/mitogenome/bam_extract
bamlist=/pathtoproject/mitogenome/Pv.bam.orig.list.noNovoGene.nomisID.noThyout.norel_part2.txt
mitoref=/pathtoproject/mitogenome/Pvmitogenome.fasta

cat ${bamlist} | while read file
do

    sample=$(echo ${file} | cut -d '/' -f6 | cut -f1 -d "." | cut -f1 -d "_")

    echo "Processing file: ${file}"
    echo "Processing sample: ${sample}"

    #call variants    
  bcftools mpileup -B -q 30 -Q 30 -a FORMAT/AD,FORMAT/DP,FORMAT/SP \
    -f ${mitoref} -Ou --threads 8 ${outdir}/${sample}_mtDNA_aligned_sorted.bam \
  | bcftools call -Ob --threads 8 --multiallelic-caller -o ${outdir}/${sample}_nodedup_mtDNA.bcf.gz

  bcftools index --threads 8 ${outdir}/${sample}_nodedup_mtDNA.bcf.gz

    #make consensus seq
bcftools consensus \
   -f ${mitoref} \
    ${outdir}/${sample}_nodedup_mtDNA.bcf.gz \
    > ${outdir}/${sample}_nodedup_mtDNA_cons.fa

sed "s/^>.*$/>${sample}/" ${outdir}/${sample}_nodedup_mtDNA_cons.fa > ${outdir}/${sample}_nodedup_mtDNA_cons.renamed.fa

done
