% =========================== PC Tutorial 03 ==============================
clear, clc
%% Task 1a)
% ===== Load the dataset:
data = ...;
% ===== Construct a sequence of dates
dates = ...;
% ===== Define variables
E_UK = ...;                    % Define the UK/US nominal exchange rate
E_CH = ...;                    % Define the CH/US nominal exchange rate
% ===== Plot nominal exchange rate
figure
subplot(2,1,1)
plot(dates,E_UK,'-b','LineWidth',1.5);
title('Nominal exchange rate of Pound Sterling to US dollar');
subplot(2,1,2)
plot(dates,E_CH,'-b','LineWidth',1.5);
title('Nominal exchange rate of Chinese Yuan to US dollar');

%% Task 1b)

lags = ...;

% ===== UK nominal exchange rate
var_UK = ...;

[h_UK_AR,pVal_UK_AR]   = ...;
[h_UK_ARD,pVal_UK_ARD] = ...;
[h_UK_TS,pVal_UK_TS]   = ...;

% ===== China nominal exchange rate
var_CH = log(E_CH);

[h_CH_AR,pVal_CH_AR]   = ...;
[h_CH_ARD,pVal_CH_ARD] = ...;
[h_CH_TS,pVal_CH_TS]   = ...;

% ===== Display results:
results_UK = table((1:lags)', ...
                   pVal_UK_AR(:), ...
                   pVal_UK_ARD(:), ...
                   pVal_UK_TS(:), ...
                   'VariableNames', ...
                   ["Lags","pval_AR","pval_ARD","pval_TS"]);

disp('Augmented Dickey-Fuller Tests for UK exchange rate (p-values)')
disp(results_UK)

results_CH = table((1:lags)', ...
                   pVal_CH_AR(:), ...
                   pVal_CH_ARD(:), ...
                   pVal_CH_TS(:), ...
                   'VariableNames', ...
                   ["Lags","pval_AR","pval_ARD","pval_TS"]);

disp('Augmented Dickey-Fuller Tests for Chinese exchange rate (p-values)')
disp(results_CH)


% ----------------------------------------------------------------------
%% Part (c)

% ===== Define the CPI variables
CPI_US = ...;
CPI_UK = ...;
CPI_CH = ...;

% ===== Define the Real exchange rates
RER_UK = ...;
RER_CH = ...;


% ===== Plot real exchange rates
figure

subplot(2,1,1)
plot(dates, RER_UK, 'LineWidth', 1.5);
title('Real effective exchange rate UK/US')

subplot(2,1,2)
plot(dates, RER_CH, 'LineWidth', 1.5);
title('Real effective exchange rate CH/US')


