double e1 = rnorm(0, sigma_1);
double e2 = rnorm(0, sigma_2);
double e3 = rnorm(0, sigma_3);

double L_prev = L;
double P_prev = P;
double A_prev = A;

L = (sqrt(b * A_prev * exp(-cel * L_prev - cea * A_prev)) + e1) *
    (sqrt(b * A_prev * exp(-cel * L_prev - cea * A_prev)) + e1);

P = (sqrt(L_prev * (1 - mu_L)) + e2) * (sqrt(L_prev * (1 - mu_L)) + e2);

A = (sqrt(P_prev * exp(-cpa * A_prev) + A_prev * (1 - mu_A)) + e3) *
    (sqrt(P_prev * exp(-cpa * A_prev) + A_prev * (1 - mu_A)) + e3);
