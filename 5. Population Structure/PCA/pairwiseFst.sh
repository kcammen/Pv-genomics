#!/bin/bash

module load plink/2.0.0

inputfile=/path_to_project/pca_final/woLDprune/Pv_merged_woLDprune
popfile=/path_to_project/pca_final/popfile.tsv

plink2 --bfile $inputfile --allow-extra-chr \
--within $popfile \
--fst CATPHENO method=hudson \
--out Pv_merged_woLDprune_HudsonFst --threads 8
