function [x, h, b] = competition_outer_function(Y, chain_c,time_full)
% Same as inner function but takes as input a specific max time for
% execution. Performs first a test to time Ntest annealing iterations finds
% execution time for N=(time_full)/(time_test/N_test)

%% Do test 
Ntest=10;
calc_ham = 0;
tic
[~,~,~] = competition_inner_function(Y, chain_c,Ntest,calc_ham);
time_test = toc;

time_per_iteration = time_test/Ntest;


%% Calculate results
Nfull = floor(time_full/time_per_iteration)
time_to_run = Nfull*time_per_iteration
calc_ham = 1;
[x,h,b] = competition_inner_function(Y, chain_c,Nfull,calc_ham);


end