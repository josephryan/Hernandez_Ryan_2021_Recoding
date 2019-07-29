setwd("~/Dropbox/Dissertation/Ctenophore-Sponge_Debate/fig_comphet")
data <- read.csv('Hernandez_Ryan_2019_RecodingSim/02-COMPOSITIONAL_HETEROGENEITY/02-HETEROGENEOUS_DATA/comphet_index.csv')
library(ggplot2)
p <-ggplot(data, aes(x=Tree, y=Comp.het.index)) + geom_point() + facet_wrap(vars(Inflation.parameter), scales = "free", dir="v")
p + scale_x_reverse(name="Branch length", breaks=c(0.008, 0.004, 0.002, 0.001)) + scale_y_continuous(name="Comp-het index") + labs (color="Inflation parameter") + geom_smooth(method=lm, se=FALSE)

                                                                                                                                         
