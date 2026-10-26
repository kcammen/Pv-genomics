#!/bin/bash

module load cactus/2.9.9

halSnps cactus_align/steps-output/Pv_align_steps.hal Phoca_vitulina Anc2 --tsv Pv_anc2_snps.tsv --noDupes
gzip Pv_anc2_snps.tsv
