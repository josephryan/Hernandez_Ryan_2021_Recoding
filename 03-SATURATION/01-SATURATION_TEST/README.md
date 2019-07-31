## seq-gen_saturation_test.pl
script runs seq-gen commands with an increasing branch length scaling factor, and then calculates instances of saturation that occur between nodes.
It uses the simple bifurcating test.tre as input. Despite being an underestimate of saturation, it shows the effect of the scaling factor on saturation levels.

## Results
To test if increasing the "branch-length scaling factor" parameter in seq-gen (-s) also increased the saturation level, we performed a simple simulation experiment with a six-taxa bifurcating tree. We ran five instances of seq-gen on this tree with incrementing "branch-length scaling factors" (i.e., 1.0, 2.0, 3.0, 4.0, and 5.0) and set the "write ancestral sequences for each node" parameter (i.e., -w a), which printed ancestral sequences at each node. We then calculated the number of saturation events (i.e., the number of times a change in an amino acid led to the appearance of an amino acid that had been in that same position in a prior ancestral node) using a custom perl script (seq-gen_saturation_test.pl). The number of saturation events increased linearly as the scaling factor increased (1.0=34, 2.0=84, 3.0=138, 4.0=160, 5.0=204), suggesting that the "branch-length scaling factor" is a reasonable parameter for introducing saturation into our simulations. These results can be seen in **scaling_vs_saturation.pdf**.

**NOTE**: Since ancestral states are only reported at nodes, these saturation values are underestimates.

