# Heterozygosity - Genic
To evaluate autosomal heterozygosity within genic regions and select subsets of immune system genes. 

# Steps:

1. Convert gene position files to a bed file; calculate strand-aware 2kb upstream; and sort by position: `createGeneBED.sh`

2. Calculate heterozygosity within immune regions:  `gene.het.sh`

To calculate total size of the gene regions + upstream: awk '{sum += $3 - $2} END {print sum}' genes.upstream_2kb.sorted.bed  
