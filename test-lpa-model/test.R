library(pomp)
library(magrittr)
library(reshape2)

source('./models/lpa-model/lpa-model.R')

read.csv("../data/data.csv") %>%subset(weeks <= 40, select=c(weeks,rep,L_obs,P_obs,A_obs)) -> dat
mle_params <- c(b=10.67, mu_L=0.1955, mu_A=0.007629, cel=0.01647, cea=0.1313, cpa=0.004315)

model <- lpa.model(data=subset(dat, rep == 4), params = mle_params)


ll <- 0
for (i in 1:24) {
  print(i)
  model <- lpa.model(data=subset(dat, rep == i), params = mle_params)
  pf <- pfilter(model, Np = 100000)
  ll += logLik(pf)
}