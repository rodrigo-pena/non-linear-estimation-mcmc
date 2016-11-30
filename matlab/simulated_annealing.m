function x = simulated_annealing(x_0, prob, chain_type)
% SIMMULATED_ANNEALING draws a sample x from the (unnormalized) probability
% distribution prob by running simmulated annealing on a Markov chain of 
% type chain_type from initial state x_0.
% 
%   Usage:
%       x = simmulated_annealing(x_0, prob, chain_type)
%
%   Input:
%       x_0 : vector / matrix
%           Initial state of the Metropolis chain
%       prob : function handle
%           (Unnormalized) probability distribution from which to sample
%       chain_type: string
%           'metropolis' : use Metropolis chain
%           'glauber' :use Glauber chain
%         
%   Output:
%       x : vector / matrix
%           Sample from the input distribution
%
%   Examples:
%       
%          
%   See also glauber.m, metropolis.m
%
%   References:
%       
%
% Author(s): 
% Date :
% Testing: 

end