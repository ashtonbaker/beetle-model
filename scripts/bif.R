library(pomp)

dat <- read.csv('./results_global.csv')
dat <- subset(dat, loglik.se < 1)
dat[which.max(dat$loglik),] %>% 
  subset(select=-c(loglik, delta.loglik, loglik.se)) -> p


source('./models/step-model/step-model.R')

step.model(data = subset(read.csv('../data/data.csv'), rep == 4, select = -rep),
           params = c(unlist(p)))
