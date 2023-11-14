% Younes Slaoui DHS
% Finds highest correlated crimes using the spatiotemporal data, stores 
% errors as averages from 50 errors (change avgLoop value). Lowest errors
% represent highest correlations

clear all

load('allStackedCrimes.mat');

avgLoop = 50;

%drive is the row and target is the col
trainingErrorMatrix = zeros(25,25);
testingErrorMatrix = zeros(25,25);

for driveInd = 1:25

    for targetInd = 1:25
        
        if driveInd==targetInd
            continue
        end

        avgTraining10 = [];
        avgTesting10 = [];

        for i = 1:avgLoop

            c = 399;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
            Q = 25;
            M = c;% num drive crimes x c
            L = 22;
            ts = 0.25;
            
            %full_span = size(narcotics, 2);
            train_span = 265;
            test_span = 100;
            
            tmax = test_span + train_span;
            ModelParams.tau = ts; % time step
            ModelParams.nstep = tmax; % number of time steps to generate
            ModelParams.N = Q;  % number of spatial grid points 
            ModelParams.d = L;  % periodicity length 
            ModelParams.dT = 1;
            
            kgain = 0.2;
            
            n = 400;
            p = 0.1;
            rho = 1;
            A = ER(n,p);
            E = eigs(A,1,'largestreal');
            A = A*rho/E;
            A = sparse(A);
            alpha = 0.1;
            beta = 1e-4;
            win = generate_win(n,M);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
          
            
            drive_sig = allStackedCrimes{1,driveInd};      
    
    
            % Train
            target_sig = allStackedCrimes{1,targetInd};
            train_sig = target_sig(1:train_span, :);
    
            IC_RC = zeros(length(A),1);
            RC_mat = RC(alpha, A, win, drive_sig, IC_RC);
            
            Omega_tr = RC_mat(1:train_span,:);
            Omega_tr_inv = RR(Omega_tr,1e-8);
            
            K = Omega_tr_inv*train_sig;
            
            fit_tr = Omega_tr*K;
            
            
            %%Test
            
            test_sig = target_sig(train_span+1:end, :);
    
            %Omega_tr(:,end+1) = 1;
            
            Omega_te = RC_mat(train_span+1:end,:);
            
            fit_te = Omega_te*K;
            
            
            %%Errors
            trainingError = sqrt(sum(sum((train_sig - fit_tr).^2))/sum(sum(train_sig.^2))) %training error
            testingError = sqrt(sum(sum((test_sig - fit_te).^2))/sum(sum(test_sig.^2))) %testingg error
            
            avgTraining10 = [avgTraining10, trainingError];
            avgTesting10 = [avgTesting10, testingError];

        end

        trainingError = mean(avgTraining10);
        testingError = mean(avgTesting10);

        trainingErrorMatrix(driveInd, targetInd) = trainingError;
        testingErrorMatrix(driveInd, targetInd) = testingError;
    end

end
save('trainingErrorMatrix');
save('testingErrorMatrix');

