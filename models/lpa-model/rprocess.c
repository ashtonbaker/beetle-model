double L_prev = L;
double P_prev = P;
double A_prev = A;

L = rpois(b*A_prev*exp(-(cel * L_prev - cea * A_prev)));
P = rbinom(L_prev, 1 - mu_L);
double R = rbinom(P_prev, exp(-cpa * A_prev));
double S = rbinom(A_prev, 1 - mu_A);
A = R + S;
