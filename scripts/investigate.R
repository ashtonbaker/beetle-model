library(ggplot2)

data <- read.csv(file="./results_global.csv", sep=' ')

p <- ggplot(data, aes(b, loglik))
p + geom_line()

ggplot(data=subset(data,loglik>max(loglik)-100),aes(x=b,y=loglik))+geom_point()
