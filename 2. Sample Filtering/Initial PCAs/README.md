# Sample Filtering - Initial PCAs
To identify outlier samples that have been mis-identified and filter samples from a mixed haulout site. 

## Steps:
1. Generate the beagle file needed to run PCAngsd: `init_PCAngsd_prep.sh`
2. Run PCAngsd to create a covariance matrix of genetic distance among individuals: `init_PCAngsd.sh`
3. Visualize the PCA plot in R
