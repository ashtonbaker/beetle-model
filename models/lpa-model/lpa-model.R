require(pomp)

lpa.model <- function(data, params, statenames, paramnames, skeleton,
                      initializer, rprocess, rmeasure, dmeasure,
                      times = 'weeks',
                      t0 = -1,
                      delta.t = 2) {

  if (missing(paramnames)) {
    paramnames <- c('b', 'cea', 'cel', 'cpa', 'mu_A', 'mu_L')
  }

  if (missing(statenames)) {
    statenames <- c('L', 'P', 'A')
  }

  if (missing(initializer)) {
    initializer <- Csnippet(readChar('./models/lpa-model/initializer.c', nchar=1e6))
  }

  if (missing(rprocess)) {
    rprocess <- discrete.time.sim(
      step.fun = Csnippet(readChar('./models/lpa-model/rprocess.c', nchar=1e6)),
      delta.t = 2
      )
  }
  
  if (missing(dmeasure)) {
    dmeasure <- Csnippet(readChar('./models/lpa-model/dmeasure.c', nchar=1e6))
  }

  if (missing(rmeasure)) {
    rmeasure <- Csnippet(readChar('./models/lpa-model/rmeasure.c', nchar=1e6))
  }

  pomp(
    data  = data,
    times = times,
    t0 = t0,
    statenames = statenames,
    paramnames = paramnames,
    #globals = globals,
    initializer = initializer,
    #skeleton = skeleton,
    rprocess = rprocess,
    dmeasure = dmeasure,
    #dprocess = dprocess,
    #dmeasure = dmeasure,
    rmeasure = rmeasure,
    params = params
    )
}
