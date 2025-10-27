# Evolutionary History - TreeMix
To infer historical population splits using TREEMIX. Adapted from: https://speciationgenomics.github.io/Treemix/

## Steps:

1. Add outgroup (2 gray seals: PV-074 and PV-076, and 1 Pacific harbor seal: PV293) to vcf file.  Then re-filter genotypes and conduct sample genotype merging pipeline: `genotype.finalsites.Outgroup.sh`, `genotype.filter.Outgroup.sh`, `outgroup.genotype.merge.parallel.sh`, `outgroup.genotype.filterSNPs.parallel.sh`,  `outgroup.genotype.MAF.filter.parallel.sh`, `outgroup.dup.check.sh` and remove if necessary, `outgroup.mergetovcf.parallel.sh`

2. Filter to remove missing data: `MissingData.sh`

3. Create pop file and convert vcf file to TreeMix format: `vcftotreemix.sh` 

4. Run TreeMix: `TreeMix.sh`

5. Visualize results in R using `plotting_funcs2.R`
