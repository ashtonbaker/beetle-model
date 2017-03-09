const double *L = &L1;
const double *P = &P1;
double fudge = 1e-9;

int k;
double L_tot = 0;
double P_tot = 0;
for (k = 0; k < LSTAGES; k++) L_tot += L[k];
for (k = 0; k < PSTAGES; k++) P_tot += P[k];

L_obs = rnbinom_mu(1/od, L_tot + fudge);
P_obs = rnbinom_mu(1/od, P_tot + fudge);
A_obs = rnbinom_mu(1/od, A + fudge);
