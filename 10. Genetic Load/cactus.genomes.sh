#!/bin/bash

module load bedtools/2.31.0

#Harbor seal
bedtools maskfasta -soft \
  -fi /path_to_project/ref/GSC_HSeal_1.0_HiC.fasta \
  -bed /path_to_project/ref/GSC_HSeal_1.0_HiC.repeatmasker.bed \
  -fo GSC_HSeal_1.0_HiC.softmasked.fa

#Spotted seal
wget https://dnazoo.s3.wasabisys.com/Phoca_largha/Phoca_largha_HiC.fasta.gz
wget https://dnazoo.s3.wasabisys.com/Phoca_largha/Phoca_largha_HiC.repeatmasker.trf.windowmasker.gff.gz

zcat Phoca_largha_HiC.repeatmasker.trf.windowmasker.gff.gz | awk '$2 == "RepeatMasker" {print $1"\t"($4-1)"\t"$5}' > Phoca_largha_HiC.repeatmasker.bed

gunzip Phoca_largha_HiC.fasta.gz

bedtools maskfasta -soft \
  -fi Phoca_largha_HiC.fasta \
  -bed Phoca_largha_HiC.repeatmasker.bed \
  -fo Phoca_largha_HiC.softmasked.fa

#Gray seal
wget https://dnazoo.s3.wasabisys.com/Halichoerus_grypus/Halichoerus_grypus_HiC.fasta.gz
wget https://dnazoo.s3.wasabisys.com/Halichoerus_grypus/Halichoerus_grypus_HiC.repeatmasker.trf.windowmasker.gff.gz

zcat Halichoerus_grypus_HiC.repeatmasker.trf.windowmasker.gff.gz | awk '$2 == "RepeatMasker" {print $1"\t"($4-1)"\t"$5}' > Halichoerus_grypus_HiC.repeatmasker.bed

gunzip Halichoerus_grypus_HiC.fasta.gz

bedtools maskfasta -soft \
  -fi Halichoerus_grypus_HiC.fasta \
  -bed Halichoerus_grypus_HiC.repeatmasker.bed \
  -fo Halichoerus_grypus_HiC.softmasked.fa

#Stone marten = outgroup
wget https://dnazoo.s3.wasabisys.com/Martes_foina/mfoi.min_150.pseudohap2.1_HiC.fasta.gz
wget https://dnazoo.s3.wasabisys.com/Martes_foina/mfoi.min_150.pseudohap2.1_HiC.repeatmasker.trf.windowmasker.gff.gz

zcat mfoi.min_150.pseudohap2.1_HiC.repeatmasker.trf.windowmasker.gff.gz | awk '$2 == "RepeatMasker" {print $1"\t"($4-1)"\t"$5}' > mfoi.min_150.pseudohap2.1_HiC.repeatmasker.bed

gunzip mfoi.min_150.pseudohap2.1_HiC.fasta.gz

bedtools maskfasta -soft \
  -fi mfoi.min_150.pseudohap2.1_HiC.fasta \
  -bed mfoi.min_150.pseudohap2.1_HiC.repeatmasker.bed \
  -fo mfoi.min_150.pseudohap2.1_HiC.softmasked.fa

gzip GSC_HSeal_1.0_HiC.softmasked.fa
gzip Phoca_largha_HiC.softmasked.fa
gzip Halichoerus_grypus_HiC.softmasked.fa
gzip mfoi.min_150.pseudohap2.1_HiC.softmasked.fa

rm Phoca_largha_HiC.fasta
rm Halichoerus_grypus_HiC.fasta
rm mfoi.min_150.pseudohap2.1_HiC.fasta
rm Phoca_largha_HiC.repeatmasker.trf.windowmasker.gff.gz
rm Halichoerus_grypus_HiC.repeatmasker.trf.windowmasker.gff.gz
rm mfoi.min_150.pseudohap2.1_HiC.repeatmasker.trf.windowmasker.gff.gz
