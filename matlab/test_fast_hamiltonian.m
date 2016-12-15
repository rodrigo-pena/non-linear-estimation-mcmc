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
%% The two functions are:
%p1 = @(x_t, x, i)  exp(-beta*(hamiltonian(x_t,Y,lambda) - hamiltonian(x,Y,lambda))) ;
%p2 = @(x_t, x, i)  exp(-beta*( fast_ham_diff(Y,x_t,x,i,lambda) ))  ;

%% Time and Check consistency

tic
v1 = exp(-beta*(hamiltonian(x_t,Y,lambda) - hamiltonian(x,Y,lambda)));
toc

tic
v2 = exp(-beta*( fast_ham_diff(Y,x_t,x,i_t,lambda) ));
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

%% Check mean absolute difference between full and fast computation
%  in relation to signal size. 

N1=10;
Nstep=10;
N2=500;

k=1;
for j =N1:Nstep:N2
    disp('Iteration:')
    k
    [~, Y, Z] = gen_data(j, lambda);
    for i = 1:100
        

        i_t = randi(j, 1);
        x = 2 * randi([0, 1], [j, 1]) - 1;
        x_t= x;
        x_t(i_t)=-x(i_t);
        
        tic
        v1(i,k) = exp(-beta*(hamiltonian(x_t,Y,lambda) - hamiltonian(x,Y,lambda)));
        t1(i,k)=toc;
        
        tic
        v2(i,k) = exp(-beta*( fast_ham_diff(Y,x_t,x,i_t,lambda) ));
        t2(i,k)=toc;
        
        diff(i,k)=abs(v1(i,k)-v2(i,k));
        
    end
    k=k+1;
end

%Can do normalization so as to have abs difference as percentage of
%calculated value with fast method
diff=diff./v2;

mean_d=mean(diff,1);
std_d=std(diff,[],1);

figure()
bar(N1:Nstep:N2,mean_d)
title('Comparison1 Fast vs Full Hamiltonian')
xlabel('Signal Dimension')
ylabel('Mean of Absolute Value Difference')

figure()
bar(N1:Nstep:N2,std_d)
title('Comparison2 Fast vs Full Hamiltonian')
xlabel('Signal Dimension')
ylabel('StD of Absolute Value Difference')

%Times
meant_Slow=mean(t1,1);
meant_Fast=mean(t2,1);

figure();
plot(N1:Nstep:N2, meant_Slow(:),N1:Nstep:N2, meant_Fast(:))
xlabel('Signal Size');
ylabel('Execution time (s)');
legend('Slow Ham','Fast Ham')
%title('Slow vs Fast Hamiltonian')
grid on