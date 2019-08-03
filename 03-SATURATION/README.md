#Substitution saturation analyses

### 00-DATA
data used for simulations

### 01-SATUARTION_TEST
simulation experiment to test if increasing the branch length scaling factor parameter in Seq-Gen increases instances of saturation

### 02-SEQ_GEN_CHANG
simulation of saturated datasets using the Chang et al. (2015) topology

### 03-SEQ_GEN_FEUDA
simulation of saturated datasets using the Feuda et al. (2017) topology

### divide.pl
script that creates new directories for simulated data and parses the datasets into separate PHYLIP files within corresponding directories

### chunkify.pl
converts simulated datasets to Dayhoff 6-state and S&R 6-state recoded datasets and generates shell scripts to perform maximum-likelihood analyses in RAxML

### compare_trees_to_sim.pl
scores trees reconstructed from simulated datasets using the Robinson-Foulds distance, performs t-tests on scores, and generates box-plots to visualize the data

### robinson_foulds_medians_fig.r
produces a line graph with median Robinson-Foulds distances for each tree, model, and branch length scaling factor parameter tested using medians.csv

### medians.csv 
median Robinson-Foulds distances of trees reconstructed using recoding and non-recoding methods

### chunkify_LG.pl
generates shell scripts to perform maximum-likelihood analyses in RAxML using the LG model for datasets that were simulated using the Chang et al. (2015) topology and branch length scaling factors 1, 5, 10, 15, and 20

### compare_trees_to_sim_LG.pl
uses the Robinson-Foulds distance to score trees reconstructed with the LG model, performs t-tests on scores between recoded and non-recoded datasets, and generates box-plots to visualize the data
