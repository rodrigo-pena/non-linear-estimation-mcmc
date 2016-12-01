function [x, Y, Z] = gen_data(N, lambda)
%GEN_DATA generates the N-dimensional non-linear data in the problem
%
% Usage:
%   [x, Y, Z] = gen_data(N)

x = 2 * randi([0, 1], [N, 1]) - 1;
Z = randn(N);
Y = sqrt(lambda/N) .* (x * x') + Z;

end
