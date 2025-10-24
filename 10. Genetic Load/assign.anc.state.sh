#!/bin/bash

module load gcc/13.2.0 R/4.0.3  
module load tabix/1.11 
module load htslib/1.22
module load vcftools/0.1.17
module load java-jdk/8.0.112  

zgrep -v "^##" snpEff/high_impact.vcf.gz | cut -f 1,2,4,5 | gzip > snpEff/high_impact_snps.tsv.gz

#I ran the R script on my local computer because of package issues on the computing cluster.
#Rscript ancient_alleles_assignment.R > r_ancestral_ref_proposal.log 2>&1

bgzip anc_allele_assignment.bed
tabix -s 1 -b 2 -e 3 anc_allele_assignment.bed.gz

zcat snpEff/high_impact.vcf.gz | \
    vcf-annotate -a anc_allele_assignment.bed.gz \
    -d key=INFO,ID=AA,Number=1,Type=String,Description='Ancestral Allele' \
    -c CHROM,FROM,TO,INFO/AA > high_impact_ann_anc_allele.vcf

#Recode genotypes to 0 = ancestral and 1 = derived
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/AA\t[%GT\t]\n' high_impact_ann_anc_allele.vcf | \
awk '{
  ref=$3; alt=$4; aa=$5;
  # For each sample genotype starting in column 6
  for (i=6; i<=NF; i++) {
    gt=$i;
    if (aa == ref) {
      # REF is ancestral → keep coding
      if (gt=="0/0" || gt=="0|0") $i=0;
      else if (gt=="0/1" || gt=="1/0" || gt=="0|1" || gt=="1|0") $i=1;
      else if (gt=="1/1" || gt=="1|1") $i=2;
      else $i=".";
    }
    else if (aa == alt) {
      # ALT is ancestral → flip coding
      if (gt=="0/0" || gt=="0|0") $i=2;
      else if (gt=="0/1" || gt=="1/0" || gt=="0|1" || gt=="1|0") $i=1;
      else if (gt=="1/1" || gt=="1|1") $i=0;
      else $i=".";
    }
    else {
      # Ancestral allele not matching REF or ALT
      $i=".";
    }
  }
  print
}' > high_impact_ann_anc_allele_recode.tsv
