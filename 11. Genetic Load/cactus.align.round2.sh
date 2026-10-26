#!/bin/bash

module load cactus/2.9.9

cactus-blast jobstore/5 steps-output/Pv_align.txt steps-output/Anc0.paf --root Anc0   --logFile steps-output/logs/blast-Anc0.log
cactus-align jobstore/6 steps-output/Pv_align.txt steps-output/Anc0.paf steps-output/Pv_align_steps.hal --root Anc0   --logFile steps-output/logs/align-Anc0.log
hal2fasta steps-output/Pv_align_steps.hal Anc0 --hdf5InMemory > steps-output/Anc0.fa
