% =========================================================================
% ======================   PC4: Cointegration =============================
% ========================================================================
%% Task 1
clear; clc;
% ===== import data from BPdata.xlsx
data  = ...;
tfp   = ...;     % total factor productivity
sp    = ...;     % stock prices
dates = ...;     % sequence of datetime

%% Task 1a)
figure
set(gcf,'Position',[100 100 800 400]);
colororder({'k','k'});
yyaxis left
h1=plot(dates,tfp,'-b','LineWidth',1.5);
recessionplot
ylabel('log of total factor productivity')
yyaxis right
h2=plot(dates,sp,'-r','LineWidth',1.5);
recessionplot
ylabel('log of capita stock index')
legend([h1 h2],{'total factor productivity','stock prices'});

%% Task 1b)
%ADF test for TFP

lags = ...;

[~,pvalAR]  = ...;     % test WITHOUT intercept and trend
[~,pvalARD] = ...;     % test WITH intercept
[~,pvalTS]  = ...;     % test WITH intercept and trend

ADF_tfp = table((1:lags)',pvalAR',pvalARD',pvalTS', ...
    'VariableNames',{'Lags','AR','ARD','TS'});

disp('ADF test: TFP')
disp(ADF_tfp)


%ADF test for Stock Prices

[~,pvalAR]  = ...;      % test WITHOUT intercept and trend
[~,pvalARD] = ...;      % test WITH intercept
[~,pvalTS]  = ...;      % test WITH intercept and trend

ADF_sp = table((1:lags)',pvalAR',pvalARD',pvalTS', ...
    'VariableNames',{'Lags','AR','ARD','TS'});

disp('ADF test: Stock Prices')
disp(ADF_sp)

%% Task 1c)
lags=8;
Y=[tfp sp];
[~,pegci_nc]= ...;      % WITHOUT constant and trend
[~,pegci_c]= ...;       % WITH constant and NO trend
[~,pegci_ct]= ...;      % WITH constant and trend
[~,pegci_ctt]= ...;     % WITH constant, trend and quadratic trend
                                                    
% display results
ENGRresults = table((1:lags)',pegci_nc',pegci_c',pegci_ct',pegci_ctt','VariableNames',...
    ["Lags","no constant, no trend","const, no trend","const, trend","const, trend, quadratic trend"]);
disp('Engel-Granger cointegration test')
disp(ENGRresults)




%% Task 2)
clear; clc;
% ===== import data from Carstensen.xlsx
data = ...;

LM3real = ...;
LGDPreal = ...;
LT = ...;

dates = ...;

%%  Task 2a)
figure
set(gcf,'Position',[100 100 800 400]);
colororder({'k','k'});
yyaxis left
plot(dates,LM3real,'-b','LineWidth',1.5); hold on;
plot(dates, LGDPreal,'-r','LineWidth',1.5); hold on;
ylabel('log of M3 (real GDP)')
yyaxis right
plot(dates,LT,'-k','LineWidth',1.5); hold on;
ylabel('long-term rate')
legend('real M3','real GDP','long-term rate');
  
%% Task 2b)
%LM3real

lags = ...;

[~,pvalAR]  = ...;
[~,pvalARD] = ...;
[~,pvalTS]  = ...;

ADF_LM3 = table((1:lags)',pvalAR',pvalARD',pvalTS', ...
    'VariableNames',{'Lags','AR','ARD','TS'});

disp('ADF test: LM3real')
disp(ADF_LM3)


%LGDPreal

[~,pvalAR]  = ...;
[~,pvalARD] = ...;
[~,pvalTS]  = ...;

ADF_GDP = table((1:lags)',pvalAR',pvalARD',pvalTS', ...
    'VariableNames',{'Lags','AR','ARD','TS'});

disp('ADF test: LGDPreal')
disp(ADF_GDP)


%LT

[~,pvalAR]  = ...;
[~,pvalARD] = ...;
[~,pvalTS]  = ...;

ADF_LT = table((1:lags)',pvalAR',pvalARD',pvalTS', ...
    'VariableNames',{'Lags','AR','ARD','TS'});

disp('ADF test: LT')
disp(ADF_LT)

%% Task2c)
lags=8;
Y=[LM3real LGDPreal LT];
[~,pegci_nc]= ...;       % WITHOUT constant and trend
[~,pegci_c]= ...;        % WITH constant and NO trend
[~,pegci_ct]= ...;       % WITH constant and trend
[~,pegci_ctt]= ...;      % WITH constant, trend...
                                                        % and quadratic trend
EGresults = table((1:lags)',pegci_nc',pegci_c',pegci_ct',pegci_ctt',...
    'VariableNames',["Lags","no constant and trend","constant,no trend","constant and trend","constant,trend and quadratic"])


% Alternative: run the regression and analyze the residuals

X = ...;

b = ...;

u = ...;

plot(u)
yline(0)

[h,p,stat,cValue] = ...