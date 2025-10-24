#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.22

mergedvcf=/path_to_project/genotype_merge/final_merged_depthmask2_bialleleSNPsonly_maf05_renamed_w16.vcf.gz

#Estimate allele frequencies across all populations.
bcftools roh ${mergedvcf} -e - --output-type rz > ROH_bcftools.tsv.gz
    
zcat ROH_bcftools.tsv.gz | awk '
BEGIN { OFS="\t"; print "Sample", "Sum" }
# Skip header or comment lines
/^#/ { next }
{
    if (!($2 in sum)) order[++n] = $2
    sum[$2] += $6
}
END {
    for (i = 1; i <= n; i++)
        print order[i], sum[order[i]]
}' > ROH_bcftools_indiv.tsv
