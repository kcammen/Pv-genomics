#!/bin/bash

module load cactus/2.9.9

cactus-prepare seqFile.txt --outDir steps-output --outSeqFile steps-output/Pv_align.txt --outHal steps-output/Pv_align_steps.hal --jobStore jobstore
