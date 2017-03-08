require(pomp)

step.model <- function(data, params, stages.E, stages.L, stages.P) {
  times <- 'weeks'

  t0 <- 0

  statenames <- c(
    sprintf('E%d', 1:stages.E),
    sprintf('L%d', 1:stages.L),
    sprintf('P%d', 1:stages.P),
    'A', 'A_prev', 'P_prev'
    )

  paramnames <- c(
    'b', 'cea', 'cel', 'cpa', 'mu_A', 'mu_L', 'tau_E', 'tau_L', 'tau_P', 'od'
    )

  globals <- Csnippet(
    sprintf(readChar('./globals.c', nchars=1e6), stages.E, stages.L, stages.P)
    )

  initializer <- Csnippet(
    sprintf(readChar('./initializer.c', nchars=1e6))
    )

  rprocess <- Csnippet(
    sprintf(readChar('./rprocess.c', nchars=1e6, ###### TODO ME))
    )

  dmeasure <- Csnippet(
    readChar('./dmeasure.c', nchars=1e6)
    )

  rmeasure <- discrete.time.sim(
    step.fun = Csnippet(readChar('./rmeasure.c', nchars=1e6)),
    delta.t = 1/7
    )

  fromEstimationScale <- Csnippet(
    readChar('./fromEstimationScale.c', nchars=1e6)
    )

  toEstimationScale <- Csnippet(
    readChar('./toEstimationScale.c', nchars=1e6)
    )

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
