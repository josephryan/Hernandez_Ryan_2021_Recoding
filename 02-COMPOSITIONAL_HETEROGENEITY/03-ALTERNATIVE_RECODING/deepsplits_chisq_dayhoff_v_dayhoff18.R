setwd("/Hernandez_Ryan_2019_RecodingSim/02-COMPOSITIONAL_HETEROGENEITY/03-ALTERNATIVE_RECODING")
data <- read.csv('comphet_NR_v_18.csv')
nm<-row(data)
n<-nm[,1]
for (i in n){
  d<-data$Dayhoff[i]
  d18<-data$Dayhoff.18.Recoded[i]
  dayhoff.vector=cbind(d,d18)
  dayhoff.results<-chisq.test(x=dayhoff.vector)
  print(dayhoff.results)
}
