# Script to simulate compositionally heterogeneous datasets

### comphet.pl
produces compositionally heterogeneous datasets using hypothetical trees 0.008, 0.004, 0.002, and 0.001 (trees available in this repo in 01-MODULES/CompHet.pm)  
 
to run: 

`perl comphet.pl TREE0008 INFL NULL.out > pvals.out`  

INFL is the inflation parameter and NULL.out is the null distribution of comp-het indices (produced by using the scripts in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)

### comphet_index_scatter.R 
produces a scatter plot showing the relationship between the length of internode branches for each tree and comp-het index values for each inflation parameter tested using comphet_index.csv

### comphet_index.csv
file containing com-het index values for each dataset simulated
