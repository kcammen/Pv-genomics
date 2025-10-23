
# To merge individual genotypes and filter to retain only SNPs with MAF > 0.5 on autosomal chromosomes. 

# Steps:

In parallel across chromosomes (for computational speed and will also result in filtering to the 15 autosomal chromosomes): 
1. Merge individual genotype files and index the file: `genotype.merge.parallel.sh`
#Take this approach instead of genotyping jointly because of need to apply depth filters based on individual mean depth. 

#To count the number of positions per chromosome: 
bcftools view -H merged_depthmask2_HiC_scaffold_1.bcf.gz | wc -l

2. Filter to retain only SNPs and index the files: `genotype.filterSNPs.parallel.sh`

3. Filter genotypes to remove sites with MAF < 0.05: `genotype.MAF.filter.parallel.sh` 

4. Merge chromosome files; convert .bcf.gz to .vcf.gz; rename samples with sample ID; and tabix index file (for use with scikit-allel): `mergetovcf.parallel.sh`
