library(pomp)
library(magrittr)
library(reshape2)

source('./models/nlar-model/nlar-model.R')

read.csv("../data/data.csv") %>%subset(weeks <= 40, select=c(weeks,rep,L_obs,P_obs,A_obs)) -> dat
cls_params <- c(b=10.45, mu_L=0.2000, mu_A=0.007629, cel=0.01731, cea=0.1310, cpa=0.004619,
                sigma_1=1.621, sigma_2=0.7375, sigma_3=0.01212)

ll <- 0
for (i in 1:24) {
  print(i)
  model <- nlar.model(data=subset(dat, rep == i), params = cls_params)
  pf <- pfilter(model, Np = 100000)
  ll = ll + logLik(pf)
}