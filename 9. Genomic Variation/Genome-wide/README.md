# Heterozygosity - Genome-wide
Calculate autosomal heterozgyosity from output of genotyping stats. 

## Steps:

1. Calculate individual autosmal heterozygosity as nhets/(nrefhom + nnonrefhom + nhets): `genotype.het.sh`

2. Merge individual results into a single file: 
cat *_noindel_bialleleonly_depthmask2.het > merged_noindel_bialleleonly_depthmask2.het
