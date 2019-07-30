# Script to simulate compositionally heterogeneous datasets

### comphet.pl
produces compositionally heterogeneous datasets using hypothetical trees 0.008, 0.004, 0.002, and 0.001 (trees available in this repo in 01-MODULES/CompHet.pm)  
 
to run: 

`perl comphet.pl TREE0008 INFL NULL.out > pvals.out`  

INFL is the inflation parameter and NULL.out is the null distribution of comp-het indices (produced by using the scripts in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)

### comphet_index_scatter.R 
produces a scatter plot showing the relationship between the length of internode branches for each tree and comp-het index values for each inflation parameter tested using comphet_index.csv

### comphet_index.csv
com-het index values for each simulated dataset

### chunkify_comphet_trees.pl
recodes simulated datasets using Dayhoff 6-state recoding and S&R 6-state recoding and generates shell scripts for maximum-likelihood analyses in RAxML

### is_mono.pl
scores trees to determine the proportion of incorrect trees that were reconstructed under recoding and non-recoding approaches

### parapruner_is_mono.py
is_mono.pl implements parapruner_is_mono.py to test if trees recovered the two compositionally heterogeneous 10-taxa clades (i.e., a clade containing all A and B taxa and a clade containing all C and D taxa) 

### comphet_bargraph.R 
produces a bar graph showing the percentage of incorrect trees reconstructed under each method, tree used for simulation, and level of compositional heterogeneity (inflation parameter) tested using comp_het_proportion_reconstruction.csv

### comp_het_proportion_reconstruction.csv
proportion of incorrect trees for each phylogenetic reconstruction method, tree used for simulation, and level of compositional heterogeneity
