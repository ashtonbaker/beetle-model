requires(pomp)

nlar_model <- function(){
  nlar.init <- Csnippet(readChar('./initializer.c', nchar=1e6))
  nlar.rprocess <- discrete.time.sim(
    step.fun = Csnippet(readChar('./rprocess.c', nchar=1e6)),
    delta.t = 2
    )
  nlar.skeleton <- map(
    Csnippet(),
    delta.t = 2)
  nlar.dmeasure <- Csnippet(readChar('./dmeasure.c', nchar=1e6))
}
