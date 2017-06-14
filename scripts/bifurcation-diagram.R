library(pomp)
library(magrittr)
library(ggplot2)
library(reshape2)
source('./models/step-model/step-model.R')

read.csv(file="./results_global.csv") %>%
  subset((loglik < 0) & (loglik > -7500) & (loglik.se < 1)) -> results

results[which.max(results$loglik),] %>% unlist() %>% c() -> p

aggregate <- function(df) {
  output = data.frame(t = df[,'time'], A_tot=df[,'A'])
  output[,'E_tot'] <- rowSums(df[,sprintf('E%d', 1:7)])
  output[,'L_tot'] <- rowSums(df[,sprintf('L%d', 1:7)])
  output[,'P_tot'] <- rowSums(df[,sprintf('P%d', 1:7)])
  
  output
}

read.csv("./data/data.csv") %>%
  subset(weeks <= 40, select=c(weeks,rep,L_obs,P_obs,A_obs)) -> dat


p["mu_A_force"] <- 0.96
p["cpa_force"] <- 0.00
model <- step.model(data = subset(dat, rep==1, select=-rep), params = p)


#cpa_list = c(0.00, 0.05, 0.10, 0.25, 0.35, 0.50, 1.00)

cpa_list = seq(0.1, 0.2, by=0.01)
points = data.frame(cpa=double(), A=double())

for (cpa in cpa_list) {
  
  p["cpa_force"] <- cpa
  model <- pomp(model, params = p)
  
  for (i in 1:10){
    n = nrow(points)
    model %>% simulate(times = seq(from=0,to=100000, by=2)) %>%
      as.data.frame() %>% aggregate() %>% tail(1000) %>% colMeans() -> results
    points[n+1,c('cpa', 'A')] <- c(cpa, results['A_tot'])
  }
}

ggplot(points, aes(x=cpa, y=A)) + geom_point()


p["cpa_force"] <- 0.20
model <- model <- pomp(model, params = p)
model %>% trajectory(times = seq(from=0,to=20, by=1), as.data.frame = TRUE) %>% aggregate() %>%
  melt(id='t') %>% ggplot(aes(x=t, y=value, colour=variable)) + geom_point() + facet_grid(variable~., scales="free")

