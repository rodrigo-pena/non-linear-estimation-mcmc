%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to test lambda_exp                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
N = 50;
beta0 = 1e-3;
chain_type = 'metropolis';
param = struct('maxit_anneal', 100, ...
               'maxit', 100, ...
               'tol_anneal', 0, ...
               'tol', 0, ...
               'n_gen_data', 20);

%% Run lambda exp
lambda_list = (1:10:N);
[mean_v, mean_sq_e, SDSE] = run_lambda_exp(N, lambda_list, chain_type, beta0, param);

%% Check sample
figure('Position', [1149, 100, 1049, 895]);
subplot(211)
plot(lambda_list, mean_v)
xlabel('Lambda', 'FontSize', 20);
ylabel('Mean Hamiltonian', 'FontSize', 20);
grid on
subplot(212)
errorbar(lambda_list, mean_sq_e, SDSE)
xlabel('Lambda', 'FontSize', 20);
ylabel('Mean squared error', 'FontSize', 20);
grid on