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
