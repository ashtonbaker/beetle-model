library(panelPomp)

opt.ncore <- 200

opt.stages.E <- 7
opt.stages.L <- 7
opt.stages.P <- 7
opt.stages.A <- 1

opt.initial.pfilter.np <- 100
opt.initial.pfilter.njobs <- 95

opt.local.box.search.np <- 1000
opt.local.box.search.nmif <- 30
opt.local.box.search.njobs <- 95
opt.local.box.search.rw.sd <- rw.sd(
  b=0,
  cea=0.01,
  cel=0.01,
  cpa=0.01,
  mu_A=0.01,
  mu_L=0.01,
  od=0.01,
  tau_E=0.01,
  tau_L=0.01,
  tau_P=0.01)

<<<<<<< HEAD
opt.lik.local.nrep <- 100
opt.lik.local.np <- 1000

opt.global.search.nguesses <- 250
opt.global.search.nmif <- 300
=======
opt.lik.local.nrep <- 195
opt.lik.local.np <- 1000

opt.global.search.nguesses <- 195
opt.global.search.nmif <- 600
>>>>>>> 880c595d607ba0e2c5f9a5bdb7a1961795b0dee4
opt.global.search.nrep <- 10
opt.global.search.np <- 1000
