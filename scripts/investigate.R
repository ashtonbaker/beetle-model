library(ggplot2)

data <- read.csv(file="./results_global.csv")
data <- subset(data, tau_P < 0, select=c('b', 'loglik'))

p <- ggplot(data, aes(b, tau_P))
p + geom_line()

ggplot(data=subset(data,loglik>max(loglik)-100),aes(x=b,y=tau_P))+geom_point()
