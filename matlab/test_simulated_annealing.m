%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to test the simulated annealing implementation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
N = 100;
lambda = 0.01 * N.^2;
beta0 = 1e-3;
%chain_type = 'metropolis';
chain_type = 'glauber';
param = struct('maxit_anneal', 100, ...
               'maxit', 2*N, ...
               'tol_anneal', 0, ...
               'tol', 0);

%% Generate data
[x, Y, Z] = gen_data(N, lambda);

%% Define the hamiltonian and beta_update functions
ham = @(x) hamiltonian(x, Y, lambda); 
% Dummy function to make it go faster (avoids computing the
% hamiltonian at each iteration):
%ham = @(x) 1;
bup = @(b, n) inv_temp_fun(b, n, 'exp');

%% Run annealing

tic
[xr, h, b] = simulated_annealing([], Y, lambda, beta0, ham, bup, ...
                                 chain_type, param);
toc

%% Check sample
n_diff = sum(sum(x ~= xr));
pct_diff = 100 .* (n_diff ./ N);
fprintf('Difference between x and xr: %3.2f%% \n', pct_diff);

plot_matrices(x, Y, Z, xr);

figure('Position', [1149, 100, 1049, 895]);
subplot(211)
plot(h./(N.^2))
xlabel('Iteration number', 'FontSize', 20);
ylabel('$$\frac{1}{N^2}H_{Y}(x)$$', 'interpreter', 'latex', 'FontSize', 20);
grid on
subplot(212)
plot(b)
xlabel('Iteration number', 'FontSize', 20);
ylabel('\beta', 'FontSize', 20);
grid on