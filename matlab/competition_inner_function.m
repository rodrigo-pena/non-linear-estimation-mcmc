function [x, h, b] = competition_inner_function(Y, chain_c,iter_c,calc_ham)
% SIMMULATED_ANNEALING recovers the vector x generating the non-linear 
% noisy observation Y by running a chain_type Markov chain from initial
% state x0.
% 
%   Usage:
%       [x, h, b] = competition_function(Y, chain_type,time)
%
%   Input:
%       Y : matrix
%           (Optional) Initial state of the annealing.
%       chain_type : Glauber 
%                    or Metropolis
%       iter_c : number of max iterations 
%              for execution
%       calc_ham : calculate hamiltonian or not
%   Output:
%       x : vector
%           Recovered vector.
%       h : vector
%           The evaluation of the Hamiltonian at the fihnal iteration.
%
%
%   References:
%       
%
% Author(s): Pitas Konstantinos
% Date : 20/12/2016
% Testing: test_competition_function.m

%% Setup
N = size(Y,2);
lambda = 0.01 * N.^2;
beta0 = 1e-3;
%beta0 = 0.12/(1.05^iter_c);
chain_type = chain_c; %'metropolis' 'glauber'
param = struct('maxit_anneal', iter_c, ...
               'maxit', N*2, ...
               'tol_anneal', 0, ...
               'tol', 0);

%% Define the hamiltonian and beta_update functions
ham = @(x) hamiltonian(x, Y, lambda); 
bup = @(b, n) inv_temp_fun(b, n, 'exp');

%% Run annealing
[x, ~, b] = simulated_annealing([], Y, lambda, beta0, [], bup, ...
                                 chain_type, param);

%%Calculate Hamiltonian
if calc_ham ==1
    h=ham(x);
else
    h=1;
end

end