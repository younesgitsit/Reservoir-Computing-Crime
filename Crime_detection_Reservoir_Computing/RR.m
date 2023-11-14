% Younes Slaoui DHS
% Regularized Matrix Inversion using Cholesky Decomposition

% Reference: Nathe, C., Pappu, C., Mecholsky, N. A., Hart, J., Carroll, 
% T., & Sorrentino, F. (2023).Reservoir computing with noise. Chaos: An 
% Interdisciplinary Journal of Nonlinear Science,33 (4).
% https://doi.org/10.1063/5.0130278

function Ominv = RR(Om,beta)

[~,n]  = size(Om);
M = Om'*Om+beta*eye(n);
L = chol(M,'lower');
U = L\eye(n);
Minv = L'\U;
Ominv = Minv*Om';

end