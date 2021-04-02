data <- read.csv('medians.csv')
library(ggplot2)
p <-ggplot(data, aes(x=Branch.length, y=Median, color=Type)) + geom_point() + geom_line() + facet_wrap(~Model, scales = "free")
p + scale_x_continuous(name="Branch length scaling parameter") + scale_y_continuous(name="Median Robinson-Foulds distance") + labs (color="Method") + scale_color_manual(values= c("darkcyan", "#e6550d")) 
