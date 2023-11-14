% Younes Slaoui DHS
% Generates ER graph (random graph)
% Reference: Nathe, C., Pappu, C., Mecholsky, N. A., Hart, J., Carroll, T., 
% & Sorrentino, F. (2023).Reservoir computing with noise. Chaos: An 
% Interdisciplinary Journal of Nonlinear Science,33 (4).
% https://doi.org/10.1063/5.0130278

function A = ER(n,p)


% Undirected Erdos Renyi
R = rand(n);
R = triu(R);
A = double(R < p);
A = triu(A) + triu(A)';
A = A - diag(diag(A));


%% Directed Erdos Renyi
% R = rand(n);
% A = double(R < p);
% A = A - diag(diag(A));
% A = A.*(randi([0 1],n,n)*2 - 1);

% A = sprand(n,n,p);
% A = A - diag(diag(A));

end