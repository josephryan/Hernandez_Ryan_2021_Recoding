setwd("/Hernandez_Ryan_2019_RecodingSim/02-COMPOSITIONAL_HETEROGENEITY/03-ALTERNATIVE_RECODING")
data <- read.csv('comphet_proportion_NR_v_18.csv')
nm<-row(data)
n<-nm[,1]
for (i in n){
  d<-data$Dayhoff[i]
  d18<-data$Dayhoff.18.Recoded[i]
  dayhoff.vector=cbind(d,d18)
  dayhoff.results<-prop.test(x=dayhoff.vector, n=c(1000, 1000), alternative="greater")
  print(dayhoff.results)
}
