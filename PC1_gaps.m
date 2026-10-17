clear; clc;
%% Task 1a)
% ===== import data: readmatrix
Y           = ...;     % load dataset from excel file.
[T, N]      = ...;      % dimensions of Y
varnames    = {'Industrial production';'Unemployment rate';'Money supply';'Stock prices (% change)'};
unit        = {'index';'rate';'index';'rate'};

% manually construct a sequence of time: datetime
time        = ...;


% multiple graphs in one figure: subplot
figure
for i=1:N
subplot(2,2,i)
plot(time,Y(:,i),'color','b','LineWidth',0.8);
recessionplot; % US business cycle
xlabel('monthly');
ylabel([' ' unit{i}])
title([' ' varnames{i}])
end

%% Task 1b)
% ===== Data transformation:  diff, log, for, if.
tcode       = [3;2;3;1];    % 3: first diff of log, 2: first diff, 1: no transform
Yn          = zeros(T-1,N);          % store data
for i=1:N
    if tcode(i)==3
        Yn(:,i)     = ...;         % log(Y_{t}) - log(Y_{t-1})
    elseif tcode(i)==2
        Yn(:,i)     = ...;         % Y_{t} - Y_{t-1}   
    else
        Yn(:,i)     = ...;        
    end
end
time2 = time(2:end);

% ts before 2019 Dec
tind = find(time2 <= datetime(2019,12,1), 1, 'last');

figure
for i=1:N
subplot(2,2,i)
plot(time2(1:tind),Yn(1:tind,i),'color','b','LineWidth',0.8);
recessionplot; % US business cycle, requires Econometric Toolbox
xlabel('monthly');
ylabel([' ' unit{i}])
title([' ' varnames{i}])
end
sgtitle('Time series before pandemic')

%%  Task 2a)
clear
clc


Y               = ...;              % import dataset
PCGDP           = ...;              % real GDP
PCGDPl          = ...;              % first diff of log GDP
EXOGENRRATIO    = ...;              % exogenous tax changes
time            = ...;   % manually construct a sequence of date (quarterly)

% plot
figure
colororder({'k','k'});
yyaxis left
plot(time,PCGDPl,'-r','LineWidth',0.7); hold on;
yyaxis right
plot(time,log(PCGDP),'-b','LineWidth',0.7);
legend('GDP growth rate','GDP');

%% Task 2b)
% ====== sample autocorrelation function: autocorr
...

% ====== plot the autocorrelogram for the fiscal shock and GDP growth rate 
figure
subplot(2,1,1)
autocorr(EXOGENRRATIO, Numlags = 12);
ylim([-0.5 1]);
title('ACF for the fiscal shock');
subplot(2,1,2)
autocorr(PCGDPl, NumLags = 12)
ylim([-0.5 1])
title('ACF for the GDP growth rate')

