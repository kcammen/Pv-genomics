#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J align_bam_mito_part3
#SBATCH -o align_bam_mito_part3.log.out
#SBATCH -e align_bam_mito_part3.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 6:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=8         
#SBATCH --mem=20gb
############################################
module load samtools/1.23.1
module load bwa/0.7.18  

outdir=/projects/mortentange/people/ngz409/mitogenome/bam_extract
bamlist=/projects/mortentange/people/ngz409/mitogenome/Pv.bam.orig.list.noNovoGene.nomisID.noThyout.norel_part3b.txt
mitoref=/projects/mortentange/people/ngz409/mitogenome/Pvmitogenome.fasta

#bwa index ${mitoref}

cat ${bamlist} | while read file
do

    sample=$(echo ${file} | cut -d '/' -f6 | cut -f1 -d "." | cut -f1 -d "_")

    echo "Processing file: ${file}"
    echo "Aligning to reference mitogenome: ${sample}"

    #align to reference mitogenome
    bwa mem -t 8 \
        ${mitoref} \
        ${sample}_R1.fastq.gz \
        ${sample}_R2.fastq.gz > ${outdir}/${sample}_mtDNA_aligned.sam
     
    #convert to bam file and sort
    samtools view -@ 8 -T ${mitoref} -b ${outdir}/${sample}_mtDNA_aligned.sam | samtools sort -@ 8 -o ${outdir}/${sample}_mtDNA_aligned_sorted.bam

    #remove duplicates
    samtools rmdup -S ${outdir}/${sample}_mtDNA_aligned_sorted.bam ${outdir}/${sample}_mtDNA_aligned_sorted_unique.bam

    samtools index ${outdir}/${sample}_mtDNA_aligned_sorted_unique.bam

done
