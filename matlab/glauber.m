function [x, h] = glauber(x0, Y, lambda, beta, ham, param, verbose)
% GLAUBER recovers the vector x generating the non-linear noisy observation
% Y by running a Glauber chain from initial state x0.
% 
%   Usage:
%       [x, h] = glauber(x0, Y, lambda, beta, hamiltonian, param)
%
%   Input:
%       x0 : vector
%           (Optional) Initial state of the chain.
%       Y : matrix
%           Non-linear noisy observations.
%       lambda: float
%           A fixed parameter in the generation of the non-linear
%           observations.
%       beta : float
%           Inverse temperature in the Gibbs-Boltzman distribution of x.
%       ham: function_handle
%           Hamiltonian of the Gibbs-Boltzman distribution of x.
%       param : structure
%           (Optional) Additional parameters.
%           maxit : int
%               Maximum number of iterations of the chain.
%           tol : float
%               Tolerance on the Hamiltonian of the solution.
%       verbose : >= 0
%           Level of verbose.
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
% Author(s): Rodrigo Pena
% Date : 01/12/2016
% Testing: test_glauber.m

%% Parse input
[N, M] = size(Y);
assert(N == M, 'Y must be a square matrix');

if isempty(x0); x0 = 2 * randi([0, 1], [N, 1]) - 1; end
x0 = x0(:); % Make sure we have a column vector.
assert(length(x0) == N, ...
    'x0 must be a vector with the same length as the rows/columns of Y');

assert(lambda > 0, 'lambda must be greater than zero');

assert(beta > 0, 'beta must be greater than zero.');

if isempty(ham); ham = @(x) 1; end
assert(isa(ham, 'function_handle'), ...
    'hamiltonian must be a function handle');

if isempty(param); param = struct; end
assert(isa(param, 'struct'), 'param must be a structure');
if ~isfield(param, 'maxit'); param.maxit = 1000; end
if ~isfield(param, 'tol'); param.tol = 0; end

if isempty(verbose); verbose = 0; end
assert(verbose >= 0, ...
    'verbose level should be greater than or equal to zero.');

%% Initialization
h = zeros(param.maxit, 1); 
x = x0;

% Define transition probabilities:
p = @(x, i) 0.5 * ...
    (1 + tanh(2 * beta * sqrt(lambda/N) * (Y(i,:)*x - Y(i,i)*x(i))));

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
    
    h(n) = ham(x);
    
    if h(n) <= param.tol
        break;
    end
    
    if verbose > 0
        if n == 1; figure(); end
        stem(x);
        hold on
        stem(i, x(i), 'r');
        axis([0, N, min(x) - 0.1, max(x) + 0.1])
        hold off
        title('$$x$$', ...
              'interpreter', 'latex', ...
              'FontSize', 20);
        display('Press any key to continue');  
        pause();
    end
end

%% Postprocessing
h = h(1:n); % Remove extra zeros

end