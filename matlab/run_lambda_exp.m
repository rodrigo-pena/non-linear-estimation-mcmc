function [mean_v, mean_sq_e, SDSE] = ...
    run_lambda_exp(N, lambda_list, chain_type, beta0, param)
% run_lambda_exp estimates mean / mean squear / var with respect to lambda
% 
%   Usage:
%       [mean_v, mean_sq_e, SDSE] = 
%                         run_lambda_exp(N, lambda_list, chain_type, beta0, param)
%
%   Input:
%       N: size of the data
%       lambda_list: list of the parameter lambda for the experiment
%       chain_type: function_handle
%           Hamiltonian of the Gibbs-Boltzman distribution of x
%       beta0: float
%       param: structure
%           (Optional) Additional parameters.
%         
%   Output:
%       --
%       
%   Examples:
%       mean_v: list of mean values of energy for a given lambda 
%       mean_sq_e: list of mean squared error for a given lambda 
%       SDSE: list of standard deviation of the squared error
%             for a given lambda
%   References:
%       
%
% Author(s): Renata Khasanova
% Date : 05/12/2016
% Testing: run_lambda_exp.m


%% Parse input
if isempty(param); param = struct; end
assert(isa(param, 'struct'), 'param must be a structure');
assert(all(lambda_list > 0), 'lambda must be greater than zero');
assert(size(lambda_list, 1) == 1, 'lambda_list must be a vector');

%% Initialization
len_lambda = size(lambda_list,2);
mean_v = zeros(1, len_lambda);
mean_sq_e = zeros(1, len_lambda);
SDSE = zeros(1, len_lambda);

%% Generating of mean energy, mean SE, mean SDSE
for ind_lambda = 1:len_lambda
    lambda = lambda_list(ind_lambda);
    result_h = zeros(param.n_gen_data,1);
    result_SE = zeros(param.n_gen_data,1);
    for ind_exp=1:1:param.n_gen_data
        [x, Y, Z] = gen_data(N, lambda);
        %% Define the hamiltonian and beta_update functions
        ham = @(x) hamiltonian(x, Y, lambda);
        beta_update = @(b, n) inv_temp_fun(b, n, 'exp');

        %% Run annealing
        [xr, h, b] = simulated_annealing([], Y, lambda, beta0, ham, ...
                                         beta_update, ...
                                         chain_type, param);
        result_h(ind_exp) = 1.* h(end) ./ N;
        result_SE(ind_exp) = sum((xr - x) .^2) ./ N;
    end
    mean_v(ind_lambda) = mean(result_h);
    mean_sq_e(ind_lambda) = mean(result_SE);
    SDSE(ind_lambda) = get_SDSE(result_SE);
end



