# Scripts to test alternative recoding strategies

### score.pl 
scores binning strategies based on the Dayhoff matrix; the score is the sum of intra-bin substitution scores

to run:

`perl score.pl DEHNQ ILMV FY AST KR G P C Q`

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
produces are bar graph showing the percentage of incorrect trees reconstructed under each alternative recoding strategy, as well as under Dayhoff 6-state recoding, and non-recoding under the Dayhoff model using comphet_proportion_nscheme.csv

### comphet_proportion_nscheme.csv
proportion of incorrect trees reconstructed using alternative recoding strategies, Dayhoff 6-state recoding, and non-recoding with the Dayhoff model
