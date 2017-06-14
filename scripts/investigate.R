library(ggplot2)
library(magrittr)

read.csv(file="./results_global.csv") -> data

data %>%
#  subset((loglik < 0) & (loglik > -7500)) %>%
  ggplot(aes(x=b, y=loglik)) + geom_point()

# Diagnostics to track after updates
data %>% subset(loglik < 0,select=c('loglik')) %>% unlist() %>% as.numeric() %>% mean()
data %>% subset(abs(delta.loglik) < 1000, select=c(delta.loglik)) -> a;a<-a>0; a %>% as.logical() %>%
  as.integer() %>% mean()
data %>% subset(loglik == 0) %>% nrow()

data %>%
  subset(abs(delta.loglik) < 1000) %>%
  ggplot(aes(x=b, y=delta.loglik)) + geom_point()

data %>%
  subset(delta.loglik < 1000) %>%
  pairs()


