library(pomp)
library(magrittr)
library(reshape2)

source('./models/nlar-model/nlar-model.R')

read.csv("../data/data.csv") %>%subset(weeks <= 40, select=c(weeks,rep,L_obs,P_obs,A_obs)) -> dat

dat %>%
  melt(id=c("weeks","rep")) %>%
  acast(variable~rep~weeks) -> datarray

statearray <- datarray
rownames(statearray) <- c("L","P","A")

cls_params <- c(b=10.45, mu_L=0.2000, mu_A=0.007629, cel=0.01731, cea=0.1310, cpa=0.004619,
                sigma_1=1.621, sigma_2=0.7375, sigma_3=0.01212)

model <- nlar.model(data = subset(dat, rep == 1), params = cls_params)


paramarray <- as.matrix(read.csv('../data/params.csv'))
row.names(paramarray) <- c("b", "cea", "cel", "cpa", "mu_A", "mu_L", "sigma_1", "sigma_2", "sigma_3")
colnames(paramarray) <- 1:24

lik <- function(par) {
  p <- paramarray
  p[c('b', 'cea','cel','mu_L','sigma_1','sigma_2','sigma_3'),] <-
    c(par['b'],
      par['cea'],
      par['cel'],
      par['mu_L'],
      par['sigma_1'],
      par['sigma_2'],
      par['sigma_3'])
  p['mu_A',c(4, 11, 24)] <- par['mu_A']
  p['cpa',c(4, 11, 24)] <- par['cpa']
  df <- dprocess(model,x=statearray,params=p,times=time(model),log=TRUE)
  sum(df)
}

lik(cls_params)

s <- 0

fit <- optim(cls_params, lik, control=c(fnscale=-1))
