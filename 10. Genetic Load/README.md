
# Genetic Load
To evaluate individual mutational load; modified from https://github.com/k-hench/elephant_seals

## Steps:
### To build a custom snpEff database:

1. Extract protein and coding sequences from the harbor seal annotation: `extract.cds.sh` 

2. Convert gff3 to gtf file: `convert.gff.sh` 

3. Edit snpEff.config by adding: "GSC_HSeal_1.0_HiC.genome : Harbor seal"

4. Build a custom snpEff database. As part of this process, it will check its output against the cds and protein files we created: `build.snpeff.db.sh`  
Confirmed in log file that error percentages were below 2

5. Annotate VCF file and filter to include only variants that are categorized as high-impact (typically loss-of-function): `snpeff.ann.sh` (138 SNPs)

### To assign ancestral state to alleles, you must first make a multi-species genome alignment (harbor seal, gray seal, spotted seal, and stone marten genome). 

6. Download and soft-mask reference genomes: `cactus.genomes.sh` 

https://dnazoo.s3.wasabisys.com/index.html?prefix=Phoca_largha
Phoca_largha_HiC.fasta.gz
Phoca_largha_HiC.repeatmasker.trf.windowmasker.gff.gz

https://dnazoo.s3.wasabisys.com/index.html?prefix=Halichoerus_grypus/
Halichoerus_grypus_HiC.fasta.gz
Halichoerus_grypus_HiC.repeatmasker.trf.windowmasker.gff.gz

https://dnazoo.s3.wasabisys.com/index.html?prefix=Martes_foina/
mfoi.min_150.pseudohap2.1_HiC.fasta.gz
mfoi.min_150.pseudohap2.1_HiC.repeatmasker.trf.windowmasker.gff.gz

7. Use mash to estimate branch lengths between genomes: `cactus.genomes.branch.lengths.sh` 

8. Create seqFile.txt containing Newick tree with roughly estimated branch lengths and paths to genomes

9. Run cactus-prepare to print blocks of text (to the log file) that will allow us to run Cactus in smaller jobs: `cactus.prepare.sh` 

10. Run each chunk of Cactus jobs: `cactus.preprocess.sh`, `cactus.align.round0.sh`, `cactus.align.round1.sh`, `cactus.align.round2.sh`, `cactus.hal.merge.sh`

To see resulting tree: halStats --tree Pv_align_steps.hal
(((Phoca_vitulina:0.0008,Phoca_largha:0.0006)Anc2:0.0027,Halichoerus_grypus:0.0013)Anc1:0.088,Martes_foina:0)Anc0

### To assign ancestral alleles: 
Modified from https://github.com/k-hench/elephant_seals/blob/master/code/workflow/rules/ancestral_alleles.smk

11. Extract SNPs between harbor seal genome and harbor seal/spotted seal ancestor `extract.anc.SNPs.sh` 

12. Assign ancestral state to high-impact alleles: `assign.anc.state.sh` 
