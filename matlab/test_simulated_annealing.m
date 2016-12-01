%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to test the simulated annealing implementation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
N = 50;
lambda = 2 * N^2;
beta0 = 1e-3;
chain_type = 'glauber';
param = struct('maxit_anneal', 100, ...
               'maxit', 1000, ...
               'tol_anneal', 0, ...
               'tol', 0);

%% Generate data
[x, Y, Z] = gen_data(N, lambda);

%% Define the hamiltonian
ham = @(x) hamiltonian(x, Y, lambda);

%% Run annealing
[xr, h, b] = simulated_annealing([], Y, lambda, beta0, ham, [], ...
                                 chain_type, param);

%% Check sample
n_diff = sum(sum(x ~= xr));
fprintf('Number of differences between x and xr: %d \n', n_diff);

plot_matrices(x, Y, Z, xr);

figure('Position', [1149, 100, 1049, 895]);
subplot(211)
plot(h)
xlabel('Iteration number');
ylabel('Hamiltonian');
grid on
subplot(212)
plot(b)
xlabel('Iteration number');
ylabel('\beta');
grid on