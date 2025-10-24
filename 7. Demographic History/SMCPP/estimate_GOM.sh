#!/bin/bash

module load smcpp/1.15.5  

smc++ estimate -o results/GOM/ --cores 8 7.0e-9 smc_files/GOM_HiC_scaffold*.smc.gz

