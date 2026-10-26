#!/bin/bash

module load cactus/2.9.9

halAppendSubtree steps-output/Pv_align_steps.hal steps-output/Anc1.hal Anc1 Anc1 --merge --hdf5InMemory
halAppendSubtree steps-output/Pv_align_steps.hal steps-output/Anc2.hal Anc2 Anc2 --merge --hdf5InMemory
