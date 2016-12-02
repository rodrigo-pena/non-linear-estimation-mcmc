function [x, h, b] = simulated_annealing(x0, Y, lambda, beta0, ...
                                         ham, beta_update, ...
                                         chain_type, param)
% SIMMULATED_ANNEALING recovers the vector x generating the non-linear 
% noisy observation Y by running a chain_type Markov chain from initial
% state x0.
% 
%   Usage:
%       [x, h] = simulated_annealing(x0, Y, lambda, beta0, hamiltonian, ...
%                                    chain_type, param)
%
%   Input:
%       x0 : vector
%           (Optional) Initial state of the annealing.
%       Y : matrix
%           Non-linear noisy observations.
%       lambda: float
%           A fixed parameter in the generation of the non-linear
%           observations.
%       beta0 : float
%           (Optional)Initial value for the inverse temperature in the 
%           Gibbs-Boltzman distribution of x.
%       ham: function_handle
%           Hamiltonian of the Gibbs-Boltzman distribution of x.
%       beta_update: function_handle
%           (Optional) Update procedure for beta at each annealing 
%           iteration (n), as a function of beta0 and n.
%       chain_type : string
%           Type of Markov chain to use
%           'metropolis' : Use the Metropolis chain.
%           'glauber' : Use the Glauber chain.
%       param : structure
%           (Optional) Additional parameters.
%           maxit_anneal : int
%               Maximum number of iterations of the annealing.
%           maxit : int
%               Maximum number of iterations of the chain.
%           tol_anneal : float
%               Tolerance on the Hamiltonian of the annealing solution.
%           tol : float
%               Tolerance on the Hamiltonian of the chain sample.
%         
%   Output:
%       x : vector
%           Recovered vector.
%       h : vector
%           The evaluation of the Hamiltonian at each iteration.
%       b : vector
%           The value of parameter beta at each iteration.
%
%   Examples:
%       
%          
%   See also glauber.m, metropolis.m
%
%   References:
%       
%
% Author(s): Rodrigo Pena
% Date : 02/12/2016
% Testing: test_simulated_annealing.m

%% Parse input
if isempty(beta0); beta0 = 1e-3; end 
assert(beta0 > 0, 'beta0 must be greater than zero.');

if isempty(beta_update)
    beta_update = @(b, n) inv_temp_fun(b, n, 'exp'); 
end 
assert(isa(beta_update, 'function_handle'), ...
    'beta_update must be a function handle.');

if isempty(chain_type); chain_type = 'metropolis'; end
assert(strcmp(chain_type, 'metropolis') | ...
       strcmp(chain_type, 'glauber'), ...
       'Allowed chain types are ''metropolis'' or ''glauber'' ')

if isempty(param); param = struct; end
assert(isa(param, 'struct'), 'param must be a structure');
if ~isfield(param, 'maxit_anneal'); param.maxit_anneal = 1000; end
if ~isfield(param, 'tol_anneal'); param.tol_anneal = 0; end

%% Initialization
h = cell(param.maxit_anneal, 1); 
b = cell(param.maxit_anneal, 1);
x = x0;
beta = beta0;

%% Run annealing
for n = 1:param.maxit_anneal
    
    % Run Markov chain of type chain_type
    switch chain_type
        case 'metropolis'
            [x, h{n}] = metropolis(x, Y, lambda, beta, ham, param, []);
        case 'glauber'
            [x, h{n}] = glauber(x, Y, lambda, beta, ham, param, []);
    end
    
    b{n} = repmat(beta, [length(h{n}), 1]);
    
    % Increase beta
    beta = beta_update(beta0, n);
    
    % Stopping criterion
    if h{n}(end) <= param.tol_anneal
        break;
    end

end

%% Postprocessing
h = h(1:n); % Remove extra empty space
h = cell2mat(h);
b = b(1:n); % Remove extra empty space
b = cell2mat(b);

end
