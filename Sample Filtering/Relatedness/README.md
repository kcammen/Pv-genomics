
# Identify duplicate and related individuals using ngsRelate: https://github.com/ANGSD/NgsRelate/blob/master/README.md. 

# Steps:

1. Generate a file with allele frequencies (.mafs.gz) and a file with genotype likelihoods (.glf.gz): `ngsRelate_prep.sh`

2. Extract the frequency column from the allele frequency file and remove the header (to make it in the format NgsRelate needs): `ngsRelate_getList.sh`

3. Run NgsRelate: `ngsRelate.sh`

4. Evaluate pairings with KING > 0.125 and select an individual to drop from each pair, preferentially dropping individuals that are present in multiple pairs (in order to keep as many individuals as possible) and/or have higher error rates.  
