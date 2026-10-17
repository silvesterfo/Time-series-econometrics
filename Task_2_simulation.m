clear; clc;

% set parameter values
sig = 1;    % variance of disturbance
rep = 1000;   % number of replications
avec = [0;0.5;0.9;0.99];   % AR(1) coefficient
Tvec = [100; 300; 400];     % number of observations

% set matrices
ahatvar_theo = zeros(length(avec),length(Tvec)); % =zeros(4,3)
Ahat = zeros(rep,length(avec),length(Tvec)); % zeros(1000,4,3)
tic
% start simulation and estimation
for i=1:length(avec)
    a=avec(i);
    for j=1:length(Tvec)
        T=Tvec(j);
        for s=1:rep
            Y = ar1simul_sol(a,T);                      % simulate data set
            ylag = Y(1:T-1);                        % compute y(t-1)
            yt = Y(2:end);                          % compute y(t)
            ahat = ylag\yt;  % OLS. Note ylag\yt is equivalent to, but faster than, inv(ylag'*ylag)*ylag'*yt
            Ahat(s,i,j) = ahat;
        end     

        % compute theoretical asymptotic variance
        ahatvar_theo(i,j) = (1-a^2)/T;                  % theoretical variance, using A = plim((1/T)*sum(ylag.^2)) = E(y(t-1)^2) = sig/(1-a1^2)

    end
end
toc
% plot the simulated and theoretical distribution
for j = 1:length(Tvec)
    figure(j)
    for i = 1:length(avec)
        [pdf_sim, as] = ksdensity(Ahat(:,i,j));           % estimate empirical density "pdf_sim" at points "as"  
        pdf_theo = normpdf(as,avec(i),sqrt(ahatvar_theo(i,j)));      % compute asymptotic density "pdf_theo" at points "as"
        subplot(2,2,i); plot(as,pdf_sim,'k-');                        % plot empirical density
        subplot(2,2,i); hold on; plot(as,pdf_theo,'r-');                 % plot theoretical density
        subplot(2,2,i); hold on; xline(mean(Ahat(:,i,j)),'-.k')
        legend('Simulated','Asymptotic','Location','NorthWest')% annotate figure
%         set(h, 'Box', 'off', 'Fontsize', 12)
        xlabel('\alpha')
        ylabel('density')
        title(['\alpha = ', num2str(avec(i)), ', T = ', num2str(Tvec(j))])
    end
    
end




