clear; clc;
rng(123456);
% ========================== PC2: Exe2 ===============================
% ====================================================================
%% Import data
data      = ...;  % function: readmatrix
GDPgr     = ...;               % GDP growth (PCGDP1)
Tax       = ...;         % Tax shock (EXOGENRRATIO) 
time      = ...; 
%% Task 1a)i)
% Estimate the model: GDPgr= a + sum^{M=12}_{i=0} b_i Tax_{t-i} + u_t;
% In the matrix form
%                     Y_t = X_t B + u_t
% where: 
%          Y_t = GDPgr
%          X_t = [1 X_t X_{t-1} .. X_{t-M}]
%          B = [a b_i]'
% ------------------------------ Set up -----------------------------
M        = ...;                                   % number of lags
Xlags    = ...;                  % create lag matrix: lagmatrix
X        = ...;                       % sufficient observations
Y        = ...;                         % sufficient observations of Y
time     = ...;  
hor      = ...;
K        = ...;                          % number of coefficients
T        = ...;
% --------------------------- Estimation --------------------------------
mdlest = ...;                 % estimate model using fitlm
disp(mdlest)                         % display regression output
% ===== cumulated effects
Bhat = mdlest.Coefficients.Estimate; % obtain the coefficients
res  = mdlest.Residuals.Raw;
VarBhat = mdlest.CoefficientCovariance;
beta=Bhat(2:end);                 % beta=[b0 b1 ...b12]'                                 
resp=cumsum(beta);                % cumulated effects
% use a simulation technique to calculate the standard error estimation for 
% impulse responses (cumulative effects)
% ======================== Simulation =====================
ndraws=10000;
P = chol(VarBhat,'lower');  % Cholesky decomposition.
resp_bstr=zeros(ndraws,M+1);
% start boostrappingg
for j=1:ndraws
    coeff_bstr=Bhat+P*mvnrnd(0,1,K); % draw beta from the normal distribution
    b_bstr=coeff_bstr(2:end);         % estimated coefficients of tax shocks
    bsum=cumsum(b_bstr);              % the cumulated effects 
    resp_bstr(j,:)=bsum';            
end
%=========================== End of Simulation================
% extract the mean and estimated standard error of cumulated effect
resp_mean = mean(resp_bstr,1)';         % mean 
resp_std = std(resp_bstr,1)';           % std
% t-value
gam_tval = resp./resp_std;
% lower and upper bound of 68% CI
resp_lb=resp+tinv(0.16,T-M)*resp_std; % lower bound 
resp_ub=resp+tinv(0.84,T-M)*resp_std;   % upper bound 
% plot
figure
plot(hor,resp,'-b','LineWidth',1); hold on;
plot(hor,resp_lb,'-k'); hold on;
plot(hor,resp_ub,'-k'); hold on;
plot(hor,zeros(M+1,1),':k');
xlim([0 M])
xlabel('horizon');
ylabel('responses');
legend('responses of the GDP','68% CI');
title('Responses of the GDP to the fiscal shock');

%% Task 1a)ii):  Autocorrelation
% ===== plot autocorrelogram: autocorr
figure
subplot(2,1,1)
plot(time,res,'-r');
title('residuals in the regression');
subplot(2,1,2)
autocorr(res, NumLags = 12);
ylim([-0.5 1]);
title('autocorrelogram for the residuals');


%% Task 1a)iii): Newey West standard error
% ===== Newey-West covariance matrix estimation
% hac
covNW = ...;
% covNW2 = hac(X,Y,'Type','hac','Bandwidth',5,'SmallT',false);
% =========================== Simulation ==================================
ndraws=10000; 
P=chol(covNW,'lower');  % Cholesky decomposition.
resp_bstr=zeros(ndraws,M+1);
% start Simulation
for j=1:ndraws
    ABhat_bstr=Bhat+P*mvnrnd(0,1,K); % draw beta from the normal distribution
    b_bstr=ABhat_bstr(2:end);         % estimated coefficients of tax shocks
    bsum=cumsum(b_bstr);              % the cumulated effects 
    resp_bstr(j,:)=bsum';            
end
% ===== Mean and Estimated standard error for the responses
IRFmean_bstr = mean(resp_bstr,1)';
respseNW     = std(resp_bstr,1)';

% ======================== End Simulation =============================
% ===== Newey-West t-value
gam_NWtval=resp./respseNW;
% construct table 
results3=array2table([hor', resp, gam_tval, gam_NWtval],"VariableNames",...
    ["horizon","responses","conventional t-value","Newey-West t-value"]);
disp(results3)


%% Task 1b)i) Autocorrelation test for the residuals
%  -------------------- Estimation -------------------------
% Model 2:
%      GDPgr=a+\sum^M_{i=0} b_i Tax_{t-i} + \sum^N_{j=1} c_j GDPgr_{t-j} + u_t
% In matrix form
%                         Y = X B + u
% X=[1 Xlags Ylags]; 
% where: 
% Xlags = [Tax_t Tax_{t-1} Tax_{t-2} ... Tax_{t-M}], with M=12;
% Ylags = [GDPgr_{t-1} GDPgr_{t-2} ... GDPgr_{t-N}], with N=11;

% ===== Construct the Xlags and Ylags: use the function lagmatrix
M = ...;                        % lags number of Tax shock
N = ...;                        % lags number of GDP growth

Xlmat = ...;    % lag matrix of tax shock
Ylmat = ...;  % lag matrix of GDP growth

% ===== construct X matrix in model 2.
Xlags = ...;      % Xlags
Ylags = ...;
XM2    =...;
% ===== use function fitlm to estimate model 2 
ADLmdl = ...;
disp(ADLmdl)
% store estimated values
BhatM2     = ADLmdl.Coefficients.Estimate;    % estimators
resM2      = ADLmdl.Residuals.Raw;             % residuals
covBhatM2  = ADLmdl.CoefficientCovariance; % estimated variance of estimators

% -------------------- Residual diagnostic -----------------
% ===== autocorrelogram 
% plot residual and its autocorrelogram
figure
subplot(2,1,1)
plot(time,resM2,'-r','LineWidth',0.7);
title('residuals');
subplot(2,1,2)
autocorr(resM2,Numlags = 14);
ylim([-0.5 1])
title('autocorrelation for the residuals in the model 2');


%% Task 1b)ii) Calculate the impulse responses
% --------------------- Impulse responses ----------------
% B = [a,b0,b1,b2,..b12,c1,c2,..., c11]';
bhat_M2    = BhatM2(2:M+2);        % b=[b0,b1,..,b12]'
chat_M2    = [BhatM2(M+3:end);0];  % c=[c1,c2,..,c11,c12]' where c12=0;

del_i      = zeros(M+1,1);         % responses of GDP growth at horizon i
del_i(1,1) = bhat_M2(1,1);         % delta_0 = b_0;
Del        = bhat_M2(1,1);
for i=1:12
    del_i(i+1,1)=bhat_M2(i+1)+chat_M2(1:i)'*Del;
    Del=[del_i(i+1); Del];
end

respM2=cumsum(del_i); % responses of the real GDP

% ------------------- Simulation -----------------------------------
% Using simulation technique to calculate the estimated variance of the responses.
ndraws=100000;
P=chol(covBhatM2,'lower');
gamM2_bstr=zeros(ndraws,M+1);
gamM2_2bstr=zeros(ndraws,M+1);
for j=1:ndraws
    Bhat_bstr=BhatM2+P*mvnrnd(0,1,M+N+2); % draw beta from the normal distribution
    bhat=Bhat_bstr(2:M+2);
    ahat=[Bhat_bstr(M+3:end); 0];
    Del=bhat(1);
    del_i=zeros(M+1,1);
    del_i(1)=Del(1);
    for i=1:12
        del_i(i+1,1)=bhat(i+1)+ahat(1:i)'*Del;
        Del=[del_i(i+1); Del];
    end
    bsum=cumsum(del_i);
    gamM2_bstr(j,:)=bsum'; 
end
IRFmean_M2= mean(gamM2_bstr,1)';
IRFse_M2 = std(gamM2_bstr,1)';

% 68\% confidence interval (1 standard deviation)
respM2_lb=respM2+tinv(0.16,T).*IRFse_M2;
respM2_ub=respM2+tinv(0.84,T)*IRFse_M2;

%------------------- END SIMUALTION ------------------------------
% Replicate figure 5
figure
% plot the IRF from the model 1, without control the lagged GDP growth
plot(hor,resp,'-k','LineWidth',1.5); hold on;
% plot the IRF from the model 2, with control
plot(hor,respM2,'--k','LineWidth',1.5);hold on;
% plot the upper and lower bounds
plot(hor,resp_lb,'-k','LineWidth',0.5); hold on;
plot(hor,resp_ub,'-k','LineWidth',0.5); hold on;
plot(hor,respM2_lb,'--k','LineWidth',0.5);hold on;
plot(hor,respM2_ub,'--k','LineWidth',0.5);hold on;
legend('without control','with control');
xlabel('horizon');
ylabel('responses');
title('the responses of the real GDP in the model 1 and model 2');


%% Task 1b)iii) Information criteria (IC)
% ADL model:
% Y_t=a+b0 X_t+b1 X_{t-1}+...+bp X_{t-p}+c1 Y_{t-1}+...+cq Y_{t-q}+u_t
lagmax    = 10;           % maximum lag number in the model (p=q)
Ynew      = GDPgr(2:end); % because of missing values of the first obs
Xnew      = Tax(2:end);
AIC       = zeros(lagmax,1); % initialize target objects
BIC       = zeros(lagmax,1);
HQ        = zeros(lagmax,1);
for p=1:lagmax
    % re-estimate model for each case of p
    Ylags        = lagmatrix(Ynew,1:p); % lagmatrix for GDP growth
    Xlags        = lagmatrix(Xnew,0:p); % lagmatrix for exogenous tax changes
    Ytemp        = Ynew(p+1:end);         % dependent variable Y
    Xtemp        = [Xlags(p+1:end,:),Ylags(p+1:end,:)]; % X=[Xlags Ylags]
    [nobs,npara] = size(Xtemp); % number of observations and number of parameters
    mdl_p        = fitlm(Xtemp,Ytemp); % function: fitlm to estimate the model 
    logL         = mdl_p.LogLikelihood;% store value of loglikelihood
    [aic,bic,ic] = aicbic(logL,npara,nobs); % function: aicbic for calculate information criteria
    % save the results
    AIC(p)  = aic;
    BIC(p)  = bic;
    HQ(p)   = ic.hqc;   
end
[~,AIClags]    = min(AIC);
[~,BIClags]    = min(BIC);
[~,HQlags]     = min(HQ);

% display
ICtable = array2table([(1:lagmax)',AIC,BIC,HQ],"VariableNames",["lags","AIC","BIC","HQ"]);
disp(ICtable)
disp(['AIC selects the lag number = ', num2str(AIClags)])
disp(['BIC selects the lag number = ', num2str(BIClags)])
disp(['HQ selects the lag number = ', num2str(HQlags)])