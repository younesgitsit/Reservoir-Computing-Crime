% Younes Slaoui DHS
% Temporal data only: Every 1 to 1 drive signal target signal combination 
% of temporal observation for all 25 crimes. Errors are storeed in 25 x 25
% matrix.

clear all

load('data.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rows are drive crime number and cols are the target crime number
errorMatrixTraining = zeros(25, 25);
errorMatrixTesting = zeros(25, 25);

for driveInd = 1:25

    for targetInd = 1:25


        %if driveInd == targetInd
    
           % errorMatrixTraining(driveInd, targetInd) = 999;
           % errorMatrixTesting(driveInd, targetInd) = 999;
          %  continue;

       % end

        Q = 25;
        M = 1;
        L = 22;
        ts = 0.25;
        
        train_span = 300;
        test_span = 65;
        
        tmax = test_span + train_span;
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        drive_sig = data(:,driveInd);

        % Train
        train_sig = data(1:train_span,targetInd);
        
        IC_RC = zeros(length(A),1);
        RC_mat = RC(alpha, A, win, drive_sig, IC_RC);
        
        Omega_tr = RC_mat(1:train_span,:);
        Omega_tr_inv = RR(Omega_tr,1e-8);
        
        K = Omega_tr_inv*train_sig;
        
        fit_tr = Omega_tr*K;
        
        
        %%Test
        
        test_sig = data(train_span+1:end,targetInd);
        
        %Omega_tr(:,end+1) = 1;
        
        Omega_te = RC_mat(train_span+1:end,:);
        
        fit_te = Omega_te*K;
        
        
        %%Errors
        trainingError = sqrt(sum(sum((train_sig - fit_tr).^2))/sum(sum(train_sig.^2))) %training error
        testingError = sqrt(sum(sum((test_sig - fit_te).^2))/sum(sum(test_sig.^2))) %testingg error

        
        errorMatrixTraining(driveInd, targetInd) = trainingError;
        errorMatrixTesting(driveInd, targetInd) = testingError;

    end

end
save('errorMatrixTraining.mat')
save('errorMatrixTesting.mat')
