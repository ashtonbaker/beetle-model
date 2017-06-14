library(ggplot2)
library(magrittr)

read.csv(file="./results_global.csv") -> data

data %<>% subset(loglik != 0 & loglik.se < 1)

new.data <- data
data$loglik.max <- 0

paramnames = c("b", "cea", "cel", "cpa", "mu_A", "mu_L",
               "tau_E", "tau_L", "tau_P","od")

non.b.params = c("cea", "cel", "cpa", "mu_A", "mu_L",
                 "tau_E", "tau_L", "tau_P","od")

for (i in 1:(nrow(data))) {
  b.i <- old.data[i,'b']
  data.subset <- data[(data$b > b.i - 0.20)&(data$b < b.i + 0.20),]
  best <- data.subset[which.max(data.subset$loglik),]
  
  if (best$loglik > data[i, 'loglik']) {
    new.data[i, non.b.params] <- best[, non.b.params]
    new.data[i, 'loglik'] <- 0
    new.data[i, 'delta.loglik'] <- 1000
  }
}

new.data %>%
  subset(loglik < 0) %>%
  ggplot(aes(x=b, y=loglik)) + geom_point()

new.data %>% subset(loglik < 0) %>% pairs()
