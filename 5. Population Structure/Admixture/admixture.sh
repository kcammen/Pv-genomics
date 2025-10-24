#!/bin/bash

module load admixture/1.3.0

mergedplink=/path_to_project/admixture/Pv_merged.bed

for K in {1..9}; do
  admixture -j4 --cv=10 ${mergedplink} $K | tee log${K}.out
done

grep -h "CV error" log*.out > CVerrors.txt
