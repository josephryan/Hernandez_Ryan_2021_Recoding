# Simulations of compositional heterogeneity on an asymmetric tree

### 01-TREE000C_1_1000, 02-TREE000C_5_1000, 03-TREE000C_9_1000 
directories in which to simulate compositionally heterogeneous datasets

### comphet.pl
symbolic link for script that produces compositionally heterogeneous datasets using Chang tree (available in this repo in 01-MODULES/CompHet.pm)

`perl comphet.pl TREE000C INFL LENGTH PAIRING NULL.out > pvals.out`

INFL is the inflation parameter, LENGTH is the sequence length for simulation, PAIRING is the starting amino acid frequency pairings (i.e., alphabetical or random) used by our algorithm to simulate compositional heterogeneity, and NULL.out is the null distribution of comp-het indices (produced by using the scripts in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)

### chunkify_estimate.pl
symbolic link for script that recodes simulated datasets using Dayhoff 6-state recoding and generates shell scripts for maximum-likelihood analyses in RAxML

### is_mono.pl
symbolic link for script that scores trees to determine the proportion of incorrect trees that were reconstructed under recoding and non-recoding approaches

`perl is_mono.pl MODEL (DAYHOFF OR JTT) > is_mono.out`

### comphet_bargraph_shape.R 
produces a bar graph showing the percentage of incorrect trees reconstructed under each method and level of compositional heterogeneity (inflation parameter) tested. This script uses the file comp_het_chang_proportion.csv
