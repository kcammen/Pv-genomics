#!/bin/bash

module load smcpp/1.15.5  

nboots=20

for boot in $(seq 1 $nboots); do
    #Copy individual datasets into joint folder
    cp bootstraps/GOM/GOM_$boot/bootstrap_chr*.gz bootstraps/GOM_GRN/GOM_GRN_$boot/
    cp bootstraps/GRN/GRN_$boot/bootstrap_chr*.gz bootstraps/GOM_GRN/GOM_GRN_$boot/

    #Create datasets containing the joint frequency spectrum for both populations - already bootstrapped

    #Run split to refine the marginal estimates into an estimate of the joint demography:
    mkdir split/bootstraps/GOM_GRN/GOM_GRN_$boot

    smc++ split --cores 4 -o split/bootstraps/GOM_GRN/GOM_GRN_$boot results/bootstraps/GOM/GOM_$boot/model.final.json results/bootstraps/GRN/GRN_$boot/model.final.json bootstraps/GOM_GRN/GOM_GRN_$boot/*.gz

    split_time=$(grep split split/bootstraps/GOM_GRN/GOM_GRN_$boot/model.final.json | awk '{print $2}' | tr -d ',')
    N0=$(grep N0 split/bootstraps/GOM_GRN/GOM_GRN_$boot/model.final.json | awk '{print $2}' | tr -d ',' | head -n 1)

    split_time_years=$(awk -v s="$split_time" -v n="$N0" 'BEGIN { print s * 2 * n * 14.8 }')
    echo "GOM_GRN_split bootstrap $boot $split_time_years"
done
