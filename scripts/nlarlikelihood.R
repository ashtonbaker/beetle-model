library(reshape2)
library(dplyr)
library(magrittr)
# library(readr)

list(b=10.45,mu_L=0.2,mu_A=0.007629,
     cel=0.01731,cea=0.01310,cpa=0.004619,
     sigma_1=1.621,sigma_2=0.7375,sigma_3=0.01212) -> theta

read.csv("./data/data.csv") -> dat

dat %>%
  subset(rep==4,select=-c(cpa)) %>%
  mutate(
    mean_L=with(theta,b * A_obs * exp(-cel*L_obs - cea*A_obs)),
    mean_P=with(theta,L_obs * (1 - mu_L)),
    mean_A=with(theta,P_obs * exp(-cpa * A_obs) + A_obs * (1 - mu_A))
  ) %>%
  mutate(
    mean_L=c(NA,tail(mean_L,-1)),
    mean_P=c(NA,tail(mean_P,-1)),
    mean_A=c(NA,tail(mean_A,-1))
  ) %>%
  mutate(
    res_L=sqrt(L_obs)-sqrt(mean_L),
    res_P=sqrt(P_obs)-sqrt(mean_P),
    res_A=sqrt(A_obs)-sqrt(mean_A)
  ) %>%
  mutate(
    loglikL=with(theta,dnorm(res_L,mean=0,sd=sigma_1,log=TRUE)),
    loglikP=with(theta,dnorm(res_P,mean=0,sd=sigma_2,log=TRUE)),
    loglikA=with(theta,dnorm(res_A,mean=0,sd=sigma_3,log=TRUE))
  ) %>%
  summarize(
    loglik=sum(c(loglikL,loglikP,loglikA),na.rm=TRUE)
  )