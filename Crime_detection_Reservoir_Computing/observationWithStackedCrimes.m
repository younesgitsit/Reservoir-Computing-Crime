% Younes Slaoui DHS
% - Conducts spatiotemporal observation (timeseries prediction) on stacked
% data (errors generated using averages)
clear all

load('allStackedCrimes.mat');

c = 399;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
avgTr = [];
avgTe = [];

tr = [];
te = [];
alphaErr = [];

for L = 1:2:171
tr = [];
te = [];
for i = 1:30

        Q = 25;
        M = c;% num drive crimes x c
        %L = 7;
        ts = 1;
        
        full_span = 366;
        train_span = 285;
        test_span = 80;
        
        tmax = test_span + train_span;
        ModelParams.tau = ts; % time step
        ModelParams.nstep = tmax; % number of time steps to generate
        ModelParams.N = Q;  % number of spatial grid points 
        ModelParams.d = L;  % periodicity length 
        ModelParams.dT = 1;
        
        kgain = 0.2;
        
        n = 300;
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
      
        
        drive_sig = [allStackedCrimes{1,23}];

        % Train
        target_sig = allStackedCrimes{1,7};


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
        te = [te, testingError];
        tr = [tr, trainingError];
end
avgTr = [avgTr, mean(tr)];
avgTe = [avgTe, mean(te)];
end


periodicity = 1:2:171;

figure;
plot(periodicity, avgTr);
xlabel('reservoir periodicity');
ylabel('training error');
title('Training errors vs periodicity of the reservoir');

figure;
plot(periodicity, avgTe);
xlabel('reservoir periodicity');
ylabel('testing error');
title('Testing errors vs periodicity of the reservoir');

%fit_te(fit_te < 0.001) = 0;

return;

fitCell = cell(1, 366);

for i = 1:size(fit_tr, 1)

    vectorFit = fit_tr(i,:);
    matrixFit = reshape(vectorFit, 21, 19)';
    fitCell{1, i} = matrixFit;

end
for i = 1:size(fit_te, 1)

    vectorFit = fit_te(i,:);
    matrixFit = reshape(vectorFit, 21, 19)';
    fitCell{1, i+285} = matrixFit;

end


fps = 50;
figure;

% Loop through each image and display them
for i = 1:numel(fitCell)

title(['Day ' num2str(i)]);

subplot(1, 2, 1);
imagesc(allCrimeGridsSmoothed{1,7}{1,i});
axis image;
colormap('jet');
title('Original Image');

subplot(1, 2, 2);
imagesc(fitCell{1,i});
axis image;
colormap('jet');
title('Predicted Image');
    
    % Calculate the pause time based on the desired frame rate
    pause(1/fps);
end

% Close the figure
close;









