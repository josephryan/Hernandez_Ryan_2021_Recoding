setwd("~/Dropbox/Dissertation/Ctenophore-Sponge_Debate/fig_comphet")
data <- read.csv('chisqrtest_comphet.csv')
nm<-row(data)
n<-nm[,1]
for (i in n){
  d<-data$Dayhoff[i]
  d6<-data$Dayhoff.6.Recoded[i]
  dayhoff.vector=cbind(d,d6)
  dayhoff.results<-chisq.test(x=dayhoff.vector)
  print(dayhoff.results)
  j<-data$JTT[i]
  s6<-data$S.R.6.Recoded[i]
  jtt.vector=cbind(j,s6)
  jtt.results<-chisq.test(x=jtt.vector)
  print (jtt.results)
}

