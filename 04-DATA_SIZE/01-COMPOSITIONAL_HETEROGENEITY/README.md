# Scripts to simulate and test compositionally heterogeneous datasets of varying size

### comphet.pl
symbolic link for script that produces compositionally heterogeneous datasets using hypothetical tree 0.002 (available in this repo in 01-MODULES/CompHet.pm)

`perl comphet.pl TREE0002 INFL LENGTH PAIRING NULL.out > pvals.out`

INFL is the inflation parameter, LENGTH is the sequence length for simulation, PAIRING is the starting amino acid frequency pairings (i.e., alphabetical or random) used by our algorithm to simulate compositional heterogeneity, and NULL.out is the null distribution of comp-het indices (produced by using the scripts in 02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION in this repo)

### 01-TREE0002.1.2000, 02-TREE0002.5.2000, 03-TREE0002.9.2000, 04-TREE0002.1.3000, 05-TREE0002.5.3000, 06-TREE0002.9.3000, 07-TREE0002.1.4000, 08-TREE0002.5.4000, 09-TREE0002.9.4000, 10-TREE0002.1.5000, 11-TREE0002.5.5000, 12-TREE0002.9.5000
directories in which to simulate compositionally heterogeneous datasets

### is_mono.pl
symbolic link for script that scores trees to determine the proportion of incorrect trees that were reconstructed under recoding and non-recoding approaches

`perl is_mono.pl MODEL (DAYHOFF OR JTT) > is_mono.out`

### comphet_bargraph_size.R
produces a bar graph showing the percentage of incorrect trees reconstructed under each method and level of compositional heterogeneity (inflation parameter) tested for datasets of varying size. This script uses the file comp_het_1000_5000_proportion.csv.csv

### comp_het_1000_5000_proportion.csv
proportion of incorrect trees for each phylogenetic reconstruction method, level of compositional heterogeneity, and data size
