# Pv-genomics
Analysis code for Cammen et al. (2026)

This repository contains scripts for the analyses of whole genome sequencing data from harbor seals sampled across the North Atlantic, presented in _Range expansion reduces immunogenomic diversity in a widely distributed pinniped species_ by Cammen et al. (2016). DOI to published paper will be added here. Associated raw sequence data will be deposited in the European Nucleotide Archive (Project ###) and the NCBI Short-Read Archive (Project ####) following acceptance of the manuscript. 

Scripts are provided in individual folders for (numbered in sequential order of implementation):

1. _Sequence Processing_  
   a) Mapping raw reads to a reference genome  
   b) Removing low complexity and interspersed repeat regions

3. _Sample Filtering_  
   a) Estimating individual relative error rates  
   b) Identifying species mis-identifications and assigning putative source population to mixed sites through PCA  
   c) Evaluating relatedness among individuals (note this step was done after site filtering)

4. _Site Filtering_  
   a) Filtering genomic loci based on depth  
   b) Filtering genomic loci based on heterozygosity  

5. _Genotype Calling_  
   a) Calling individual genotypes  
   b) Merging and further filtering genotypes  

6. _Evaluating Population Structure_  
   a) Visualizing population structure using PCA and pairwise Fst  
   b) Evaluating admixture  

7. _Evaluating Evolutionary History_  
   a) Inferring historical splits with TreeMix

8. _Evaluating Demographic History_  
   a) Estimating long-range change in effective population size with PSMC  
   b) Estimating shorter-range historical demongraphy and split times with SMC++  

9. _Evaluating Heterozygosity_  
   a) Calculating genome-wide autosomal heterozygosity  
   b) Identifying genic and immunogenomic regions within the reference genome annotation  
   c) Calculating autosomal heterozygosity within subsets of genic regions  
   d) Calculating sliding-window heterozygosity across the genome and identifying outlier regions of elevated heterozygosity loss  

10. _Evaluating Inbreeding_  
    a) Calculting proportion of individual genomes found in runs of homozygosity

11. _Evaluating Genetic Load_  
    a) Approximating individual-level genetic loads

12. _Evaluating Genetic Differentiation_  
    a) Calculating Fst across the genome and within subsets of genic regions  
    b) Calculating sliding-window heterozygosity across the genome and identifying outlier regions of elevated differentiation

Note that scripts were run individually in sequence, but could be combined into pipelines using [snakemake](https://snakemake.github.io/). 

