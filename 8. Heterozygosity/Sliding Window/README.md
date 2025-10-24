# Heterozygosity - Sliding Window
To identify areas of the genome with elevated heterozygosity along the putative historical stepping-stone dispersal. 

## Steps:

1. Calculate per-individual heterozygosity in non-overlapping 100Kb windows for each individual: `slidingwindow.heterozygosity.sh`

2. Average the individual heterozygosity values for each population: `slidingwindow.heterozygosity.popavg.sh`

3. In R, calculate average heterozygosity in each population and then delta het as difference between means at each window for population comparisons of interest. 
