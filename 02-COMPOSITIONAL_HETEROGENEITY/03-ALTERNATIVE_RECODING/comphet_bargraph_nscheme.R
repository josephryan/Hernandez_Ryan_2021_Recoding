data <- read.csv('comphet_proportion_nscheme.csv')
data$proportion <- data$proportion*100
names(data)[2]<-"percent"
library(ggplot2)
library(tidyverse)

data$type <- with(data,factor(type,levels = c('Dayhoff','Dayhoff-18 Recoded','Dayhoff-15 Recoded', 'Dayhoff-12 Recoded', 'Dayhoff-9 Recoded', 'Dayhoff-6 Recoded')))
b <- ggplot(data, aes(x=inflation.parameter, y=percent)) + 
  geom_bar(aes(fill=type), stat = "identity", position=position_dodge2(preserve = c("total"), padding = 0.2)) +
  facet_wrap(~inflation.parameter, scales = "free")

b + scale_x_continuous(name="Inflation parameter (level of compositional heterogeneity)", breaks =c(0.1, 0.5, 0.9), label=c("0.1","0.5","0.9"), expand = c(0, 0)) + 
  scale_y_continuous(name="Percentage of incorrect trees (%)", expand = c(0, 0), limits=c(0,40)) + 
  labs(fill="Matrix")  + scale_fill_manual(values=c("midnightblue", "lightpink4", "#756bb1","darkcyan", "#e6550d", "tan"))
