require(pomp)

nlar.model <- function(data, params, statenames, paramnames, skeleton,
                       initializer, rprocess, dmeasure, dprocess, rmeasure,
                       times = 'weeks',
                       t0 = 0,
                       delta.t = 2) {

  if (missing(paramnames)) {
    paramnames <- c('b', 'cea', 'cel', 'cpa', 'mu_A', 'mu_L',
                    'sigma_1', 'sigma_2', 'sigma_3')
  }

  if (missing(statenames)) {
    statenames <- c('L', 'P', 'A')
  }

  if (missing(initializer)) {
    initializer <- Csnippet(readChar('./models/nlar-model/initializer.c', nchar=1e6))
  }

  if (missing(rprocess)) {
    rprocess <- discrete.time.sim(
      step.fun = Csnippet(readChar('./models/nlar-model/rprocess.c', nchar=1e6)),
      delta.t = 2
      )
  }

  #if (missing(skeleton)) {
  #  skeleton <- map(
  #    Csnippet(readChar('./models/nlar-model/rprocess.c', nchar=1e6)),
  #    delta.t = 2)
  #}

  if (missing(dprocess)) {
    dprocess = onestep.dens(dens.fun=function(x1,x2,t1,t2,params,...){
      stopifnot(t2==t1+2L)
      with(as.list(params),{
        mu_l <- sqrt(b * x1["A"] * exp(-cel*x1["L"] - cea*x1["A"]))
        mu_p <- sqrt(x1["L"] * (1 - mu_L))
        mu_a <- sqrt(x1["P"] * exp(-cpa * x1["A"]) + x1["A"] * (1 - mu_A))

        likl <- dnorm(sqrt(x2["L"]), mean = mu_l, sd = sigma_1,log=TRUE)
        likp <- dnorm(sqrt(x2["P"]), mean = mu_p, sd = sigma_2,log=TRUE)
        lika <- dnorm(sqrt(x2["A"]), mean = mu_a, sd = sigma_3,log=TRUE)
        if(mu_A < 0){lika = -Inf}
        likl + likp + lika
      })
      })
  }

  if (missing(dmeasure)) {
    dmeasure <- Csnippet(readChar('./models/nlar-model/dmeasure.c', nchar=1e6))
  }

  pomp(
    data  = data,
    times = times,
    t0 = t0,
    statenames = statenames,
    paramnames = paramnames,
    #globals = globals,
    initializer = initializer,
    skeleton = skeleton,
    rprocess = rprocess,
    dprocess = dprocess,
    dmeasure = dmeasure,
    rmeasure = rmeasure,
    params = params
    )
}
