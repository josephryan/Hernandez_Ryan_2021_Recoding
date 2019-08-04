# Simulations with parameters estimated from the Chang et al. (2015) dataset

### run_seqgen_estimated_model.sh
shell script to reproduce simulations performed in Seq-Gen

### divide_estimated_model.sh
shell script to create new directories for simulated datasets and parse into individual PHYLIP files

### chunkify_estimate.pl
converts simulated datasets to Dayhoff 6-state recoded datasets and generates shell scripts to perform maximum-likelihood analyses in RAxML

### compare_trees_to_sim_estimate.pl
scores trees using the Robinson-Fould distance, performs t-tests on scores between recoded and non-recoded datasets, and generates box-plots to visualize the data
