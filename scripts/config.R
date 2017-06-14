#library(panelPomp)

opt.ncore <- 100

opt.stages.E <- 7
opt.stages.L <- 7
opt.stages.P <- 7
opt.stages.A <- 1

opt.initial.pfilter.np <- 100
opt.initial.pfilter.njobs <- 95

opt.local.box.search.np <- 10
opt.local.box.search.nmif <- 5
opt.local.box.search.njobs <- 100
opt.local.box.search.rw.sd <- rw.sd(
  b=0,
  cea=0.001,
  cel=0.001,
  cpa=0.001,
  mu_A=0.001,
  mu_L=0.001,
  od=0.001,
  tau_E=0.001,
  tau_L=0.001,
  tau_P=0.001)

opt.lik.local.nrep <- 1
opt.lik.local.np <- 100

opt.global.search.nguesses <- 250
opt.global.search.nmif <- 300
opt.global.search.nrep <- 10
opt.global.search.np <- 100
