#!/bin/bash

rawdir=/path_to_project/rawdata/
outdir=/path_to_project/mapped_bams/

P_vitulina_ids=$(cat HarborSeal_sampleIDs.txt)

for dir in ${P_vitulina_ids}
do 

mkdir ${dir}

cd ${rawdir}/${dir}

#Get a unique id for all the data files in a directory and trim and map them
for file in *1.fq.gz
do
echo ${file} > ${outdir}id.txt
sed -i 's/1.fq.gz//' ${outdir}id.txt 
id=`cat ${outdir}id.txt`

#Trim the reads
module load fastp
fastp --in1 ${id}1.fq.gz --in2 ${id}2.fq.gz --out1 ${outdir}${dir}/${id}fastp.1.fq.gz --out2 ${outdir}${dir}/${id}fastp.2.fq.gz --thread 40

#Map the reads
module load bwa
module load samtools 

#set genome ref file
nuref=/path_to_ref/GSC_HSeal_1.0_HiC.fasta

#align to the reference genome
bwa mem -t 40 ${nuref} ${outdir}${dir}/${id}fastp.1.fq.gz ${outdir}${dir}/${id}fastp.2.fq.gz > ${outdir}${dir}/${id}nuDNA_aligned.sam

#convert to bam file and sort
samtools view -@ 40 -T ${nuref} -b ${outdir}${dir}/${id}nuDNA_aligned.sam | samtools sort -@ 40 -o ${outdir}${dir}/${id}nuDNA_aligned_sorted.bam

#remove duplicates
samtools rmdup -S ${outdir}${dir}/${id}nuDNA_aligned_sorted.bam ${outdir}${dir}/${id}nuDNA_aligned_sorted_unique.bam

done

cd ${outdir}/${dir}

ls *nuDNA_aligned_sorted_unique.bam > ${dir}_nuDNA_2_merge.txt
samtools merge -@ 40 ${dir}_nuDNA_aligned_sorted_unique.bam -b ${dir}_nuDNA_2_merge.txt
rm ${dir}_nuDNA_2_merge.txt

# calculate mean and standard deviation of bam coverage
  STATS=$(samtools depth -a ${dir}_nuDNA_aligned_sorted_unique.bam | awk '{sum+=$3; sumsq+=$3*$3} END { print sum/NR,"\t", sqrt(sumsq/NR - (sum/NR)**2)}')
  echo -e "${dir}_nuDNA_aligned_sorted_unique.bam\t${STATS}" > ${dir}_bam_coverage.txt

rm *.sam
rm *_sorted.bam
rm *.html
rm *.json
rm *_1.fq.gz
rm *_2.fq.gz
rm *.png
rm id.txt

done
