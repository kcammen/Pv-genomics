#!/bin/bash

module load smcpp/1.15.5  

nboots=20

for boot in $(seq 1 $nboots); do
    echo smc++ estimate -o results/bootstraps/GOM/GOM_${boot} --cores 8 7.0e-9 bootstraps/GOM/GOM_${boot}/GOM_bootstrap_chr*.gz
done | xargs -L 1 -I CMD -P 5 bash -c CMD
