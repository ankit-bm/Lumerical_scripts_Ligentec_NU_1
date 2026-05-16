clc
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants & Directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 3E8;
cd("D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_QuantumComb")
basic_D2 = load('Dint_100um_BasicRing.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load & Clean Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_Amax = readmatrix("Data_RingMOD_Squeez_Amax11.00nm_M606-666_Nm61_LambdaRange1480-1640nm_G600nm_Decay1e-08.txt", 'NumHeaderLines', 21);
data_Amax = data_Amax(~isnan(data_Amax(:,1)), :);

LambdaData = data_Amax(:,1);
FreqsData  = data_Amax(:,2);
Tx         = data_Amax(:,3);

% peaks finding
InvT    = smooth(1-Tx,20);
[peaks, locations] = findpeaks(InvT, 'MinPeakProminence', 1E-9, 'MinPeakDistance', 2,'MinPeakHeight',0.5);     
Freqs = FreqsData(locations);

% check
% figure(1); 
% clf; 
% hold on
% plot(LambdaData * 1e3, InvT)
% plot(LambdaData(locations) * 1e3, InvT(locations), 'ro')
% xlabel('Wavelength (nm)'); ylabel('InvT')
% title('InvT vs Wavelength')
% 
% figure(2); 
% clf; 
% hold on
% plot(FreqsData * 1e-12, InvT)
% plot(Freqs * 1e-12, InvT(locations), 'ro')
% xlabel('Frequency (THz)'); ylabel('InvT')
% title('InvT vs Frequency')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean peaks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Filter frequency range
f_min = 184.5;  % THz
f_max = 202.3;   % THz

% Filter raw data
cleaned_indices    = FreqsData >= f_min & FreqsData <= f_max;
FreqsData_cleaned  = FreqsData(cleaned_indices);
InvT_cleaned       = InvT(cleaned_indices);

% Filter peaks
idx_peaks = Freqs >= f_min & Freqs <= f_max;
FreqsVec  = Freqs(idx_peaks);
locations_cleaned = locations(idx_peaks);

figure(3); 
clf; 
hold on
plot(FreqsData_cleaned, InvT_cleaned,LineWidth=1.0)
plot(FreqsVec, InvT(locations_cleaned), 'ro')
xlabel('Frequency (THz)'); ylabel('InvT')
title('InvT vs Frequency, cleaned data')
hold off
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

length(FreqsVec)
NMode         = 61;
ModeNumVecTmp = 1:length(FreqsVec);
Mu0           = 31;
ModeNumVec    = ModeNumVecTmp - Mu0;
Freq0         = 193.452 % manually choosing
Freqs_Norm    = (FreqsVec-Freq0)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gaps = diff(sort(Freqs_Norm));
FSR  = median(gaps(gaps > 0.5*max(gaps)))
Mu   = round((Freqs_Norm)/FSR);

[UniqueVec,~,group_val] = unique(Mu);

S_Freqs  = zeros(size(UniqueVec));
AS_Freqs = zeros(size(UniqueVec));

for j = 1:length(UniqueVec)
    i = find(group_val == j);
    f = FreqsVec(i);      

    if numel(i) == 2
        f = sort(f);
        AS_Freqs(j) = f(1);
        S_Freqs(j)  = f(2);
    else
        AS_Freqs(j) = f;
        S_Freqs(j)  = f;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot S and AS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4); 
clf;
hold on
plot(UniqueVec, S_Freqs, 'ob','DisplayName','Symmetric')
plot(UniqueVec, AS_Freqs, 'or','DisplayName','Anti-Symmetric')
xlabel('\mu');  
ylabel('Frequency (THz)')
legend; 
hold off
grid on

figure(5)
clf
plot(UniqueVec, (S_Freqs - AS_Freqs)*1e3, 'o-r', ...
    'DisplayName', 'Splitting (GHz)', ...
    'MarkerFaceColor', 'r')
xlabel('\mu')
ylabel('Splitting (GHz)')
grid on
legend

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fitiing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Linear Fitting
p1 = polyfit(UniqueVec, S_Freqs, 2);   % Symmetric
p2 = polyfit(UniqueVec, AS_Freqs, 2);  % Anti-symmetric

FSR_S  = p1(2);
FSR_AS = p2(2);

FSR_Avg = (FSR_AS+FSR_S)/2;

%% Dint calculation (Hz → GHz)
Dint_S  = S_Freqs  - (Freq0 + FSR_Avg*UniqueVec);
Dint_AS = AS_Freqs - (Freq0 + FSR_Avg*UniqueVec);

Dint_S_GHz  = Dint_S*1e3;
Dint_AS_GHz = Dint_AS*1e3;

figure(6); 
hold on; 
grid on
plot(UniqueVec, Dint_S_GHz,'ob','DisplayName','Symmetric')
plot(UniqueVec, Dint_AS_GHz,'or','DisplayName','Anti-Symmetric')
xlabel('\mu'); ylabel('D_{int} (GHz)');
legend; 
hold off

%% Quadratic Fitting to Dint
pDint_S  = polyfit(UniqueVec, Dint_S, 2);
pDint_AS = polyfit(UniqueVec, Dint_AS, 2);

D2_S  = 2*pDint_S(1);
D2_AS = 2*pDint_AS(1);

mu_fine = linspace(min(UniqueVec), max(UniqueVec), 50);

Dint_S_fit  = polyval(pDint_S, mu_fine);
Dint_AS_fit = polyval(pDint_AS, mu_fine);

%% Plot with Fit
figure(7)
clf
hold on
grid on
plot(UniqueVec, Dint_S_GHz, 'ob', 'DisplayName', 'S (data)')
plot(UniqueVec, Dint_AS_GHz, 'or', 'DisplayName', 'AS (data)')
plot(mu_fine, Dint_S_fit*1e3, '-b', 'LineWidth', 2, 'DisplayName', 'S (fit)')
plot(mu_fine, Dint_AS_fit*1e3, '-r', 'LineWidth', 2, 'DisplayName', 'AS (fit)')
% plot(basic_D2.ModeNumVec, basic_D2.Dint_GHz, 'o', 'Color', [0.6 0.6 0.6], 'DisplayName', 'Basic Ring')
% plot(basic_D2.mu_fine, basic_D2.Dint_fit*1e-9, '-', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.5, 'HandleVisibility', 'off')

xlabel('\mu')
ylabel('D_{int} (GHz)')
legend
title(sprintf('Max A = 11 nm, D2_S = %.2f MHz/mode^2, D2_{AS} = %.2f MHz/mode^2', D2_S*1e6, D2_AS*1e6))
%                                                                                  
hold off

fprintf('FSR_S=%.3f GHz, FSR_AS=%.3f GHz, FSR_Avg=%.3f GHz\n', ...
        FSR_S*1e3, FSR_AS*1e3, FSR_Avg*1e3);           % THz→GHz: *1e3

fprintf('f0 (μ=0) = %.2f THz\n', Freq0);                % already THz

fprintf('Dint_S(μ=0)=%.3f GHz, Dint_AS(μ=0)=%.3f GHz\n', ...
        (S_Freqs(Mu0)-(Freq0+FSR_Avg*0))*1e3, ...        % THz→GHz: *1e3
        (AS_Freqs(Mu0)-(Freq0+FSR_Avg*0))*1e3);