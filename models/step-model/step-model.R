require(pomp)

step.model <- function(data, params, statenames, paramnames, globals,
                       initializer, rprocess, dmeasure, rmeasure,
                       fromEstimationScale, toEstimationScale,
                       times = 'weeks',
                       t0 = 0,
                       delta.t = 1/7,
                       nstages = c(E=7, L=7, P=7)) {

  if (missing(statenames)) {
    statenames <- c(
      sprintf('E%d', 1:nstages['E']),
      sprintf('L%d', 1:nstages['L']),
      sprintf('P%d', 1:nstages['P']),
      'A', 'A_prev', 'P_prev'
      )
  }

  if (missing(paramnames)) {
    paramnames <- c(
      'b', 'cea', 'cel', 'cpa', 'cpa_force',
      'mu_A', 'mu_L', 'mu_A_force',
      'tau_E', 'tau_L', 'tau_P',
      'od'
      )
  }

  if (missing(globals)) {
    globals <- Csnippet(
      sprintf(readChar('./models/step-model/globals.c', nchars=1e6),
              nstages['E'], nstages['L'], nstages['P'])
      )
  }

  if (missing(initializer)) {
    initializer <- Csnippet(
      sprintf(readChar('./models/step-model/initializer.c', nchars=1e6))
      )
  }

  if (missing(rprocess)) {
    rprocess <- discrete.time.sim(
      step.fun = Csnippet(
        readChar('./models/step-model/rprocess.c', nchars=1e7)),
      delta.t = delta.t
      )
  }

  if (missing(dmeasure)) {
    dmeasure <- Csnippet(
      readChar('./models/step-model/dmeasure.c', nchars=1e6)
      )
  }

  if (missing(rmeasure)) {
    rmeasure <- Csnippet(
        readChar('./models/step-model/rmeasure.c', nchars=1e6)
      )
  }

  if (missing(fromEstimationScale)) {
    fromEstimationScale <- Csnippet(
      readChar('./models/step-model/fromEstimationScale.c', nchars=1e6)
      )
  }

  if (missing(toEstimationScale)) {
    toEstimationScale <- Csnippet(
      readChar('./models/step-model/toEstimationScale.c', nchars=1e6)
      )
  }

  pomp(
    data  = data,
    times = times,
    t0 = t0,
    statenames = statenames,
    paramnames = paramnames,
    globals = globals,
    initializer = initializer,
    rprocess = rprocess,
    dmeasure = dmeasure,
    rmeasure = rmeasure,
    toEstimationScale   = toEstimationScale,
    fromEstimationScale = fromEstimationScale,
    params = params
    )
}
