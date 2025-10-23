# filter to remove regions with extreme excess of heterozygosity, usually caused by mapping errors due to paralogs regions. Steps:

1. Make beagle file from all the genome: `makeBeagleRaw.sh`

2. Calculate per-site inbreeding coefficients accounting for population structure and perform likehood ratio test for detecting sites deviating from HWE: `doHWEpcangsd.sh`

3. Use pcangsd inbreeding and hwe test output to remove windows around loci showing evidence for extreme excess of heterozygosity: `doHWEfilter.R`

4. Make bed file with regions to keep using output of 3: `doKeepList.sh`
