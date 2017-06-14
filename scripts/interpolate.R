library(ggplot2)
library(magrittr)

read.csv(file="./results_global.csv") -> data

paramnames = c("b", "cea", "cel", "cpa", "mu_A", "mu_L",
               "tau_E", "tau_L", "tau_P","od")

non.b.params = c("cea", "cel", "cpa", "mu_A", "mu_L",
                 "tau_E", "tau_L", "tau_P","od")

for (i in 1:(nrow(data - 2))) {
  j <- i + 1
  k <- i + 2
  
  if ((data[j,'loglik'] > data[k,'loglik']) && (data[i,'loglik'] > data[k,'loglik'])
      && (data[i,'loglik'] != 0) && (data[k,'loglik'] != 0)){
    data[k, non.b.params] <- ((data[i,non.b.params] + data[k,non.b.params])/2)[,non.b.params]
    data[k, 'loglik'] <- 0
    data[k, 'delta.loglik'] <- 1000
  }
}

write.csv(data, './results_global.csv', row.names=FALSE)
