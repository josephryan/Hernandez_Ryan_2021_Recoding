data <- read.csv('rcfv_real_v_sim.csv')
all<- stack(data)
all <-na.omit(all)
n<-ncol(data)
for (i in 1:n){print(shapiro.test(data[,i]))}
