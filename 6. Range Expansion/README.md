# Range Expansion
To evaluate evidence for past range expansion using Peter and Slatkin's directionality index (ψ). Adapted from: https://github.com/BenjaminPeter/rangeexpansion and https://doi.org/10.6084/m9.figshare.25997209

## Steps:

1. Add outgroup (1 Pacific harbor seal: PV293) to vcf file.  Then re-filter genotypes and conduct sample genotype merging pipeline: `genotype.finalsites.Outgroup.sh`, `genotype.filter.Outgroup.sh`, `outgroup.genotype.merge.parallel.sh`, `outgroup.genotype.filterSNPs.parallel.sh`,  `outgroup.genotype.MAF.filter.parallel.sh`, `outgroup.dup.check.sh` and remove if necessary, `outgroup.mergetovcf.parallel.sh`

2. Filter to remove missing data: `MissingData.sh`

3. LD prune vcf file that includes outgroup (1 CA harbor seal: PV293) and has been previously filtered to remove missing data: `LDprune.sh`

4. Calculate ψ, use a binomial test to evaluate significance, calculate the putative origin of range expansion using a TDOA approach, and map expansion paths and origin: `rangeExpansion.R`
