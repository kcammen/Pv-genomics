#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J nucDiv_parallel
#SBATCH -o nucDiv_parallel.log.out
#SBATCH -e nucDiv_parallel.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 24:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=40
#SBATCH --mem=10gb
############################################
module load perl/5.38.0 gsl/2.5 bcftools/1.21
module load tabix/1.11 
module load pixy/1.2.11.beta1

popfile=/projects/mortentange/people/ngz409/nucDiv/popfile.tsv
windowbedfile=/projects/mortentange/people/ngz409/heterozygosity_window/slidingwindows.100kb.100kb.bed
chrs=/projects/mortentange/people/ngz409/nucDiv/GSC_HSeal_1.0_HiC.autosomes.txt

cat ${chrs} | while read chr
do
    echo bcftools view -Oz -o merged_depthmask2_${chr}.vcf.gz /projects/mortentange/people/ngz409/genotype_merge/merged_depthmask2_${chr}.bcf.gz --threads 8
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo tabix merged_depthmask2_${chr}.vcf.gz
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo bcftools reheader -s Pv.sample.list.noNovoGene.nomisID.noThyout.norel.txt -o merged_depthmask2_${chr}_renamed.vcf.gz merged_depthmask2_${chr}.vcf.gz
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo tabix -p vcf merged_depthmask2_${chr}_renamed.vcf.gz
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo pixy --stats pi --vcf merged_depthmask2_${chr}_renamed.vcf.gz --populations ${popfile} --window_size 100000 --n_cores 8 --output_folder ${chr} --output_prefix sw100_${chr}
done | xargs -L 1 -I CMD -P 5 bash -c CMD
