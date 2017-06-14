library(ggplot2)
library(magrittr)

read.csv(file="./results_global.csv") -> old.data
new.data <- old.data
old.data$loglik.max <- 0

paramnames = c("b", "cea", "cel", "cpa", "mu_A", "mu_L",
               "tau_E", "tau_L", "tau_P","od")

non.b.params = c("cea", "cel", "cpa", "mu_A", "mu_L",
                 "tau_E", "tau_L", "tau_P","od")

for (i in 1:(nrow(old.data))) {
  b.i <- old.data[i,'b']
  data.subset <- old.data[(old.data$b > b.i - 0.15)&(old.data$b < b.i + 0.15),]
  best <- data.subset[which.max(data.subset$loglik),]
  
  if (best$loglik > old.data[i, 'loglik']) {
    new.data[i, non.b.params] <- best[, non.b.params]
    new.data[i, 'loglik'] <- 0
    new.data[i, 'delta.loglik'] <- 1000
  }
}

write.csv(new.data, './results_global.csv', row.names=FALSE)
