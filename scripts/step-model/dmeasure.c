const double *L = &L1;
const double *P = &P1;
double fudge = 1e-9;

int k;
double L_tot = 0;
double P_tot = 0;
for (k = 0; k < LSTAGES; k++) L_tot += L[k];
for (k = 0; k < PSTAGES; k++) P_tot += P[k];

lik = dnbinom_mu(L_obs, 1/od, L_tot + fudge, 1) +
      dnbinom_mu(P_obs, 1/od, P_tot + fudge, 1) +
      dnbinom_mu(A_obs, 1/od, A + fudge,     1);

if(!R_FINITE(lik)){
  Rprintf("\n\nweeks %f", t);
  Rprintf("\nL_tot %f", L_tot);
  Rprintf("\nP_tot %f", P_tot);
  Rprintf("\nA_tot %f", A);
  Rprintf("\nL_obs %f", L_obs);
  Rprintf("\nP_obs %f", P_obs);
  Rprintf("\nA_obs %f", A_obs);
  Rprintf("\nloglik %f",lik);
}

lik = (give_log) ? lik : exp(lik);
