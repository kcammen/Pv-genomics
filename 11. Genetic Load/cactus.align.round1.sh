#!/bin/bash

module load cactus/2.9.9

cactus-blast jobstore/3 steps-output/Pv_align.txt steps-output/Anc1.paf --root Anc1   --logFile steps-output/logs/blast-Anc1.log
cactus-align --restart jobstore/4 steps-output/Pv_align.txt steps-output/Anc1.paf steps-output/Anc1.hal --root Anc1   --logFile steps-output/logs/align-Anc1.log
hal2fasta steps-output/Anc1.hal Anc1 --hdf5InMemory > steps-output/Anc1.fa
