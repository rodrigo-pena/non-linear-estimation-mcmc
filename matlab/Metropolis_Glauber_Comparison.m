%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to compare Metropolis and Glauber %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all

initial_N = 100;
step_N = 100;
final_N = 1000;

numIt = 10; % #loops/signal_size 

k=1;
for N=initial_N:step_N:final_N
    
    for i =1:numIt
        
        %Parameters
        lambda = 0.01 * N.^2;
        beta0 = 1e-3;

        % Generate data
        [x, Y, Z] = gen_data(N, lambda);

        % Define the hamiltonian and beta_update functions
        ham = @(x) hamiltonian(x, Y, lambda); 
        % Dummy function to make it go faster (avoids computing the
        % hamiltonian at each iteration):
        %ham = @(x) 1;
        bup = @(b, n) inv_temp_fun(b, n, 'exp');

        % Metropolis
        chain_type = 'metropolis';
        param = struct('maxit_anneal', 100, ...
                       'maxit', 2*N, ...
                       'tol_anneal', 0, ...
                       'tol', 0);
        % Run annealing Metropolis
        tic
        [xM, hM, bM] = simulated_annealing([], Y, lambda, beta0, ham, bup, chain_type, param);
        tM = toc;
        
        % Glauber
        chain_type = 'glauber';
        param = struct('maxit_anneal', 100, ...
                       'maxit', 2*N, ...
                       'tol_anneal', 0, ...
                       'tol', 0);
        % Run annealing Glauber
        tic
        [xG, hG, bG] = simulated_annealing([], Y, lambda, beta0, ham, bup, chain_type, param);
        tG = toc;

        % Save results
               
        % Metropolis Recovered "x" , Hamiltonian, Execution Time
        xMT(i,k)=sum((xM-x).^2)/N;
        hMT(i,k)=hM(end);
        tMT(i,k)=tM;
        
        % Glauber Recovered "x" and Hamiltonian, Execution Time
        xGT(i,k)=sum((xG-x).^2)/N;
        hGT(i,k)=hG(end);
        tGT(i,k)=tG;
        
        
    end
k=k+1;
end

%Calculate Statistics
%Metropolis
sQerrorM = mean(xMT,2);
hamM = mean(hMT,2);
timeM = mean(tMT,2);


%Glauber
sQerrorG = mean(xMT,2);
hamG = mean(hGT,2);
timeG = mean(tMT,2);

%Plot

%% Mean Square Error
figure('Position', [1149, 100, 1049, 895]);

subplot(211)
plot(initial_N:step_N:final_N, sQerrorM(:))
xlabel('Signal Size');
ylabel('Mean Square Error');
grid on

subplot(212)
plot(initial_N:step_N:final_N, sQerrorG(:))
xlabel('Signal Size');
ylabel('Mean Square Error');
grid on

%% Hamiltonian
figure('Position', [1149, 100, 1049, 895]);

subplot(211)
plot(initial_N:step_N:final_N, hamM(:))
xlabel('Signal Size');
ylabel('Final Hamiltonian');
grid on

subplot(212)
plot(initial_N:step_N:final_N, hamG(:))
xlabel('Signal Size');
ylabel('Final Hamiltonian');
grid on

%% Time
figure('Position', [1149, 100, 1049, 895]);

subplot(211)
plot(initial_N:step_N:final_N, timeM(:))
xlabel('Signal Size');
ylabel('Average Execution Time');
grid on

subplot(212)
plot(initial_N:step_N:final_N, timeG(:))
xlabel('Signal Size');
ylabel('Average Execution Time');
grid on


