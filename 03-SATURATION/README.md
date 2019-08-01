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
converts simulated datasets to Dayhoff-6 recoded datasets and generates shell scripts to perform maximum-likelihood analyses in RAxML

### compare_trees_to_sim.pl
scores trees reconstructed from simulated datasets using the Robinson-Foulds distance, performs t-tests on scores, and generates box-plots to visualize the data 
