library(pomp)
library(magrittr)
library(reshape2)

source('models/step-model/step-model.R')


read.csv("./data/data.csv") %>%
  subset(weeks <= 40, select=c(weeks,rep,L_obs,P_obs,A_obs)) -> dat

read.csv("./data/optim_params.csv") -> p_est
p_est[c("b", "cea", "cel", "cpa", "mu_A", "mu_L","tau_E", "tau_L", "tau_P","od")] -> p_est
p_mean = colMeans(p_est)
p_mean['cpa_force'] <- 0.05
p_mean['mu_A_force'] <- 0.96

model <- step.model(data = subset(dat, rep == 1, select=-rep), params = p_mean)