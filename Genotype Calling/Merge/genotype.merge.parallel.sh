#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

genolist=/path_to_project/genotype_merge/Pv.geno.list.noNovoGene.nomisID.noThyout.norel.txt
chrs=/path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt

numfiles=$(wc -l < "${genolist}") #will actually give numfiles-1 because last line doesn't end with newline character
inputfiles=$(tr '\n' ' ' < ${genolist}) #print all file names on a single line, separated by spaces
echo "Merging SNPs from ${numfiles} files: ${inputfiles}"

cat ${chrs} | while read chr
do
    echo bcftools merge ${inputfiles} -Ob -r ${chr} -o merged_depthmask2_${chr}.bcf.gz --threads 10
    #Merges files for a given chromosome, setting genotypes to missing for positions that aren't present in a given individual
    #Only AN and AC are updated by the merge command. Other tags can be updated using fill-tags if necessary.
done | xargs -L 1 -I CMD -P 5 bash -c CMD

cat ${chrs} | while read chr
do
    echo bcftools index merged_depthmask2_${chr}.bcf.gz --threads 10
done | xargs -L 1 -I CMD -P 5 bash -c CMD

#bcftools concat -Ob -o final_merged.bcf.gz $(ls merged_depthmask2_*.bcf.gz) --threads 50 
#bcftools index --threads 50 final_merged.bcf.gz
