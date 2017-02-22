library(ggplot2)

data <- read.table(file="./results_global.csv")

p <- ggplot(data, aes(b, loglik))
p + geom_line()
