double *E = &E1;
double *L = &L1;
double *P = &P1;

int time = round(t * 7);

int k;
double L_tot = 0;
for (k = 0; k < LSTAGES; k++) L_tot += L[k];

double gamma_E = (ESTAGES / tau_E) *
                 exp((-cel * L_tot - cea * A) / ESTAGES);
double gamma_L = (LSTAGES / tau_L) * (1 - mu_L);
double gamma_P = (PSTAGES / tau_P) * exp((-cpa * A) / PSTAGES);

double mu_e = (ESTAGES / tau_E) - gamma_E;
double mu_l = (LSTAGES / tau_L) - gamma_L;
double mu_p = (PSTAGES / tau_P) - gamma_P;

double etrans[2*ESTAGES], ltrans[2*LSTAGES], ptrans[2*PSTAGES], adeath;

// Calculate who goes where
for (k = 0; k < ESTAGES; k++) {
  // Eggs growing to next stage
  etrans[2*k]   = rbinom(E[k], gamma_E);

  // Eggs dying
  etrans[2*k+1] = rbinom(E[k]-etrans[2*k], mu_e/(1 - gamma_E) );
}

for (k = 0; k < LSTAGES; k++) {
  // Larvae growing to next stage
  ltrans[2*k]   = rbinom(L[k], gamma_L);

  // Larvae dying
  ltrans[2*k+1] = rbinom(L[k]-ltrans[2*k], mu_l/(1 - gamma_L));
}

for (k = 0; k < PSTAGES; k++) {
  // Pupae growing to next stage
  ptrans[2*k]   = rbinom(P[k], gamma_P);

  // Pupae dying
  ptrans[2*k+1] = rbinom(P[k]-ptrans[2*k], mu_p/(1 - gamma_P) );
}

adeath = rbinom(A, mu_A);

// Bookkeeping
E[0] += rpois(b*A); // oviposition

for (k = 0; k < ESTAGES; k++) {
  // Subtract eggs that die or progress
  E[k] -= (etrans[2*k]+etrans[2*k+1]);

  // Add eggs that arrive from previous E stage.
  E[k+1] += etrans[2*k]; // E[ESTAGES] == L[0]!!
}

for (k = 0; k < LSTAGES; k++) {
  // Subtract larvae that die or progress
  L[k] -= (ltrans[2*k]+ltrans[2*k+1]);

  // Add larvae that arrive from previous E stage.
  L[k+1] += ltrans[2*k]; // L[LSTAGES] == P[0]!!
}

for (k = 0; k < PSTAGES; k++) {
  // Subtract pupae that die or progress
  P[k] -= (ptrans[2*k]+ptrans[2*k+1]);

  // Add pupae that arrive from previous E stage.
  P[k+1] += ptrans[2*k]; // P[PSTAGES] == A[0]!!
}

A -= adeath;

if ((time % 14 == 0) && (time != 0) && (mu_A_force > 0.00001)) {
  double P_tot = 0;

  for (k = 0; k < PSTAGES; k++) P_tot += P[k];

  double A_pred = round((1 - mu_A_force) * A_prev) +
                  round(P_prev * exp(-cpa_force * A));

  if (A_pred < A) {
    double A_sub = fmin(A - A_pred, A_prev);
    A = fmax(A - A_sub, 0);
  }

  P_prev = P_tot;
  A_prev = A;
}
