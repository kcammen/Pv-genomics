
# Sample Filtering - Perfect Individual
To estimate relative error rates for each individual using the 'perfect individual' approach (Orlando et al. 2013). Inidividuals with high error rates were assumed to be mis-identified as harbor seals. 

## Steps:

1. Use ANGSD to estimate the relative error rate for each individual as a comparison of the number of derived alleles between each individual and an outgroup (gray seal, PV-074) and the number of derived alleles between the outgroup and a putatively error-free ("perfect") individual (i13, high coverage individual from a geographically central site in our dataset): `perfect_PV.74_i13.sh`
2. Reformat output so that it can be plotted: `peRfect.sh`
3. Visualize the relative error rates in R.
