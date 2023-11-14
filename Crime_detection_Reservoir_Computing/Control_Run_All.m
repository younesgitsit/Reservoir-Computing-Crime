clear all


Q = 64;
M = 16;
L = 22;
ts = 0.25;
transient_span = 1000;
train_span = 100000;
%control_span = 10000;
tmax = transient_span + train_span;
ModelParams.tau = ts; % time step
ModelParams.nstep = tmax; % number of time steps to generate
ModelParams.N = Q;  % number of spatial grid points 
ModelParams.d = L;  % periodicity length 
ModelParams.dT = 1;

kgain = 0.2;

n = 100;
p = 0.1;
rho = 1;
A = ER(n,p);
E = eigs(A,1,'largestreal');
A = A*rho/E;
A = sparse(A);
alpha = 0.7;
beta = 1e-4;
win = generate_win(n,M);

rng('shuffle')
init_cond = 0.6*(-1 + 2*rand(1,ModelParams.N)); %random initial condition

data = kursiv_solve(init_cond,ModelParams); 

save('data_file.mat', 'data');


drive_idx = round(linspace(1,Q,M)); %Accessible points indices
train_idx = find(~ismember(1:Q,drive_idx)); %Unacceddible points indices

drive_sig = data(:,drive_idx);
train_sig = data(transient_span+1:end,train_idx);

IC_RC = zeros(length(A),1);
RC_mat = RC(alpha, A, win, drive_sig, IC_RC);

Omega_tr = RC_mat(transient_span+1:end,:);
Omega_tr(:,end+1) = 1;
Omega_tr_inv = RR(Omega_tr,1e-8);
K = Omega_tr_inv*train_sig;
fit_tr = Omega_tr*K;

RMSE_tr = sqrt(sum(sum((train_sig - fit_tr).^2))/sum(sum(train_sig.^2))) %training error

ic_rc = RC_mat(end,:);

%ModelParams.nstep = control_span;

%[data_control_RC,SS,feedrc] = kursiv_control_RC(data(end,:), ModelParams, K, kgain, drive_idx, train_idx, A, win, alpha, ic_rc, beta);
%[data_control_sp,feedsp] = kursiv_control_sp(data(end,:), ModelParams, kgain, drive_idx, train_idx);
%data_control_actual = kursiv_control_actual(data(end,:), ModelParams, kgain);

%idx = round(length(data_control_actual(:,1))*0.9);

%control_err_RC = norm(mean(data_control_RC(idx:end,:)))/sqrt(Q);
%control_err_sp = norm(mean(data_control_sp(idx:end,:)))/sqrt(Q);
