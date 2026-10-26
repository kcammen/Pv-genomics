#!/bin/bash
#SBATCH --partition=cpuqueue 
#SBATCH --qos=normal
#SBATCH -J winPCAv2
#SBATCH -o winPCAv2.log.out
#SBATCH -e winPCAv2.error      
#SBATCH --mail-user=kristina.cammen@sund.ku.dk
#SBATCH --mail-type=ALL 
#SBATCH -t 2:00:00				
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=8
#SBATCH --mem=2gb
############################################
module load perl/5.38.0 gsl/2.5 bcftools/1.21
module load winpca/1.2.1
#module load scikit-allel/1.3.9 numpy/1.26.4 pandas/2.2.1

python -c "import allel; print(allel.__version__)"

vcffile=/projects/mortentange/people/ngz409/treeMix/final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01.vcf.gz
HUDind=/projects/mortentange/people/ngz409/winpca/HUD.nomisID.norel.outgroup.txt
vcffile_noHUD=/projects/mortentange/people/ngz409/winpca/final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01_woHUD_biSNPs.vcf.gz

#remove Hudson Bay individuals and gray seals
#bcftools view -S ^${HUDind} -Oz -o final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01_woHUD.vcf.gz ${vcffile}

#retains only biallelic SNPs
#bcftools view --threads 20 -m2 -M2 -v snps -Oz -o final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01_woHUD_biSNPs.vcf.gz final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01_woHUD.vcf.gz
#bcftools index final_merged_depthmask2_bialleleSNPsonly_maf05_outgroup_renamed_miss05_miss01_woHUD_biSNPs.vcf.gz

#winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_1 ${vcffile_noHUD} HiC_scaffold_1:1-192152984  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_2 ${vcffile_noHUD} HiC_scaffold_2:1-207502491  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_3 ${vcffile_noHUD} HiC_scaffold_3:1-185978586  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_4 ${vcffile_noHUD} HiC_scaffold_4:1-211909124  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_5 ${vcffile_noHUD} HiC_scaffold_5:1-104570484  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_6 ${vcffile_noHUD} HiC_scaffold_6:1-136537484  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_7 ${vcffile_noHUD} HiC_scaffold_7:1-91542015  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_8 ${vcffile_noHUD} HiC_scaffold_8:1-58374298  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_9 ${vcffile_noHUD} HiC_scaffold_9:1-88862686  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_10 ${vcffile_noHUD} HiC_scaffold_10:1-108332318  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_11 ${vcffile_noHUD} HiC_scaffold_11:1-141748437  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_12 ${vcffile_noHUD} HiC_scaffold_12:1-174555881  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_13 ${vcffile_noHUD} HiC_scaffold_13:1-152438930  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_14 ${vcffile_noHUD} HiC_scaffold_14:1-144053833  
winpca pca --np -t 8 -w 100000 -i 100000 HiC_scaffold_16 ${vcffile_noHUD} HiC_scaffold_16:1-200379021  
