clc
% clear all;
% close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c   = 3E8;
gap = 800;
radius = 60;
tag = sprintf('R%dG%d', radius,gap)

R.(tag)         = radius*1E-6;
L               = 2*pi*R.(tag);
ng.(tag)        = 1.8074;
neff.(tag)      = 1.5370;
kx_square.(tag) = 0.8201

cd('D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_Squeezing');
filename = sprintf('Data_Ring%dum_check_gap%d.00nm_Tx.txt',radius,gap);
Data.(tag)    = readmatrix(filename);
wavelength_um = Data.(tag)(:,1);
Tx_Th.(tag)   = Data.(tag)(:,2);

%% Find peaks

[peaks.(tag), locs.(tag)] = findpeaks(1-Tx_Th.(tag), 'MinPeakHeight', 0.5);
peakWavelengths.(tag)     = wavelength_um(locs.(tag));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

hold on
plot(wavelength_um, 1-Tx_Th.(tag), 'DisplayName', ['Radius | Gap ' tag]);
plot(peakWavelengths.(tag), peaks.(tag), 'ro', 'DisplayName', ['Peaks ' tag]');
% plot(wavlength_um_g600, 1-Tx_Th.(tag), 'DisplayName', ['Radius | Gap ' tag]);
% plot(peakWavelengths.(tag), peaks.(tag), 'ro', 'DisplayName', ['Peaks ' tag]');
hold off
xlabel('Wavelength (nm)');
ylabel('Absoption');
xlim([1.54,1.57]);
title(['Through port ' tag ' [W =1.5 um , H = 0.2 um]']);
legend show;
grid on;

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

    baseline = min(y(max(1,idx-50):min(end,idx+50)));
    half_max = baseline + 0.5 * (peak_val - baseline);
    
    % Find crossing points
    left = find(y(1:idx) <= half_max, 1, 'last');
    right = find(y(idx:end) <= half_max, 1, 'first') + idx - 1;
    
    FWHM_all(i) = wavelength_um(left) - wavelength_um(right);
end

FWHM_nm = FWHM_all * 1E3  % convert to nm
Avg_FWHM_nm = mean(FWHM_nm)
FWHM_Hz = FWHM_nm*1E-9*(c/(1550E-9)^2)
Avg_FWHM_Hz = Avg_FWHM_nm*1E-9*(c/(1550E-9)^2)

t = sqrt(1 - kx_square.(tag));
FWHM_Hz_calculated = (FSR_Hz_calculated)*(1-t)

% % Save
% % 
% % if isfile('ring_circular_FSR_FWHM_results.mat')
% %     load('ring_circular_FSR_FWHM_results.mat', 'results');
% % end
% % 
% % Save current data
% % results.(tag).FSR_nm             = FSR_nm;
% % results.(tag).FSR_Hz             = FSR_Hz;
% % results.(tag).FSR_Hz_calculated  = FSR_Hz_calculated;
% % results.(tag).FWHM_Hz            = Avg_FWHM_Hz;
% % results.(tag).FWHM_Hz_calculated = FWHM_Hz_calculated;
% % results.(tag).FWHM_nm            = Avg_FWHM_nm;
% % 
% % Save back
% % save('ring_circular_FSR_FWHM_results.mat', 'results');