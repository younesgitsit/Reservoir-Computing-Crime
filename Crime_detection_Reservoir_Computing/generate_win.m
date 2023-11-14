% Younes Slaoui DHS
% Generates Input Weights

% Reference: Nathe, C., Pappu, C., Mecholsky, N. A., Hart, J., Carroll, T., 
% & Sorrentino, F. (2023).Reservoir computing with noise. Chaos: An 
% Interdisciplinary Journal of Nonlinear Science,33 (4).
% https://doi.org/10.1063/5.0130278
function win = generate_win(n,M)

% win = zeros(n,M);
% q = round(n/M);
% 
% for i=1:M
% rng(i)
% ip = 0.5*(-1 + 2*rand(q,1));
% win((i-1)*q+1:i*q,i) = ip;
% end
% 


P = zeros(n,M);
for i = 1:n
a = mod(i,M);
if a == 0
a = M;
end
P(i,a) = 1;
end

R = rand(n,M) - 0.5;

win = P.*R;


end