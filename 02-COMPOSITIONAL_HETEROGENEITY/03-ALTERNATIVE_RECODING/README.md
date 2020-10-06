# Scripts to test alternative recoding strategies

### score.pl 
scores binning strategies based on the Dayhoff matrix; the score is the sum of intra-bin substitution scores

to run:

`perl score.pl DEHNQ ILMV FY AST KR G P C W`

### DAYHOFF
Dayhoff matrix

### chunkify_nscheme_recoding.pl
recodes simulated datasets using the best-scoring binning schemes for Dayhoff 9-, 12-, 15-, and 18-state recoding and generates shell scripts for maximum-likelihood analyses in RAxML

to run :

`mkdir 9scheme_scripts`

`perl chunkify_nscheme_recoding.pl 9 9scheme_scripts`

`mkdir 12scheme_scripts`

`perl chunkify_nscheme_recoding.pl 12 12scheme_scripts`

`mkdir 15scheme_scripts`

`perl chunkify_nscheme_recoding.pl 15 15scheme_scripts`

`mkdir 18scheme_scripts`

`perl chunkify_nscheme_recoding.pl 18 18scheme_scripts`

### comphet_bargraph_nscheme.R
produces are bar graph using comphet_proportion_nscheme.csv to show the percentage of incorrect trees reconstructed under each alternative recoding strategy, Dayhoff 6-state recoding, and non-recoding under the Dayhoff model

### comphet_proportion_nscheme.csv
proportion of incorrect trees reconstructed using alternative recoding strategies, Dayhoff 6-state recoding, and non-recoding with the Dayhoff model

### ztest_dayhoff_dayhoff18.R
perform z-tests on the percentages of incorrect trees reconstructed under non-recoding using the Dayhoff model and the best scoring Dayhoff 18-state recoding strategy

### comphet_proportion_NR_v_18.csv
number of incorrect trees reconstructed under non-recoding with the Dayhoff model and Dayhoff 18-state recoding
