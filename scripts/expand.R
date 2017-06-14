read.csv("./results_global.csv") -> data
paramnames = c("b", "cea", "cel", "cpa", "mu_A", "mu_L",
               "tau_E", "tau_L", "tau_P","od")

params_box <- rbind(
  b = range(data$b),
  cea = range(data$cea),
  cel = range(data$cel),
  cpa = range(data$cpa),
  mu_A = range(data$mu_A),
  mu_L = range(data$mu_L),
  tau_E = range(c(8, 10)),
  tau_L = range(c(8, 10)),
  tau_P = range(c(8, 10)),
  od = range(data$od)
)


new.guesses <- data.frame(b = seq(80.01, 140, by=0.01))
new.guesses$loglik <- 0
new.guesses$loglik.se <- 0
new.guesses$delta.loglik <- 1000
new.guesses[,paramnames] <-
  as.data.frame(
    apply(
      params_box,
      1,
      function(x)runif(nrow(new.guesses),x[1],x[2])))
new.guesses$b <- seq(80.01, 140, by=0.01)


output.data <- rbind(data, new.guesses)

write.csv(output.data, './results_global.csv', row.names = FALSE)
