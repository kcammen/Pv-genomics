#!/bin/bash

module load mash/2.3

# Build mash sketches
mash sketch -o harbor GSC_HSeal_1.0_HiC.softmasked.fa.gz
mash sketch -o spotted Phoca_largha_HiC.softmasked.fa.gz
mash sketch -o gray Halichoerus_grypus_HiC.softmasked.fa.gz
mash sketch -o marten mfoi.min_150.pseudohap2.1_HiC.softmasked.fa.gz

# Compare all genomes
mash triangle harbor.msh spotted.msh gray.msh marten.msh > mash_all.tri
