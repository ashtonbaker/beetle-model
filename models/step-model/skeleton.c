const double *E = &E1;
const double *L = &L1;
const double *P = &P1;
double *DE = &DE1;
double *DL = &DL1;
double *DP = &DP1;

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
  etrans[2*k]   = E[k]*gamma_E;

  // Eggs dying
  etrans[2*k+1] = (E[k]-etrans[2*k])*( mu_e/(1 - gamma_E) );
}

for (k = 0; k < LSTAGES; k++) {
  // Larvae growing to next stage
  ltrans[2*k]   = L[k]*gamma_L;

  // Larvae dying
  ltrans[2*k+1] = (L[k]-ltrans[2*k])*(mu_l/(1 - gamma_L));
}

for (k = 0; k < PSTAGES; k++) {
  // Pupae growing to next stage
  ptrans[2*k]   = (P[k]*gamma_P);

  // Pupae dying
  ptrans[2*k+1] = (P[k]-ptrans[2*k])*(mu_p/(1 - gamma_P) );
}

adeath = (A*mu_A);

// Bookkeeping


for (k = 0; k < ESTAGES; k++) {
  // Subtract eggs that die or progress
  DE[k] = E[k] - (etrans[2*k]+etrans[2*k+1]);

  // Add eggs that arrive from previous E stage.
  DE[k+1] = E[k+1] + etrans[2*k]; // E[ESTAGES] == L[0]!!
}

DE[0] = DE[0] + b*A; // oviposition

for (k = 0; k < LSTAGES; k++) {
  // Subtract larvae that die or progress
  DL[k] = L[k] - (ltrans[2*k]+ltrans[2*k+1]);

  // Add larvae that arrive from previous E stage.
  DL[k+1] = L[k+1] + ltrans[2*k]; // L[LSTAGES] == P[0]!!
}

for (k = 0; k < PSTAGES; k++) {
  // Subtract pupae that die or progress
  DP[k] = P[k] - (ptrans[2*k]+ptrans[2*k+1]);

  // Add pupae that arrive from previous E stage.
  DP[k+1] = P[k+1] + ptrans[2*k]; // P[PSTAGES] == A[0]!!
}

DA = A - adeath;

if ((time % 14 == 0) && (time != 0) && (mu_A_force > 0.00001)) {
  double P_tot = 0;

  for (k = 0; k < PSTAGES; k++) P_tot += P[k];

  double A_pred = round((1 - mu_A_force) * A_prev) +
    round(P_prev * exp(-cpa_force * A));

  if (A_pred < A) {
    double A_sub = fmin(A - A_pred, A_prev);
    DA = fmax(A - A_sub, 0);
  }

  DP_prev = P_tot;
  DA_prev = DA;
}
