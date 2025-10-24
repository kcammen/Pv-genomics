#!/bin/bash

module load plink/1.9.0
module load perl/5.38.0 vcftools/0.1.16 
module load python/3.12.0

filteredvcf=final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01
popfile=/path_to_project/treeMix/California/popfile_wCalifornia.tsv

# Use VCFtools to make a map and a ped file, using only bi-allelic SNPs with mac 2 (also creates a log file)
vcftools --gzvcf /projects/mortentange/people/ngz409/treeMix/California/${filteredvcf}.vcf.gz \
         --plink --mac 2 --remove-indels --max-alleles 2 \
         --out ${filteredvcf}

# Adjust the map file to allow for non-human chromosome names (else the new plink version struggles)
awk -F"\t" '{
        split($2,chr,":")
	$1="1"
	$2="1:"chr[2]
        print $0
}' ${filteredvcf}.map > better.map
mv better.map ${filteredvcf}.map

# convert it to a stratified frq file, also creates .bed, .bim, .fam, .log, .nosex
plink --file ${filteredvcf} --make-bed --out ${filteredvcf} --allow-no-sex --allow-extra-chr 0
plink --bfile ${filteredvcf} --freq --missing --within ${popfile} --out ${filteredvcf} --allow-no-sex --allow-extra-chr 0

# zip it
gzip ${filteredvcf}.frq.strat

# create input file for Treemix
python3 plink2treemix.py ${filteredvcf}.frq.strat.gz ${filteredvcf}.treemix.frq

# unzip allele frequency information
#gunzip ${filteredvcf}.treemix.frq.gz
gunzip ${filteredvcf}.frq.strat.gz

# make a file with the positions
awk 'BEGIN{print "scaffold_pos\tscaffold\tpos"}{split($2,pos,":");print $2"\t"pos[1]"\t"pos[2]}' ${filteredvcf}.map > ${filteredvcf}.positions
paste ${filteredvcf}.positions ${filteredvcf}.treemix.frq > ${filteredvcf}.frequencies

awk '{printf $0
	for(i = 4; i <= NF; i++){
		split($i,values,",")
		if((values[1]+values[2])>0) freq=values[1]/(values[1]+values[2])
		else freq=0
		printf freq"\t"
	}
	printf "\n"}' ${filteredvcf}.frequencies > ${filteredvcf}.frequencies2
mv ${filteredvcf}.frequencies2 ${filteredvcf}.frequencies

#add cumulative position column, for ease of plotting
awk 'BEGIN{scaffold="";pos=0;newpos=0}
	{if($2==scaffold){newpos=pos+$3}else{scaffold=$2;pos=newpos};chpos=pos+$3;print $0,chpos}' \
	${filteredvcf}.frequencies > ${filteredvcf}.frequencies.newpos

gzip ${filteredvcf}.treemix.frq
