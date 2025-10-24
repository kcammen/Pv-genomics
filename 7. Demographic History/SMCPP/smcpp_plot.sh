#!/bin/bash

module load smcpp/1.15.5  

smc++ plot -g 14.8 -c plots/allpops_plot.png results/GOM/model.final.json results/HUD/model.final.json results/NFL/model.final.json results/GRN/model.final.json results/ICE/model.final.json results/SVA/model.final.json results/KAT/model.final.json results/WAD/model.final.json results/KAL/model.final.json
