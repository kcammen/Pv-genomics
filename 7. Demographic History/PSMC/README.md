
# Demographic History - PSMC
Run PSMC to evaluate historical demography (Ne) of each population using 1 high-coverage diploid conensus genome sequence per population. 

## Steps:

1. Call consensus genotypes at autosomes with quality filters: `consensus.genotype.calling.sh` 

2. Convert the diploid.fq to a psmcfa file: `fqtopsmcfa.sh` 

3. Run first iteration of PSMC: `psmc.sh`

3. Generate code to run PSMC bootstraps: `psmc_bootstrap_prep` 

4. Run `run.boostraps.*.sh` for each individual

5. Generate plots of PSMC output: `plot_psmc.sh` 

6. Download the .txt files generated during plotting and create plots in R. 
