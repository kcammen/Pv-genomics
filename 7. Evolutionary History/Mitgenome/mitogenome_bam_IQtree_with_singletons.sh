#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J mitogenome_bam_IQtree_with_singletons_allpop
#SBATCH -o mitogenome_bam_IQtree_with_singletons_allpop.log.out
#SBATCH -e mitogenome_bam_IQtree_with_singletons_allpop.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 4:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=8        
#SBATCH --mem=8gb
############################################
module load mafft/7.526
module load iqtree/2.4.0

outdir=/projects/mortentange/people/ngz409/mitogenome/bam_extract
mitoref=/projects/mortentange/people/ngz409/mitogenome/Pvmitogenome.fasta

cat ${outdir}/*_nodedup_mtDNA_with_singletons_cons.renamed.fa > ${outdir}/mitogenomes_nodedup_with_singletons_allpop.fa

mafft --auto ${outdir}/mitogenomes_nodedup_with_singletons_allpop.fa > ${outdir}/mitogenomes_nodedup_with_singletons_aligned_allpop.fasta

#iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned.fasta -st DNA -nt AUTO -m MFP -redo -safe
iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned_allpop.fasta -st DNA -nt AUTO -m TN+F+R3 -redo
#iqtree -s ${outdir}/mitogenomes_nodedup_with_singletons_aligned.fasta -m TN+F+R3 -B 1000 -redo