function h = hamiltonian( x, Y, lambda )
% HAMILTONIAN of x given data Y
%
% Usage:
%   h = hamiltonian( x, Y )

N = length(x);

% Tried this to see if it goes faster, but it didn't:
%M = (Y - sqrt(lambda / N) .* (x * x')) .^ 2;
%M = M - diag(diag(M));
%h = sum(M(:)) / 2;

h = sum(sum(triu((Y - sqrt(lambda / N) .* (x * x')) .^ 2, 2)));

end

