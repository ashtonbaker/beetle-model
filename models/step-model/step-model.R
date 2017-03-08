require(pomp)

step.model <- function(data, params, nstages, ...) {
  if (missing(nstages)) {
    stages.E = 7
    stages.L = 7
    stages.P = 7
  } else {
    stages.E = nstages$E
    stages.L = nstages$L
    stages.P = nstages$P
  }

  if (missing(times)) {
    times <- 'weeks'
  }

  if (missing(t0)) {
    t0 <- 0
  }

  if (missing(delta.t)) {
    delta.t <- 1/7
  }

  if (missing(statenames)) {
    statenames <- c(
      sprintf('E%d', 1:stages.E),
      sprintf('L%d', 1:stages.L),
      sprintf('P%d', 1:stages.P),
      'A', 'A_prev', 'P_prev'
      )
  }

  if (missing(paramnames)) {
    paramnames <- c(
      'b', 'cea', 'cel', 'cpa', 'cpa_force',
      'mu_A', 'mu_L', 'mu_A_force',
      'tau_E', 'tau_L', 'tau_P',
      'od',
      'is_control'
      )
  }

  if (missing(globals)) {
    globals <- Csnippet(
      sprintf(readChar('./globals.c', nchars=1e6), stages.E, stages.L, stages.P)
      )
  }

  if (missing(initializer)) {
    initializer <- Csnippet(
      sprintf(readChar('./initializer.c', nchars=1e6))
      )
  }

  if (missing(rprocess)) {
    rprocess <- Csnippet(
      readChar('./rprocess.c', nchars=1e6)
      )
  }

  if (missing(dmeasure)) {
    dmeasure <- Csnippet(
      readChar('./dmeasure.c', nchars=1e6)
      )
  }

  if (missing(rmeasure)) {
    rmeasure <- discrete.time.sim(
      step.fun = Csnippet(readChar('./rmeasure.c', nchars=1e6)),
      delta.t = delta.t
      )
  }

  if (missing(fromEstimationScale)) {
    fromEstimationScale <- Csnippet(
      readChar('./fromEstimationScale.c', nchars=1e6)
      )
  }

  if (missing(toEstimationScale)) {
    toEstimationScale <- Csnippet(
      readChar('./toEstimationScale.c', nchars=1e6)
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
