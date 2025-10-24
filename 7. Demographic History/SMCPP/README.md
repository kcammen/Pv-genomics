
# Demographic History - SMC++
Run SMC++ to evaluate recent historical demography (Ne) of each population and divergence time between pouplation pairs. 

## Steps:

0. Create a SMC++ mask file:  
a. Get RepeatMasker file from DNAZoo: wget https://dnazoo.s3.wasabisys.com/Phoca_vitulina/GSC_HSeal_1.0_HiC.repeatmasker.trf.windowmasker.gff.gz  
b. Filter to only RepeatMasker repeats: zcat GSC_HSeal_1.0_HiC.repeatmasker.trf.windowmasker.gff.gz | awk '$2 == "RepeatMasker" {print $1"\t"($4-1)"\t"$5}' > GSC_HSeal_1.0_HiC.repeatmasker.bed  
c. Filter to include only autosomes: grep -Fwf GSC_HSeal_1.0_HiC.autosomes.txt GSC_HSeal_1.0_HiC.repeatmasker.bed > GSC_HSeal_1.0_HiC.repeatmasker.autosomes.bed  
d. Sort the bed file, with chromosomes in order as listed in chr file: awk 'NR==FNR {order[$1] = NR; next} $1 in order {print order[$1], $0}' GSC_HSeal_1.0_HiC.autosomes.txt GSC_HSeal_1.0_HiC.repeatmasker.autosomes.bed | sort -k1,1n -k3,3n | cut -d" " -f2- > GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.bed  
e. Merge overlapping intervals: bedtools merge -i GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.bed > GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.merged.bed  
f. Compress: bgzip GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.merged.bed  
g. Index: tabix -p bed GSC_HSeal_1.0_HiC.repeatmasker.autosomes.sorted.merged.bed.gz  

1. Convert vcf to smc++ input format: `vcf2smc.sh`. Run for each population and each chromosome individually, using the highest coverage individual in each population as the "distinguished lineage"  

2. Estimate the population size history for each population individually: `estimate.sh` 

3. Plot population size histories: `smcpp_plot.sh` 

4. Estimate divergence time between two populations: `split.sh`  
To convert to years: split time x 2 * N0 x generation time  
grep split model.final.json | awk '{print $2}' | tr -d ','  
grep N0 model.final.json | awk '{print $2}' | tr -d ',' | head -n 1  

To bootstrap: 
1. Resample the genome in chunks with replacement to generate new smc++ files from the individual and population pair files generated using vcf2smc.sh in steps 1 and 4 above. This bootstrapping method maintains population sample sizes and chromsome sizes: `bootstrap.sh`

2. Estimate population size history for each individual population bootstrap replicate: `bootstrap_estimate.sh`

3. Estimate divergence time for each population pair bootstrap replicate: `bootstrap_split.sh`
