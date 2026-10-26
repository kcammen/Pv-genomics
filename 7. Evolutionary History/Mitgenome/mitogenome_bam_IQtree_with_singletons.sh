#!/bin/bash

module load mafft/7.526
module load iqtree/2.4.0

outdir=/pathtoproject/mitogenome/bam_extract
mitoref=/pathtoproject/mitogenome/Pvmitogenome.fasta

cat ${outdir}/*_nodedup_mtDNA_with_singletons_cons.renamed.fa > ${outdir}/mitogenomes_nodedup_with_singletons_allpop.fa

mafft --auto ${outdir}/mitogenomes_nodedup_with_singletons_allpop.fa > ${outdir}/mitogenomes_nodedup_with_singletons_aligned_allpop.fasta

#iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned.fasta -st DNA -nt AUTO -m MFP -redo -safe
iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned_allpop.fasta -st DNA -nt AUTO -m TN+F+R3 -redo
#iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned.fasta -m TN+F+R3 -B 1000 -redo
