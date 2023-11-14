% Younes Slaoui DHS
% Creates and updates the dynamic states of the Reservoir Computer
% Reference: Nathe, C., Pappu, C., Mecholsky, N. A., Hart, J., Carroll, T., 
% & Sorrentino, F. (2023).Reservoir computing with noise. Chaos: An 
% Interdisciplinary Journal of Nonlinear Science,33 (4).
% https://doi.org/10.1063/5.0130278

function [RCmat] = RC(Alpha, Amat, Wmat, signalIn, IC)

Npt = length(signalIn(:,1));

[~, n_node] = size(Amat);

RCmat = zeros(Npt,n_node);
r_in = IC;

for i = 1:Npt
 r_out = (1-Alpha)*r_in + Alpha*tanh(Amat*r_in + Wmat*signalIn(i,:)');
    %   r_out = Amat*r_in + Wmat*signalIn(i,:)';
    RCmat(i,1:n_node) = r_out;
    r_in = r_out;
end

end