library(panelPomp)

#opt.njobs <- 1000
opt.ncore <- 100
#opt.chunk <- 1

opt.stages.E <- 7
opt.stages.L <- 7
opt.stages.P <- 7
opt.stages.A <- 1

opt.initial.pfilter.np <- 100
opt.initial.pfilter.njobs <- 100

opt.local.box.search.np <- 1000
opt.local.box.search.nmif <- 30
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

opt.lik.local.nrep <- 100
opt.lik.local.np <- 1000

opt.global.search.nguesses <- 100
opt.global.search.nmif <- 30
opt.global.search.nrep <- 1
opt.global.search.np <- 1000
