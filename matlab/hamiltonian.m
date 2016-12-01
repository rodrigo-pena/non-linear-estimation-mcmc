function h = hamiltonian( x, Y, lambda )
% HAMILTONIAN of x given data Y
%
% Usage:
%   h = hamiltonian( x, Y )

N = length(x);
h = sum(sum(triu((Y - sqrt(lambda / N) .* (x * x')) .^2), 2));

end

