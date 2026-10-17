function [y] = ar1simul_sol(a,T)
%%   This function simulates an AR(1) process.
%   a = coefficient
%   T = sample size


e=randn(T,1);  % error term

y=zeros(T,1); % store
y(1)=e(1);

for t=2:T
    y(t)= a*y(t-1)+e(t);
end


