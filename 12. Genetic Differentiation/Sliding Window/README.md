
# Genetic Differentiation - Sliding Window 
Calculate pairwise Fst in sliding windows across the genome to identify outlier regions potentially indicative of differential selection (local adaptation) occuring between populations. 
Modified from: https://github.com/popgenDK/seqAfrica_wildebeest/blob/main/Fst_scan/window_Fsthudson.v3.py

## Steps:

1. From merged and filtered genotype files, calculate Hudson's pairwise Fst in sliding windows across the genome for every possible population pair: `window_Fsthudson.sh`
