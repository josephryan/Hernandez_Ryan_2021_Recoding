# Scripts to simulate datasets for a null distribution

### split_random_runs.pl
generates shell scripts to perform 1,000,000 simulations on hypothetical trees 0.008, 0.004, 0.002, and 0.001 (trees available in this repo in 01-MODULES/CompHet.pm)   

to run:

`perl split_random_runs.pl TREE0008`

### get_random_comphets.pl
shell scripts generated from split_random_runs.pl implement the get_random_comphets.pl script to produce datasets with no induced compositional heterogeneity
