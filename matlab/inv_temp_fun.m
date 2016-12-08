function b = inv_temp_fun(b0, n, type)
% INV_TEMP_FUN defines the update procedure for the inverse temperature
% during simulated annealing
%   
%   Usage:
%       b = inv_temp_fun(b0, n, type)
%
%   Input:
%       b0 : float
%           Inverse temperature on the first iteration
%       n : int
%           Current iteration number
%       type : string
%           Type of update.
%           'exp' : b = 1.05^n * b0
%           'fast' : b = b0 * n
%           'boltz' : b = b0 * log(n)
%
%   Output:
%       b : float
%           Inverse temperature for the current iteration
%
%   Examples:
%       
%          
%   See also glauber.m, metropolis.m
%
%   References:
%      https://www.mathworks.com/help/gads/simulated-annealing-options.html
%       
%
% Author(s): Rodrigo Pena
% Date : 02/12/2016
% Testing: 

if isempty(type); type = 'exp'; end

switch type
    case 'exp'
        b = b0 .* (1.05 .^ n);
    case 'fast'
        b = b0 .* n;
    case 'boltz'
        b = b0 .* log(n);
    otherwise
        b = b0;
end

end

