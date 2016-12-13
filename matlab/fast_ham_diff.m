function [h_d]= fast_ham_diff(Y,x_t,x,i,lambda)
%Fast computation of hamiltonian difference
%

a_1=(Y(i,:)-sqrt(lambda/length(x_t))*x_t(i)*x_t').^2;
a_2=sum(a_1)-a_1(i);

b_1=(Y(i,:)-sqrt(lambda/length(x))*x(i)*x').^2;
b_2=sum(b_1)-b_1(i);

h_d = a_2-b_2;

end