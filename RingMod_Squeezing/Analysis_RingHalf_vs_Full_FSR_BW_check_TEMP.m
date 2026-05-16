clc
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c   = 3E8;
tag = sprintf('R%dG%d', 60, 100);

R.(tag)         = 60E-6;
L               = 2*pi*R.(tag);
ng.(tag)        = 1.8074;
neff.(tag)      = 1.5370;
kx_square.(tag) = 0.6178


cd('D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_Squeezing');

Data.(tag)= readmatrix('Data_Ring60um_check_gap100.00nm_Tx.txt');
Data_60um_gap200 = readmatrix("Data_Ring60um_check_gap200.00nm_Tx.txt");
Data_60um_gap300 = readmatrix("Data_Ring60um_check_gap300.00nm_Tx.txt");
Data_60um_gap600 = readmatrix("Data_Ring60um_check_gap600.00nm_Tx.txt");
Data_60um_gap800 = readmatrix("Data_Ring60um_check_gap800.00nm_Tx.txt");

Data_100um_gap100 = readmatrix('Data_Ring100um_check_gap100.00nm_Tx.txt');
Data_100um_gap200 = readmatrix("Data_Ring100um_check_gap200.00nm_Tx.txt");
Data_100um_gap300 = readmatrix("Data_Ring100um_check_gap300.00nm_Tx.txt");
Data_100um_gap600 = readmatrix("Data_Ring100um_check_gap600.00nm_Tx.txt");
Data_100um_gap800 = readmatrix("Data_Ring100um_check_gap800.00nm_Tx.txt");

% Extract relevant data for plotting
wavelength_um     = Data.(tag)(:, 1);
wavlength_um_g600 = Data_60um_gap600(:,1);
Tx_Th.(tag) = Data.(tag)(:,2);
Tx_Th_r60_g200 = Data_60um_gap200(:,2);
Tx_Th_r60_g300 = Data_60um_gap300(:,2);
Tx_Th_r60_g600 = Data_60um_gap600(:,2);
Tx_Th_r60_g800 = Data_60um_gap800(:,2);

Tx_Th_r100_g100 = Data_100um_gap100(:,2);
Tx_Th_r100_g200 = Data_100um_gap200(:,2);
Tx_Th_r100_g300 = Data_100um_gap300(:,2);
Tx_Th_r100_g600 = Data_100um_gap600(:,2);
Tx_Th_r100_g800 = Data_100um_gap800(:,2);

%% Find peaks

[peaks.(tag), locs.(tag)] = findpeaks(1-Tx_Th.(tag), 'MinPeakHeight', 0.5);
[peaks60_g200, locs60_g200] = findpeaks(1-Tx_Th_r60_g200, 'MinPeakHeight', 0.5);
[peaks60_g300, locs60_g300] = findpeaks(1-Tx_Th_r60_g300, 'MinPeakHeight', 0.5);
[peaks60_g600, locs60_g600] = findpeaks(1-Tx_Th_r60_g600, 'MinPeakHeight', 0.5);
[peaks60_g800, locs60_g800] = findpeaks(1-Tx_Th_r60_g800, 'MinPeakHeight', 0.5);
[peaks100_g100, locs100_g100] = findpeaks(1-Tx_Th_r100_g100, 'MinPeakHeight', 0.5);
[peaks100_g200, locs100_g200] = findpeaks(1-Tx_Th_r100_g200, 'MinPeakHeight', 0.5);
[peaks100_g300, locs100_g300] = findpeaks(1-Tx_Th_r100_g300, 'MinPeakHeight', 0.5);
[peaks100_g600, locs100_g600] = findpeaks(1-Tx_Th_r100_g600, 'MinPeakHeight', 0.5);
[peaks100_g800, locs100_g800] = findpeaks(1-Tx_Th_r100_g800, 'MinPeakHeight', 0.5);
% Store peak wavelengths and values for further analysis
peakWavelengths.(tag) = wavelength_um(locs.(tag));
peakWavelengths60_g200 = wavelength_um(locs60_g200);
peakWavelengths60_g300 = wavelength_um(locs60_g300);
peakWavelengths60_g600 = wavlength_um_g600(locs60_g600);
peakWavelengths60_g800 = wavelength_um(locs60_g800);
peakWavelengths100_g100 = wavelength_um(locs100_g100);
peakWavelengths100_g200 = wavelength_um(locs100_g200);
peakWavelengths100_g300 = wavelength_um(locs100_g300);
peakWavelengths100_g600 = wavelength_um(locs100_g600);
peakWavelengths100_g800 = wavelength_um(locs100_g800);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
clf
hold on
% plot(wavelength_um, 1-Tx_Th.(tag), 'DisplayName', ['Radius | Gap'+'tag']);
plot(wavelength_um, 1-Tx_Th.(tag), 'DisplayName', ['Radius | Gap ' tag]);
plot(peakWavelengths.(tag), peaks.(tag), 'ro', 'DisplayName', ['Peaks ' tag]');
% plot(wavlength_um, 1-Tx_Th_r60_g200, 'DisplayName', 'Radius 60um | Gap 200 nm');
% plot(peakWavelengths60_g200, 1 - peaks60_g200, 'ro', 'DisplayName', 'Peaks 60um | Gap 200 nm');
% plot(wavlength_um, 1-Tx_Th_r60_g300, 'DisplayName', 'Radius 60um | Gap 300 nm');
% plot(peakWavelengths60_g300, 1 - peaks60_g300, 'ro', 'DisplayName', 'Peaks 60um | Gap 300 nm');
% plot(wavlength_um_g600, 1-Tx_Th_r60_g600, 'DisplayName', 'Radius 60um | Gap 600 nm');
% plot(peakWavelengths60_g600, 1 - peaks60_g600, 'ro', 'DisplayName', 'Peaks 60um | Gap 600 nm');
% plot(wavlength_um, 1-Tx_Th_r60_g800, 'DisplayName', 'Radius 60um | Gap 800 nm');
% plot(peakWavelengths60_g800, 1 - peaks60_g800, 'ro', 'DisplayName', 'Peaks 60um | Gap 800 nm');
hold off
xlabel('Wavelength (nm)');
ylabel('Absoption');
xlim([1.54,1.57]);
title(['Through port ' tag ' [W =1.5 um , H = 0.2 um]']);
legend show;
grid on;
%%
% figure(2)
% clf
% hold on
% plot(wavlength_um, 1-Tx_Th_r100_g100, 'DisplayName', 'Radius 100um | Gap 100 nm');
% plot(wavlength_um, 1-Tx_Th_r100_g200, 'DisplayName', 'Radius 100um | Gap 200 nm');
% plot(wavlength_um, 1-Tx_Th_r100_g300, 'DisplayName', 'Radius 100um | Gap 300 nm');
% plot(wavlength_um, 1-Tx_Th_r100_g600, 'DisplayName', 'Radius 100um | Gap 600 nm');
% plot(wavlength_um, 1-Tx_Th_r100_g800, 'DisplayName', 'Radius 100um | Gap 800 nm');
% hold off
% xlabel('Wavelength (nm)');
% ylabel('Absoption');
% xlim([1.54,1.57]);
% title('Through port 100um Ring [W =1.5 um , H = 0.2 um]');
% legend show;
% grid on;

%% FSR
FSR_nm = abs(mean(diff(peakWavelengths.(tag))))*1E3
FSR_nm_calculated = ((1550E-9)^2/(neff.(tag)*L))*1E9
FSR_Hz = FSR_nm*1E-9*(c/(1550E-9)^2)
FSR_Hz_calculated = c/(ng.(tag)*L)

%% FWHM
% For each peak, find FWHM
y = 1 - Tx_Th.(tag);
FWHM_all = zeros(length(locs.(tag)), 1);

for i = 1:length(locs.(tag))
    idx = locs.(tag)(i);
    peak_val = y(idx);
    baseline = min(y);  % or estimate from local region
    half_max = baseline + 0.5 * (peak_val - baseline);
    
    % Find crossing points
    left = find(y(1:idx) <= half_max, 1, 'last');
    right = find(y(idx:end) <= half_max, 1, 'first') + idx - 1;
    
    FWHM_all(i) = wavelength_um(left) - wavelength_um(right);
end

FWHM_nm = FWHM_all * 1E3;  % convert to nm
Avg_FWHM_nm = mean(FWHM_nm)
Avg_FWHM_Hz = Avg_FWHM_nm*1E-9*(c/(1550E-9)^2)

t = sqrt(1 - kx_square.(tag));
FWHM_Hz_calculated = (FSR_Hz_calculated)*(1-t)

%% Save

if isfile('ring_circular_FSR_FWHM_results.mat')
    load('ring_circular_FSR_FWHM_results.mat', 'results');
end

% Save current data
results.(tag).FSR_nm             = FSR_nm;
results.(tag).FSR_Hz             = FSR_Hz;
results.(tag).FSR_Hz_calculated  = FSR_Hz_calculated;
results.(tag).FWHM_Hz            = Avg_FWHM_Hz;
results.(tag).FWHM_Hz_calculated = FWHM_Hz_calculated;
results.(tag).FWHM_nm            = Avg_FWHM_nm;

% Save back
save('ring_circular_FSR_FWHM_results.mat', 'results');