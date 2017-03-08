double *E = &E1;
double *L = &L1;
double *P = &P1;

double gamma_L = (LSTAGES / tau_L) * (1 - mu_L);
double gamma_P = (PSTAGES / tau_P) * exp((-cpa * A_0) / ESTAGES);

double mu_l = (LSTAGES / tau_L) * mu_L;
double mu_p = (PSTAGES / tau_P) * (1 - exp((-cpa * A_0) / ESTAGES));

double L_rate[LSTAGES] = {0};
double P_rate[PSTAGES] = {0};

int k;
double sum;
for (k = 0, sum = 0; k < LSTAGES; k++){
   L_rate[k] = pow(gamma_L/(gamma_L + mu_l), k);
   sum += L_rate[k];
}
for (k = 0; k < LSTAGES; k++) L_rate[k] /= sum;
for (k = LSTAGES - 1, sum = 0; k >=0; k--){
  sum += L_rate[k];
  L_rate[k] /= sum;
}

for (k = 0, sum = 0; k < PSTAGES; k++){
  P_rate[k] = pow(gamma_P/(gamma_P + mu_p), k);
  sum += P_rate[k];
}

for (k = 0; k < PSTAGES; k++) P_rate[k] /= sum;
for (k = PSTAGES - 1, sum = 0; k >=0; k--){
  sum += P_rate[k];
  P_rate[k] /= sum;
}


for (k = 0; k < ESTAGES; k++) E[k] = 0;

int L_count = L_0;
for (k = 0; k < LSTAGES - 1; k++){
  L[k] = rbinom(L_count, L_rate[k]);
  L_count -= L[k];
}
L[LSTAGES - 1] = L_count;

int P_count = P_0;
for (k = 0; k < PSTAGES - 1; k++){
  P[k] = rbinom(P_count, P_rate[k]);
  P_count -= P[k];
}

P[PSTAGES - 1] = P_count;

A = 100;
