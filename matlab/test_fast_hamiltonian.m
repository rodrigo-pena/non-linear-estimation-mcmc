%test fast hamiltonian
close all
clear all

%%Define parameters
N = 100;
lambda = 0.01 * N.^2;
beta = 1e-3;

%% Generate data
[~, Y, Z] = gen_data(N, lambda);

%% Generate Guess

i_t = randi(N, 1);

x = 2 * randi([0, 1], [N, 1]) - 1;
x_t= x;
x_t(i_t)=-x(i_t);
%% Define the two functions
p1 = @(x_t, x, i)  exp(-beta*(hamiltonian(x_t,Y,lambda) - hamiltonian(x,Y,lambda))) ;
p2 = @(x_t, x, i)  exp(-beta*( fast_ham_diff(Y,x_t,x,i,lambda) ))  ;

%% Time and Check consistency

tic
v1 = p1(x_t,x,i_t);
toc

tic
v2 = p2(x_t,x,i_t);
toc


disp('v1 is:')
v1
disp('v2 is:')
v2
disp('sum of Y:')
sum(sum(Y))

if v1==v2
    disp('consistent')
end