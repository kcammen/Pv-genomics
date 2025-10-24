#!/bin/bash

module load treemix/1.13

filteredvcf=final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01

#-m 0 no migration edges
treemix -i ${filteredvcf}.treemix.frq.gz -m 0 -o ${filteredvcf}.m0 -root California -bootstrap -k 500
