%test competition function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to test competition function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 2000;%2000 and time 15
lambda = 0.01 * N.^2;
chain_c = 'glauber';
time_full = 15; %time in seconds

%% Generate data
[x, Y, Z] = gen_data(N, lambda);

%% Run annealing

tic
[xr, h, b] = competition_outer_function(Y, chain_c,time_full);
toc

%% Check sample
n_diff = min(sum(sum(x ~= xr)),sum(sum(x ~= -xr)));
pct_diff = 100 .* (n_diff ./ N);
fprintf('Difference between x and xr: %3.2f%% \n', pct_diff);

plot_matrices(x, Y, Z, xr);

figure('Position', [1149, 100, 1049, 895]);
subplot(211)
plot(h./(N.^2))
xlabel('Iteration number', 'FontSize', 20);
ylabel('$$\frac{1}{N^2}H_{Y}(x)$$', 'interpreter', 'latex', 'FontSize', 20);
grid on
subplot(212)
plot(b)
xlabel('Iteration number', 'FontSize', 20);
ylabel('\beta', 'FontSize', 20);
grid on