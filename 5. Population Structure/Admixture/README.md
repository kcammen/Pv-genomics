# Population Structure - Admixture 
To evaluate population structure with ADMIXTURE (for called genotypes).

## Steps:

0. Replace chromosome names in .bim file so they are only integers:
awk 'BEGIN{OFS="\t"} {gsub(/^HiC_scaffold_/, "", $1); gsub(/^HiC_scaffold_/, "", $2); print}' Pv_merged.bim > Pv_merged.bim

1. Convert vcf to plink: `vcftoplink.sh`

1b. Replace chromosome names in .bim file so they are only integers:
awk 'BEGIN{OFS="\t"} {gsub(/^HiC_scaffold_/, "", $1); gsub(/^HiC_scaffold_/, "", $2); print}' Pv_merged.bim > Pv_merged.bim

1c. Extract sample names: cut -d' ' -f2 Pv_merged_noLDfilter.fam > admix_samplelist.txt

2. Run ADMIXTURE and report CVs that can be used to determine which K is best: `admixture.sh`

3. Plot in R
