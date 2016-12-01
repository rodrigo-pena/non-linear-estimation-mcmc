function [x, h] = glauber(x0, Y, lambda, beta, hamiltonian, param)
% GLAUBER recovers the vector x generating the non-linear noisy observation
% Y by running a Glauber chain from initial state x_0.
% 
%   Usage:
%       [x, h] = glauber(x0, Y, lambda, beta, hamiltonian, param)
%
%   Input:
%       x_0 : vector
%           Initial state of the chain.
%       Y : matrix
%           Non-linear noisy observations.
%       lambda: float
%           A fixed parameter in the generation of the non-linear
%           observations.
%       beta : float
%           Inverse temperature in the Gibbs-Boltzman distribution of x.
%       hamiltonian: function_handle
%           Hamiltonian of the Gibbs-Boltzman distribution of x.
%       param : structure
%           Additional parameters.
%           maxit : int
%               Maximum number of iterations of the chain.
%           tol : float
%               Tolerance on the Hamiltonian of the solution.
%         
%   Output:
%       x : vector
%           Recovered vector.
%       h : vector
%           The evaluation of the Hamiltonian at each iteration.
%       
%
%   Examples:
%       
%          
%   See also metropolis.m, simmulated_annealing.m
%
%   References:
%       
%
% Author(s): 
% Date :
% Testing: 

%% Parse input
[N, M] = size(Y);
assert(N == M, 'Y must be a square matrix');

if isempty(x0); x0 = randi(2,[N,1]) - 1; end
x0 = x0(:); % Make sure we have a column vector.
assert(length(x0) == N, ...
    'x0 must be a vector with the same length as the rows/columns of Y');

assert(lambda > 0, 'lambda must be greater than zero');

assert(beta > 0, 'beta must be greater than zero.');

assert(isa(hamiltonian, 'function_handle'), ...
    'hamiltonian must be a function handle');

if isempty(param); param = struct; end
assert(isa(param, 'struct'), 'param must be a structure');
if ~isfield(param, 'maxit'); param.maxit = 1000; end
if ~isfield(param, 'tol'); param.tol = 0; end

%% Initialization
h = zeros(param.maxit, 1); 
x = x0;

% Define transition probabilities:
p = @(x, i) 0.5 * ...
    (1 + tanh(2*beta*sqrt(lambda/N)*(Y(i,:)*x - Y(i,i)*x(i))));

%% Run chain
for n = 1:param.maxit
    % Select vertex at random
    i = randi(N, 1);
    
    % Accept positive or negative value reset
    if p(x, i) >= rand(1)
        x(i) = 1;
    else
        x(i) = -1;
    end
    
    h(n) = hamiltonian(x);
    
    if h(n) <= param.tol
        break;
    end
end

%% Postprocessing
h = h(1:n); % Remove extra zeros

end