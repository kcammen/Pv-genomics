# Genome-wide Variation
Calculate autosomal heterozgyosity and nucleotide diversity across the genome.

## Steps:

1. Calculate individual autosmal heterozygosity from output of genotyping stats as nhets/(nrefhom + nnonrefhom + nhets): `genotype.het.sh`

2. Merge individual results into a single file: 
cat *_noindel_bialleleonly_depthmask2.het > merged_noindel_bialleleonly_depthmask2.het

3. Calculate nucleotide diversity by chromosome: `nucDiv_parallel.sh` and merge in R
