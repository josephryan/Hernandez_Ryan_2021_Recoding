# Script to simulate compositionally heterogeneous datasets

### comphet.pl
produces compositionally heterogeneous datasets using hypothetical trees 0.008, 0.004, 0.002, and 0.001 (trees available in this repo in 01-MODULES/CompHet.pm)  
 
to run: 

`perl comphet.pl TREE0008 INFL NULL > pvals.0.1.out`

INFL: inflation parameter  

NULL: comp-het indices from null distribution (these are produced in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)
