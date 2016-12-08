function [mean_v, mean_sq_e, SDSE] = ...
    run_lambda_exp(N, lambda_list, chain_type, beta0, param)
% run_lambda_exp estimates mean / mean squear / var with respect to lambda
% 
%   Usage:
%       [mean_v, mean_sq_e, SDSE] = 
%                         run_lambda_exp(N, lambda_list, chain_type, beta0, param)
%
%   Input:
%       N: int
%           Size of the data.
%       lambda_list: vector
%           List of parameter lambda for the experiment.
%       chain_type : string
%           Type of Markov chain to use
%           'metropolis' : Use the Metropolis chain.
%           'glauber' : Use the Glauber chain.
%       beta0 : float
%           Initial value for the inverse temperature.
%       param: structure
%           (Optional) Additional parameters. See simulated_annealing.m
%         
%   Output:
%       mean_v: vector
%           List of mean values of energy, one for each lambda 
%       mean_sq_e: vector
%           List of mean squared errors, one for each lambda 
%       SDSE: vector
%           List of standard deviations of the squared error, one for each
%           lambda 
%       
%   Examples:
%
%
%   References:
%       
%
% Author(s): Renata Khasanova
% Date : 05/12/2016
% Testing: run_lambda_exp.m


%% Parse input
if isempty(param); param = struct; end
assert(isa(param, 'struct'), 'param must be a structure');
if ~isfield(param, 'n_gen_data'); param.n_gen_data = 20; end
assert(all(lambda_list > 0), 'lambda must be greater than zero');
assert(size(lambda_list, 1) == 1, 'lambda_list must be a vector');

%% Initialization
len_lambda = size(lambda_list, 2);
mean_v = zeros(1, len_lambda);
mean_sq_e = zeros(1, len_lambda);
SDSE = zeros(1, len_lambda);

% Define the beta_update function
beta_update = @(b, n) inv_temp_fun(b, n, 'exp');

%% Generating of mean energy, mean SE, mean SDSE
for ind_lambda = 1:len_lambda
    
    lambda = lambda_list(ind_lambda);
    result_h = zeros(param.n_gen_data, 1);
    result_SE = zeros(param.n_gen_data, 1);
    
    for ind_exp = 1:param.n_gen_data
        [x, Y, ~] = gen_data(N, lambda);

        % Run annealing
        [xr, ~, ~] = simulated_annealing([], Y, lambda, beta0, [], ...
                                         beta_update, chain_type, param);
                                     
        result_h(ind_exp) = hamiltonian(xr, Y, lambda) ./ N;
        result_SE(ind_exp) = sum((xr - x) .^2) ./ N;
    end
    
    mean_v(ind_lambda) = mean(result_h);
    mean_sq_e(ind_lambda) = mean(result_SE);
    SDSE(ind_lambda) = std(result_SE);
end



