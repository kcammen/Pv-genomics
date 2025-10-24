#!/bin/bash

module load cactus/2.9.9

cactus-blast jobstore/1 steps-output/Pv_align.txt steps-output/Anc2.paf --root Anc2   --logFile steps-output/logs/blast-Anc2.log
cactus-align jobstore/2 steps-output/Pv_align.txt steps-output/Anc2.paf steps-output/Anc2.hal --root Anc2   --logFile steps-output/logs/align-Anc2.log
hal2fasta steps-output/Anc2.hal Anc2 --hdf5InMemory > steps-output/Anc2.fa
