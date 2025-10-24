# Population Structure - Admixture 
To evaluate population structure with ADMIXTURE (for called genotypes).

## Steps:

1. Convert vcf to plink: `vcftoplink.sh`

2. Extract sample names: cut -d' ' -f2 Pv_merged_noLDfilter.fam > admix_samplelist.txt

3. Run ADMIXTURE and report CVs that can be used to determine which K is best: `admixture.sh`

4. Plot in R
