setwd("/Hernandez_Ryan_2019_RecodingSim/02-COMPOSITIONAL_HETEROGENEITY/01-NULL_DISTRIBUTION/03-TREE0002/")
data <- read.csv('tree0.002_proportions.csv')
data$proportion <- data$proportion*100
names(data)[2]<-"percent"
library(ggplot2)
#replace values for visual purposes
data$inflation.parameter[data$inflation.parameter == "0"] <- "0.25"
data$inflation.parameter[data$inflation.parameter == "0.1"] <- "0.50"
data$inflation.parameter[data$inflation.parameter == "0.5"] <- "0.75"
data$inflation.parameter[data$inflation.parameter == "0.9"] <- "1.00"
b <- ggplot(data, aes(x=inflation.parameter, y=percent)) + geom_bar(aes(fill=type), stat = "identity", position=position_dodge2(preserve = c("total"), padding = 0.2)) 
b + scale_x_discrete(name="Inflation parameter (level of compositional heterogeneity)", breaks =c("0.25", "0.50", "0.75", "1.00"), label=c("0", "0.1","0.5","0.9")) + scale_y_continuous(name="Percentage of incorrect trees (%)", expand = c(0, 0), limits=c(0,70)) + labs(fill="Matrix") + scale_fill_manual(values=c("#bcbddc", "#756bb1","#fdae6b", "#e6550d"))
