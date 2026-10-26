#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J mitogenotype_v2
#SBATCH -o mitogenotype_v2.log.out
#SBATCH -e mitogenotype_v2.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 4:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=8          
#SBATCH --mem=8gb
############################################
module load perl/5.38.0 gsl/2.5 bcftools/1.21

outdir=/projects/mortentange/people/ngz409/mitogenome/bam_extract
bamlist=/projects/mortentange/people/ngz409/mitogenome/Pv.bam.orig.list.noNovoGene.nomisID.noThyout.norel_part2.txt
mitoref=/projects/mortentange/people/ngz409/mitogenome/Pvmitogenome.fasta

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
