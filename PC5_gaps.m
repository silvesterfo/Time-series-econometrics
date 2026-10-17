% -------------------------------------------------------------------------
% ===================| PC5: Vector Autoregressive Model |==================
% -------------------------------------------------------------------------

%% ===| Clear data memory and Matlab environment:
clear; clc;

%% part 1) Load the data set from Auerbach & Gorodnichenko (2012) and produce graph:
% ===== Load data
...
% G = Log real government spending, Billions of US dollars (chained 2005) and seasonally adjusted
% T = Log net real taxes on the economy, Billions of US dollars (chained 2005) and seasonally adjusted 
% Y = Log real GDP, Billions of US dollars (chained 2005) and seasonally adjusted

% ===== plot figure
figure
plot(dates,G,'-k','LineWidth',1.5); hold on;
plot(dates,T,'-r','LineWidth',1.5); hold on;
plot(dates,Y,'-b','LineWidth',1.5); 
recessionplot; % US' business cycle
xlabel('dates(quarter)');
ylabel('log value');
legend('government spending','tax','GDP');


%% part 2) Estimate VAR(4): varm and estimate
% ===== Endogenous variables for the VAR:
X  = ...; % variables are ordered in VAR: 1. Government spending
              %                               2. Tax
              %                               3. GDP
% ===== Set VAR parameters:
[n,K]= ...;             % Number of observations and number of vars in VAR
p    = ...;             % Lags of the VAR model

% ===== Fit linear VAR: function varm and estimate
Mdl             = ...;              % Specify VAR structure
disp(Mdl)

Mdl.SeriesNames = ...;
[EstMdl,~,~,E]  = ...;      % Estimate the VAR and store the residuals E

results         = ...   % Store summary of results
AIC = results.AIC;
Lil = results.LogLikelihood;
%% Part 3) Granger-causality test: function gctest
[~,sum] = ...;

%% Part 4) Impulse response function to unit shock: 
% ===== Compute IRFs with 90% bootstrap confidence intervals:
nhor     = ...;                            % Number of horizon
nsimul   = ...;                          % Number of bootstrap simulations
tic
[IRF,Lower,Upper] = irf(EstMdl,'NumObs',nhor,...
    'E',E,'NumPaths',nsimul,'Confidence',0.9); % impulse response function, function irf
toc
% X=(g,t,y); e_t=(eg,et,ey);
% IRF has 3 dimension, nrows=nhor, ncolumn=nshock, npage=nvars
% IRF has 21 rows, 3 columns and 3 page
% IRF_{h,s,j}: responses of variable j to the shock s at the  (h-1)th
% quarter following the shock
% IRF_{1,1,3}: responses of ouput (y) to the government spending shock at
% horizon h=0.
% IRF_{5,1,3}: responses of the gdp (y) to the spending shock at the
% horizon 5, 4 quarters following the spending shock. 
% IRF(:,1,:): responses to the spending shock because the spending shock
% is the first shock. 
% IRF(:,2,:): responses of all variable to the second structual shock (tax
% shock)
% IRF(:,3,:): responses of all variable to the structural output shock
shockname  ='G';
shock      = 1;                            % Select shock variables: G=1, T=2, Y=3
IRF_2G   = 100*squeeze(IRF(:,shock,:));    % Correct unit of measurement: percent
Lower_2G = 100*squeeze(Lower(:,shock,:)); 
Upper_2G = 100*squeeze(Upper(:,shock,:)); 
% IRF_2G{h,1}: the responses of government spending at horizon h-1 to spending shock
% IRF_2G{h,2}: the responses of taxes at horizon h-1 to spending shock
% IRF_2G{h,3}: the responses of taxes at horizon h-1 to spending shock

% ===== Plot IRFs:
tm = (1:nhor)';       % Set time sequence
figure
set(gcf,'Position',[200 50 600 600])
for i= 1:K 
        subplot(K,1,i)
        patch([tm; tm(end:-1:1); tm(1)], [Lower_2G(:,i); Upper_2G(end:-1:1,i); Lower_2G(1,i)],0.5*[1 1 1],'edgecolor','none','facealpha',0.2);
        hold on
        plot(IRF_2G(:,i),'Color','k','LineWidth',1.5);
        xlim([1 nhor])
        yline(0);
        grid on
        title(sprintf('%s shock \\rightarrow %s response',shockname,VARnames{i}));
end

% ===== display Cholesky
disp('Sigma: ')
disp(results.Covariance)
disp('Lower triangular Cholesky factor (*100):')
disp(chol(results.Covariance,'lower').*100)
%% Part 5) Adjust IRFs: shock to G such that G increases by 1 dollar
TGmean = mean(exp(T)./exp(G));  % Get average TG ratio
YGmean = mean(exp(Y)./exp(G));  % Get average YG ratio
% Rescale the responses such that spending shock cause 1 unit dollar increase
% in government spending shock
IRF_Gdollar(:,1) = IRF_2G(:,1)/IRF_2G(1,1); % government spending 
IRF_Gdollar(:,2) = IRF_2G(:,2)*TGmean/IRF_2G(1,1); % taxes
IRF_Gdollar(:,3) = IRF_2G(:,3)*YGmean/IRF_2G(1,1); % GDP
% Lower bound for 90% confidence interval 
Lower_Gdollar(:,1) = Lower_2G(:,1)/IRF_2G(1,1); % government spending
Lower_Gdollar(:,2) = Lower_2G(:,2)*TGmean/IRF_2G(1,1);% taxes
Lower_Gdollar(:,3) = Lower_2G(:,3)*YGmean/IRF_2G(1,1);% GDP
% Upper bound for 90% confidence interval
Upper_Gdollar(:,1) = Upper_2G(:,1)/IRF_2G(1,1); % government spending
Upper_Gdollar(:,2) = Upper_2G(:,2)*TGmean/IRF_2G(1,1); % taxes
Upper_Gdollar(:,3) = Upper_2G(:,3)*YGmean/IRF_2G(1,1); % GDP

% ===| Plot IRFs:
tm = (1:nhor)';       % Set time sequence
figure
set(gcf,'Position',[200 50 600 600])
for i= 1:K 
        subplot(K,1,i)
        patch([tm; tm(end:-1:1); tm(1)], [Lower_Gdollar(:,i); Upper_Gdollar(end:-1:1,i); Lower_Gdollar(1,i)],0.5*[1 1 1],'edgecolor','none','facealpha',0.2);
        hold on
        plot(IRF_Gdollar(:,i),'Color','k','LineWidth',1.5);
        xlim([1 nhor])
        yline(0);
        yl = ylim; ylim([floor(2*yl(1))/2,ceil(2*yl(2))/2]);
        yticks(round(yl(1)):0.5:round(yl(2)));
        grid on
        title(sprintf('G shock \\rightarrow %s response',VARnames{i}));
        if i==K, xlabel('Horizon (quarters)'), end
end

%% part 6
% ===== Estimate VAR with alternative variable ordering
X2                 = ...;                % variable order in VAR: GDP, Tax, Spending
VARnames2          = {'Y';'T';'G'};           % variable names
Mdl2             = ...;              % Specify VAR structure
Mdl2.SeriesNames = ...;               % Specify endogenous variable names in VAR model
[EstMdl2,~,~,E2] = ...;      % Estimate the VAR and store the residuals E

% ===== IRF and 90\% confidence intervals calculated by boostrap
[IRF2,Lower2,Upper2] = irf(EstMdl2,'E',E2,'NumObs',nhor,'NumPaths',nsimul,'Confidence',0.90); % Linear VAR
shock      = 3;                              % Government spending shock is the third variable in VAR model.  
IRF2_2G   = 100*squeeze(IRF2(:,shock,:));                     % Correct unit of measurement: percent
Lower2_2G = 100*squeeze(Lower2(:,shock,:)); 
Upper2_2G = 100*squeeze(Upper2(:,shock,:));

% ===== Plot IRF estimated from part 4 and part 6: responses to
% one-standard-deviation government spending shock
figure
set(gcf,'Position',[200 50 600 600])
for i= 1:K
     % ===== IRF from VAR model: [Y,T,G]
        subplot(K,1,i)
        patch([tm; tm(end:-1:1); tm(1)], [Lower2_2G(:,i); Upper2_2G(end:-1:1,i); Lower2_2G(1,i)],0.5*[1 1 1],'edgecolor','none','facealpha',0.2);
        hold on
        h2=plot(IRF2_2G(:,i),'Color','k','LineWidth',1.5); hold on;
        % Variables in VAR model, task 4 are ordered as [G,T,Y]
        if i==1 % responses of GDP
            h1=plot(IRF_2G(:,3),'Color','r','LineWidth',1.5); hold on;
        elseif i==2 % responses of Tax
            h1=plot(IRF_2G(:,2),'Color','r','LineWidth',1.5); hold on;
        elseif i==3 % responses of Government spending
            h1=plot(IRF_2G(:,1),'Color','r','LineWidth',1.5); hold on;
        end
        xlim([1 nhor])
        yline(0);
        legend([h1 h2],{'VAR=[G,T,Y]','VAR=[Y,T,G]'});
        grid on
        title(sprintf('G shock \\rightarrow %s response',VARnames2{i}));
end

PMdl1=chol(EstMdl.Covariance,'lower');
PMdl2=chol(EstMdl2.Covariance,'lower');

