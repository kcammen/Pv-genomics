#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J extract_bam_reads 
#SBATCH -o extract_bam_reads.log.out
#SBATCH -e extract_bam_reads.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 18:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=16          
#SBATCH --mem=40gb
############################################
module load samtools/1.23.1
module load bwa/0.7.18  

outdir=/projects/mortentange/people/ngz409/mitogenome/bam_extract
bamlist=/projects/mortentange/people/ngz409/mitogenome/Pv.bam.orig.list.noNovoGene.nomisID.noThyout.norel2.txt
mitoref=/projects/mortentange/people/ngz409/mitogenome/Pvmitogenome.fasta

#bwa index ${mitoref}

cat ${bamlist} | while read file
do

    sample=$(echo ${file} | cut -d '/' -f6 | cut -f1 -d "." | cut -f1 -d "_")

    echo "Extracting reads from file: ${file}"
    echo "Processing sample: ${sample}"

    #extract mapped and unmapped reads
    #save R1 paired reads
    #save R2 paired reads
    #delete reads flagged as neither R1 or R2, or flagged as both
    #delete singletons
    #leave read names as they are
    samtools fastq \
        -1 ${sample}_R1.fastq.gz \
        -2 ${sample}_R2.fastq.gz \
        -0 /dev/null \
        -s /dev/null \
        -n \
        "${file}"

done
