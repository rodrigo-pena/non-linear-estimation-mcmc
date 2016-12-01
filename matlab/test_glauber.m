%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to test the Glauber sampling implementation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
N = 50;
lambda = N;
factor = sqrt(lambda/N);
beta = 1;
param = struct('maxit', 10000, 'tol', 0);

%% Generate data
x = randi(2,[N,1]) - 1;
Z = randn(N);
Y = factor * (x * x') + Z;

%% Define the hamiltonian
hamiltonian = @(x) sum(sum(triu((Y - factor * (x * x')), 1) .^ 2));

%% Run chain
[xr, h] = glauber([], Y, lambda, beta, hamiltonian, param);

%% Check sample
n_diff = sum(sum(x ~= xr));
fprintf('Number of differences: %d \n', n_diff);

figure(1);
subplot(121);
imagesc(x * x');
title('xx^{T}');
subplot(122);
imagesc(xr * xr');
title('x_{r}x_{r}^{T}');

figure(2);
plot(h)
xlabel('Iteration number');
ylabel('Hamiltonian');