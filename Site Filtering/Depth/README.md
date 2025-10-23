# remove outlier regions regarding depth across all samples (too low or too high).

Modified from https://github.com/GenisGE/impalascripts/tree/master/qc/sites_qc/impala_map/depth and https://github.com/GenisGE/warthogscripts/tree/main/analyses/qc/sites_qc/depth

Steps:

1. Get depth for each site, separately for low depth and high depth samples, in parallel across chromosomes: run `getDepthsLowHighDepthSamples.sh`

2. Combine global depth distribution across chromosomes: run `combineDepths.R`

3. Plot global depth distribution and filter thresholds (based on median global depth): run `plotDepths.R`

4. Make bed files with regions to remove based on min and max depth thresholds: run `doDepthFilter.sh` to call `doDepthFilter.py`

5. Combine the two groups (low cov and high cov) and produce final bed file with sites to keep after depth filtering: run `combineFilters.sh`
 
