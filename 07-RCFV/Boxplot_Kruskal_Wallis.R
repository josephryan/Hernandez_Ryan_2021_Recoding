setwd("~/Dropbox/Dissertation/Ctenophore-Sponge_Debate/Paper/Post_Review_Analyses/Real_data_RCFV/Statistical_analyses/")
data <- read.csv('rcfv_real_v_sim.csv')

#Box-plots of real data vs simulated data
library (ggplot2)
all<- stack(data)
all <-na.omit(all)
ggplot(all, aes(x=ind, y=values)) + geom_boxplot() + labs(x="Datasets", y="RCFV")

#Calculations of median for real vs simulated datasets with inflation parameter set to 0.9
high <- c(data$TREE0008.9, data$TREE0004.9, data$TREE0002.9, data$TREE0001.9)
median (high)
real<- c(data$REAL.DATA)
real <- na.omit(real)
median(real)

#Krukal-Wallis test
kruskal.test(values~ind, data=all)

#Pairwise Wilcoxon Rank Sum Test
pwt<-pairwise.wilcox.test(all$values, all$ind, p.adjust.method = "bonferroni")
sink("pwt.out")
print(pwt)
sink


