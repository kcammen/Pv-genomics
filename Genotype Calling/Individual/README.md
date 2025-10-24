# Genotype Calling - Individual
Perform genotype calling and further filtering, restricted to genomic regions retained after previous site filtering. 

## Steps:

1. Perform genotype calling individually for each BAM file, restricted to genomic regions retained after site filtering and reads with mapping quality scores of at least 30 and bases with quality scores of 30, and index genotype files: `genotype.calling.sh`

2. Filter to exclude indels and non-biallelic SNPs and to mask genotypes covered by less than eight reads or by more than two times an individual's mean depth, as well as heterozygous genotypes supported by less than two reads for any of two alleles. Whereas filters remove sites, masks set genotypes to missing. Calculate sample stats (e.g., # hets, # sites) at each filtering step. : `genotype.filter.sh`
