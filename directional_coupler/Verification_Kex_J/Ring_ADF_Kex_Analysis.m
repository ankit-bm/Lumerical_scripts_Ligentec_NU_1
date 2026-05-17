clc;
clear all;
close all;

c = 3E8;
ng = 2.06227;
Vg = c / ng;
Clx = 0;
Cly = 0;
R   = 25;
LengthRing = (2*Clx+ 2*Cly + 2*pi*R) * 1e-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataSimPath = "D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_RingRaceTrack";
DataFile    = "RaceTrackADF_R25um_W1200nm_WIO1e+03nm_G300nm_E0.txt";

DataRaw = importdata(fullfile(DataSimPath, DataFile), '\t');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wavelength = DataRaw.data(:,1);                        % nm
Frequency  = c ./ (Wavelength * 1e-9) * 1e-12;        % THz
TxTH       = DataRaw.data(:,2);
TxDR       = DataRaw.data(:,3);

figure(1)
clf;
plot(Frequency, 10*log10(TxDR), '-k', LineWidth=1.25)
xlabel('Frequency (THz)'); ylabel('Drop (dB)');
title('Drop Port'); grid on;

figure(2)
clf;
plot(Frequency, 10*log10(TxTH), '-k', LineWidth=1.25)
xlabel('Frequency (THz)'); ylabel('Through (dB)');
title('Through Port'); grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Band Selection & FWHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BandCenter = 193.110;                                  % THz
BandWidth  = 0.25;                                      % THz half-window
Band = Frequency > (BandCenter - BandWidth) & ...
       Frequency < (BandCenter + BandWidth);

FreqBand = Frequency(Band);
TxDRBand = TxDR(Band);
TxTHBand = TxTH(Band);

% Drop FWHM
HalfMaxDR = 0.5 * max(TxDRBand);
MaskDR    = abs(TxDRBand - HalfMaxDR) < 0.01 * max(TxDRBand);
DropFWHM  = abs(max(FreqBand(MaskDR)) - min(FreqBand(MaskDR))) * 1e3  % GHz

% Through contrast
THContrastdB = max(10*log10(TxTHBand)) - min(10*log10(TxTHBand));      % dB
THContrast   = 10^(THContrastdB/10);

% Quick check plot
figure(2) 
clf
subplot(1,2,1)
plot(FreqBand, TxDRBand, '-k', LineWidth=1.25)
yline(HalfMaxDR, '--r');
xlabel('Frequency (THz)'); ylabel('Drop (lin)');
title('Drop - FWHM check'); grid on;

subplot(1,2,2)
plot(FreqBand, 10*log10(TxTHBand), '-k', LineWidth=1.25)
xlabel('Frequency (THz)'); ylabel('Through (dB)');
title('Through - Contrast check'); grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kappa Extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DropFWHMRad = DropFWHM * 1e9 * 2*pi                % GHz -> rad/s

Kin = 0.5 * DropFWHMRad / sqrt(THContrast);
Kex = (0.5 * DropFWHMRad - Kin) / 2;

KinFreq = Kin / (2*pi) * 1e-9                         % GHz
KexFreq = Kex / (2*pi) * 1e-9                         % GHz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FSR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, peakIdx] = findpeaks(TxDR, 'MinPeakHeight', 0.6*max(TxDR));
PeakFreqs = Frequency(peakIdx);                        % THz
FSR_THz = abs(diff(PeakFreqs));
FSR_GHz = mean(FSR_THz) * 1e3                          % GHz

figure(1); 
hold on
plot(PeakFreqs, 10*log10(TxDR(peakIdx)), 'rv', MarkerSize=8, MarkerFaceColor='r');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kappa^2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Kappa_sq = 2*(LengthRing/Vg)*(Kex*2*pi)

Kappa_sq_2 = 2*(LengthRing/Vg)*(5.25e9)

DropFWHMRad_GHz = DropFWHM * 2*pi 

Kex_1 = (DropFWHMRad_GHz/4)*1e9

Kappa_sq_3 = 2*(LengthRing/Vg)*(Kex_1)