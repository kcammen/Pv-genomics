# Sample Filtering - Initial PCAs
To identify outlier samples that have been mis-identified and filter samples from a mixed haulout site. 

## Steps:

### Initial PCA to identify individuals that are likely mis-identified as harbor seals

1. Generate the beagle file needed to run PCAngsd: `init_PCAngsd_prep.sh`
2. Run PCAngsd to create a covariance matrix of genetic distance among individuals: `init_PCAngsd.sh`
3. Visualize the PCA plot in R and identify mis-identified individuals as those that are located very far from the majority of individuals.

### Secondary PCA to assign individuals from a mixed haulout site (Thyboron) to either the Wadden Sea or Limfjord breeding colonies. 

4. After removing mis-identified individuals, generate a beagle file needed to run PCAngsd again: `Thy_PCAngsd_prep.sh`
5. Run PCAngsd to create a covariance matrix of genetic distance among individuals: `Thy_PCAngsd.sh`
6. Visualize the PCA plot in R and identify assign breeding colony (Wadden Sea or Limfjord) based on proximity of Thyboron individuals to Kattegat. 
