# Simulations of compositional heterogeneity with an algorithm that randomly pairs starting amino acid frequencies

### 01-TREE0002_1_1000_RANDOM, 02-TREE0002_5_1000_RANDOM, 03-TREE0002_9_1000_RANDOM
directories in which to simulate compositionally heterogeneous datasets

### comphet.pl
symbolic link for script that produces compositionally heterogeneous datasets using hypothetical tree 0.002 (available in this repo in 01-MODULES/CompHet.pm)

`perl comphet.pl TREE0002 INFL LENGTH RANDOM NULL.out > pvals.out`

INFL is the inflation parameter, LENGTH is the sequence length for simulation, RANDOM is the starting amino acid frequency pairings used by our algorithm to simulate compositional heterogeneity, and NULL.out is the null distribution of comp-het indices (produced by using the scripts in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)

### chunkify_estimate.pl
symbolic link for script that recodes simulated datasets using Dayhoff 6-state recoding and generates shell scripts for maximum-likelihood analyses in RAxML

### is_mono.pl
symbolic link for script that scores trees to determine the proportion of incorrect trees that were reconstructed under recoding and non-recoding approaches

`perl is_mono.pl MODEL (DAYHOFF OR JTT) > is_mono.out`

### comphet_bargraph_random.R
produces a bar graph showing the percentage of incorrect trees reconstructed under each method and level of compositional heterogeneity (inflation parameter) tested. This script uses the file comp_het_random_proportion.csv.
