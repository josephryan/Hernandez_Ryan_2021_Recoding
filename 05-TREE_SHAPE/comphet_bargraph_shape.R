data <- read.csv('comp_het_chang_proportion.csv')
data$proportion <- data$proportion*100
names(data)[3]<-"percent"
library(ggplot2)
b <- ggplot(data, aes(x=inflation.parameter, y=percent)) + geom_bar(aes(fill=type), stat = "identity", position=position_dodge2(preserve = c("total"), padding = 0.2)) 
b + scale_x_continuous(name="Inflation parameter (level of compositional heterogeneity)", breaks =c(0.1, 0.5, 0.9), label=c("0.1","0.5","0.9"), expand = c(0, 0)) + scale_y_continuous(name="Percentage of incorrect trees (%)", expand = c(0, 0), limits=c(0,70)) + labs(fill="Matrix") + scale_fill_manual(values=c("#756bb1","#e6550d"))
