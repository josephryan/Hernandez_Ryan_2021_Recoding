setwd("~/Dropbox/Dissertation/Ctenophore-Sponge_Debate/Paper/Post_Review_Analyses/Real_data_RCFV/Statistical_analyses/")
data <- read.csv('rcfv_real_v_sim.csv')
all<- stack(data)
all <-na.omit(all)
n<-ncol(data)
for (i in 1:n){print(shapiro.test(data[,i]))}
