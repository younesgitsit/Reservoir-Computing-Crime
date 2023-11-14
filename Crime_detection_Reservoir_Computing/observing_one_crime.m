% Younes Slaoui
% Performs observation on one crime (one crime is the target signal)

clear all

load('data.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
driveInd = 1;
targetInd = 25;

        Q = 25;
        M = 1;% num drives
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
        
        n = 50;
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

        train_sig = data(1:train_span, targetInd);

        IC_RC = zeros(length(A),1);
        RC_mat = RC(alpha, A, win, drive_sig, IC_RC);
        
        Omega_tr = RC_mat(1:train_span,:);
        Omega_tr_inv = RR(Omega_tr,1e-8);
        
        K = Omega_tr_inv*train_sig;
        
        fit_tr = Omega_tr*K;
        
        
        %%Test
        
        test_sig = data(train_span+1:end, targetInd);

        %Omega_tr(:,end+1) = 1;
        
        Omega_te = RC_mat(train_span+1:end,:);
        
        fit_te = Omega_te*K;
        
        
        %%Errors
        trainingError = sqrt(sum(sum((train_sig - fit_tr).^2))/sum(sum(train_sig.^2))) %training error
        testingError = sqrt(sum(sum((test_sig - fit_te).^2))/sum(sum(test_sig.^2))) %testingg error

        errorMatrixTraining(driveInd, targetInd) = trainingError;
        errorMatrixTesting(driveInd, targetInd) = testingError;

full_span = 1:366;
griddddd = zeros(170, 192);
figure(1)
hold on
plot(full_span,[train_sig;test_sig],'LineWidth',1)
plot(full_span,[fit_tr;fit_te],'--','LineWidth',1)
set(gca,'FontSize',20)
xlim([250, 330])
xlabel('Day','FontSize',15)
ylabel('Number of crimes', 'FontSize', 15)
xline(full_span(train_span),'k--')
legend('Target Signal','Predicted Signal','Beginning of Testing Phase')
set(gca,'Box','on');