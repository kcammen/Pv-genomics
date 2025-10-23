#!/bin/bash

module load samtools
module load bedtools

P_vitulina_ids=$(cat HarborSeal_sampleIDs.txt)

for BAM in ${P_vitulina_ids}
do

echo ${BAM}_nuDNA_aligned_sorted_unique.bam

samtools index -@ 5 ${BAM}_nuDNA_aligned_sorted_unique.bam

INDIR=/path_to_mapped_reads/

###########
OUTDIR=${INDIR}

BED=/path_to_ref/Phoca_vitulina_RepeatMasker_regions.bed
#shortid=`echo $BAM | cut -f1 -d "_"`

##########################################################################################

bedtools intersect -abam ${INDIR}/${BAM}_nuDNA_aligned_sorted_unique.bam -b ${BED} -v > ${OUTDIR}/${BAM}_dedup_RepeatMasker.bam 2>${OUTDIR}/${BAM}_RepeatMasker_log.txt

samtools index ${OUTDIR}/${BAM}_dedup_RepeatMasker.bam

done
