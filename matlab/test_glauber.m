%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to test the Glauber sampling implementation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
N = 50;
lambda =  .01 * N^2;
beta = 0.5;
x0 = [];
param = struct('maxit', 2.*N, ...
               'tol', 0);
verbose = 0;

%% Generate data
[x, Y, Z] = gen_data(N, lambda);

if verbose > 0
    figure(1);
    stem(x);
    axis([0, N, min(x) - 0.1, max(x) + 0.1])
end

%% Define the hamiltonian
ham = @(x) hamiltonian(x, Y, lambda);

%% Run chain
[xr, h] = glauber(x0, Y, lambda, beta, ham, param, verbose);

%% Check sample
n_diff = sum(sum(x ~= xr));
pct_diff = 100 .* (n_diff ./ N);
fprintf('Difference between x and xr: %2.1d%% \n', pct_diff);

plot_matrices(x, Y, Z, xr);

figure('Position', [1149, 100, 1049, 895]);
plot(h)
xlabel('Iteration number', 'FontSize', 20);
ylabel('Hamiltonian', 'FontSize', 20);
grid on