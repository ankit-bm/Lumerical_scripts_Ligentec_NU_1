clc
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 3E8;
cd("D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_Squeezing")

data_file         = "Data_RingMOD_BasicRing_pwsource_Amax0.00nm_M631-612_Nm16_LambdaRange1480-1640nm_Gap600nm_Tx.txt";
% data_W2000        = "Data_RingMOD_BasicRing_pwsource_W2000.0Amax0.00nm_M631-612_Nm16_LambdaRange1480-1640nm_Gap600nm_Tx.txt";
data = readmatrix(data_file, 'NumHeaderLines', 21);  % skip all comment/blank lines
data = data(~isnan(data(:,1)), :);    

% data_W2000 = readmatrix(data_W2000, 'NumHeaderLines', 21);  % skip all comment/blank lines
% data_W2000 = data_W2000(~isnan(data(:,1)), :);    

lambda_data  = (data(:,1));
T_data       = (data(:,2));
% T_data       = flipud(data(:,2));
FreqsData    = c./(lambda_data*1E-6);

%%
InvT = smooth(1-T_data,10);

[peaks, locations] = findpeaks(InvT, 'MinPeakProminence', 0.2, 'MinPeakDistance', 50);     
Freqs = FreqsData(locations);

figure(1)
clf
plot(lambda_data*1E3, 10.*log10(InvT))
hold on
plot(lambda_data(locations)*1E3, 10.*log10(InvT(locations)), 'ro')
xlabel('Wavelength (nm)')
ylabel('1 - Transmission(dB)')

figure(2)
clf
plot(FreqsData*1E-12, 10.*log10(InvT))
hold on
plot(Freqs*1E-12, 10.*log10(InvT(locations)), 'ro')
xlabel('Frequency(THz)')
ylabel('1 - Transmission(dB)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NMode         = length(locations);
ModeNumVecTmp = 1:length(locations);
Mu0           = 33;
ModeNumVec    = ModeNumVecTmp - Mu0;
Freq0         = Freqs(Mu0);
Freqs_Norm    = (Freqs-Freq0)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)
clf
plot(ModeNumVec, Freqs_Norm*1E-12, 'o')
xlabel('\mu')
ylabel('\nu - \nu_0 (THz)')
grid on

figure(4)
clf
plot(ModeNumVec(2:end), diff(Freqs_Norm) * 1e-12, 'o')
xlabel('\mu')
ylabel('\DeltaFSR (THz)')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p1   = polyfit(ModeNumVec, Freqs_Norm, 2);   
FSR  = p1(2);
FSR_GHz = FSR*1E-9

Dint     = Freqs_Norm  - (FSR*ModeNumVec);
Dint_GHz = Dint*1e-9;

% Quadratic Fitting to Dint
pDint  = polyfit(ModeNumVec, Dint, 2);
D2_S   = 2*pDint(1)

mu_fine = linspace(-40, 40, 100);
Dint_fit  = polyval(pDint, mu_fine);

figure(5)
clf
hold on
plot(ModeNumVec, Dint_GHz, 'ob')
plot(mu_fine, Dint_fit*1e-9, '-b', 'LineWidth', 1.5)
xlabel('\mu')
ylabel('D_{int} (GHz)')
title('Unmodulated Basic Ring D_{int} Curve')
grid on
hold off

save_dir = "D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_QuantumComb";
save(fullfile(save_dir, 'Dint_100um_BasicRing.mat'), 'ModeNumVec', 'Dint_GHz', 'mu_fine', 'Dint_fit');

fprintf('FreqsData: min=%.2f max=%.2f THz\n', min(FreqsData*1E-12), max(FreqsData*1E-12));
fprintf('FreqsData sorted ascending? %d\n', issorted(FreqsData*1E-12));
fprintf('FreqsData sorted descending? %d\n', issorted(FreqsData*1E-12,'descend'));
fprintf('Freqs (peaks) sorted ascending? %d\n', issorted(Freqs*1E-12));
fprintf('diff(Freqs) all positive? %d\n', all(diff(Freqs*1E-12)>0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% W2000 Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_W2000 = "Data_RingMOD_BasicRing_pwsource_W2000.0Amax0.00nm_M631-612_Nm16_LambdaRange1480-1640nm_Gap600nm_Tx.txt";
data_W2000 = readmatrix(file_W2000, 'NumHeaderLines', 21);
data_W2000 = data_W2000(~isnan(data_W2000(:,1)), :);

lambda_W2000  = data_W2000(:,1);
T_W2000       = data_W2000(:,2);
Freq_W2000    = c ./ (lambda_W2000 * 1e-6);

InvT_W2000 = smooth(1 - T_W2000, 10);
[~, loc_W2000] = findpeaks(InvT_W2000, 'MinPeakProminence', 0.2, 'MinPeakDistance', 50);
Freqs_W2000 = Freq_W2000(loc_W2000);

NMode_W2000    = length(loc_W2000);
Mu0_W2000      = round(NMode_W2000/2);
ModeNum_W2000  = (1:NMode_W2000) - Mu0_W2000;
Freq0_W2000    = Freqs_W2000(Mu0_W2000);
FN_W2000       = (Freqs_W2000 - Freq0_W2000)';

p_W2000    = polyfit(ModeNum_W2000, FN_W2000, 1);
FSR_W2000  = p_W2000(1);
Dint_W2000     = FN_W2000 - FSR_W2000 * ModeNum_W2000;
Dint_W2000_GHz = Dint_W2000 * 1e-9;

pD_W2000 = polyfit(ModeNum_W2000, Dint_W2000, 2);
D2_W2000 = 2 * pD_W2000(1)

figure(6)
clf; hold on; grid on
plot(ModeNumVec, Dint_GHz, 'o-b', 'DisplayName', 'W=1500nm')
plot(ModeNum_W2000, Dint_W2000_GHz, 's-r', 'DisplayName', 'W=2000nm')
xlabel('\mu'); ylabel('D_{int} (GHz)')
title('D_{int}: W=1500 vs W=2000')
legend; hold off