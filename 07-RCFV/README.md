# Comparisons of levels of compositional heterogeneity between real and simulated data

### 01-REAL_DATA
directory containing real data sampled from 25 publications that use 6-state recoding

### rcfv.pl
script calculates the average relative compositional frequency variability (RCFV) score from BaCoCa (Kück & Struck 2014)

`perl rcfv.pl –dir=/01-REAL_DATA --phylip --pattern=’phy$’ > REAL_DATA _rcfv_phy.out`

`perl rcfv.pl –dir=/01-REAL_DATA --fa --pattern=’fa$’ > REAL_DATA_rcfv_fa.out`

### normality_test.R
tests if the RCFV scores generated from real and simulated data are normally distributed using the Shapiro-Wilk’s test. This script uses the file rcfv_real_v_sim.csv

### rcfv_real_v_sim.csv
RCFV scores for each real and simulated dataset
