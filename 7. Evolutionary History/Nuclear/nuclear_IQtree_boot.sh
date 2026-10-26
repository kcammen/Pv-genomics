#!/bin/bash

module load python/3.12.8
module load iqtree/2.4.0

vcffile=/pathtoproject/rangeExp/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.vcf.gz

python3 vcf2phylip.py -i ${vcffile} --output-folder vcf2phylip_out --outgroup PV293

#iqtree -s vcf2phylip_out/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.min4.phy -st DNA -m MFP+ASC -nt AUTO  -redo
#iqtree -s vcf2phylip_out/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.min4.phy.varsites.phy -st DNA -m MFP+ASC -nt AUTO  -redo

iqtree -s vcf2phylip_out/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.min4.phy.varsites.phy -st DNA -m GTR+F+ASC+R4 -nt AUTO -B 1000 -redo
