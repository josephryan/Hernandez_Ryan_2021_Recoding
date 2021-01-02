# Scripts to simulate and test compositionally heterogeneous datasets of varying size

### 01-TREE0002.1.2000, 02-TREE0002.5.2000, 03-TREE0002.9.2000, 04-TREE0002.1.3000, 05-TREE0002.5.3000, 06-TREE0002.9.3000, 07-TREE0002.1.4000, 08-TREE0002.5.4000, 09-TREE0002.9.4000, 10-TREE0002.1.5000, 11-TREE0002.5.5000, 12-TREE0002.9.5000
directories in which to simulate compositionally heterogeneous datasets

### comphet_bargraph_size.R
produces a bar graph showing the percentage of incorrect trees reconstructed under each method and level of compositional heterogeneity (inflation parameter) tested for datasets of varying size. This script uses the file comp_het_proportion_reconstruction.csv

### is_mono.pl
symbolic link for script that scores trees to determine the proportion of incorrect trees that were reconstructed under recoding and non-recoding approaches
