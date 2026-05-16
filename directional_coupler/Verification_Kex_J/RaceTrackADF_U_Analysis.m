clc;
clear all;
close all;

c = 3E8;
ng = 2.1470;
Vg = c / ng;
Clx = 12;
Cly = 12;
LengthRing = (2*Clx+ 2*Cly + 2*pi*20) * 1e-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataExpPath = "D:\Ligentic_NU_1_TapeOut_April2026\LT_UMD_Exp_Data\Ligentec Ring Data\Ligentec Ring Data\";
DataSimPath = "D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_RingRaceTrack\";

%Exp data
BaseTitle       = 'LT_C_A4_R';
EndTitleDrop    = '_Drop.txt';
EndTitleThrough = '_Through.txt';
DeviceID         = 1;

DeviceFileNameDR    = strcat(DataExpPath,BaseTitle,num2str(DeviceID,'%1.0f'),EndTitleDrop);
DeviceFileNameTH    = strcat(DataExpPath,BaseTitle,num2str(DeviceID,'%1.0f'),EndTitleThrough);
    
%Sim data 
Width = 1000; %nm
Gap   = 600; %nm

DataSimFileNameEuler = strcat(DataSimPath,sprintf("RaceTrackADF_U_R20um_W%dnm_G%dnm_Clx12um_Cly12um_E.txt",Width,Gap));
DataSimFileName      = strcat(DataSimPath,sprintf("RaceTrackADF_U_R20um_W%dnm_G%dnm_Clx12um_Cly12um.txt",Width,Gap));

%Load data 
DataRawDR   = importdata(DeviceFileNameDR,'\t');
DataRawTH   = importdata(DeviceFileNameTH,'\t');
DataRawSimE = importdata(DataSimFileNameEuler,'\t');
DataRawSim  = importdata(DataSimFileName,'\t');

DataDR   = DataRawDR.data;
DataTH   = DataRawTH.data;
DataSimE = DataRawSimE.data;
DataSim  = DataRawSim.data;

WavelengthDR     = DataDR(:,1); %nm
FrequencyDR      = DataDR(:,2)*1E-3; %THz
TxDRdB           = DataDR(:,3)+20.4;
TxDR             = 10.^(DataDR(:,3)/10);
TxDRNorm         = TxDR./max(TxDR);

WavelengthTH     = DataTH(:,1); %nm
FrequencyTH      = DataTH(:,2)*1E-3; %THz
TxTHdB           = DataTH(:,3)+20.4;
TxTH             = 10.^(DataTH(:,3)/10);
TxTHNorm         = TxTH./max(TxTH);

WavelengthSimE   = DataSimE(:,1);
FrequencySimE    = c./(WavelengthSimE*1E-9)*1E-12; %THz
TxSimETH         = DataSimE(:,2);
TxSimETHdB       = 10*log10(TxSimETH);
TxSimEDR         = DataSimE(:,3);
TxSimEDRdB       = 10*log10(TxSimEDR);


WavelengthSim    = DataSim(:,1);
FrequencySim    = c./(WavelengthSim*1E-9)*1E-12; %THz
TxSimTH          = DataSim(:,2);
TxSimTHdB        = 10*log10(TxSimTH);
TxSimDR          = DataSim(:,3);
TxSimDRdB        = 10*log10(TxSimDR);

figure(1)
clf
subplot(1,2,1)
hold on
plot(FrequencyDR,TxDRdB,'-k',LineWidth=1.25)
plot(FrequencySimE,TxSimEDRdB,'-r',LineWidth=1.25)
plot(FrequencySim,TxSimDRdB,'-b',LineWidth=1.25)
hold off
legend('Exp Drop','Sim Euler Drop','Sim Drop');
xlabel('Frequency (THz)');
ylabel('Transmission Drop');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('Spectra in Frequency')
xlim([192.2,194.7])
grid on;

subplot(1,2,2)
hold on
plot(FrequencyTH,TxTHdB,'-k',LineWidth=1.25)
plot(FrequencySimE,TxSimETHdB,'-r',LineWidth=1.25)
plot(FrequencySim,TxSimTHdB,'-b',LineWidth=1.25)
hold off
legend('Exp Through','Sim Euler Through','Sim Through');
xlabel('Frequency (THz)');
ylabel('Transmission Through');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('Spectra in Frequency')
xlim([192.2,194.8])
grid on;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FWHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BandStartFreq    = 193.119; 
BandStopFreq     = 193.180;  % THz Exp

BandStartFreqSimE  = 193.298; 
BandStopFreqSimE = 193.107; % THz Sim Euler

BandStartFreqSim  = 193.177; 
BandStopFreqSim   = 192.128; % THz Sim

% --- Exp ---;
BandStartIndex = find(abs(FrequencyDR - BandStopFreq)  < 0.001, 1, 'first');
BandStopIndex  = find(abs(FrequencyDR - BandStartFreq) < 0.001, 1, 'first');
Band     = (BandStartIndex:1:BandStopIndex);
FreqBand = FrequencyDR(Band);
TxDRBand = TxDR(Band);
TxTHBand = TxTH(Band);
HalfMaxDR = 0.5 * max(TxDRBand);
HalfMaxTH = 0.5 * max(TxTHBand);
MaskDR = abs(TxDRBand - HalfMaxDR) < 0.01 * max(TxDRBand);
MaskTH = abs(TxTHBand - HalfMaxTH) < 0.02 * max(TxTHBand);
DropFWHM    = abs(max(FreqBand(MaskDR)) - min(FreqBand(MaskDR))) * 1E3 % GHz
ThroughFWHM = abs(max(FreqBand(MaskTH)) - min(FreqBand(MaskTH))) * 1E3 % GHz

% --- Sim Euler ---
BandStartIndexSimE = find(abs(FrequencySimE - BandStopFreqSimE)  < 0.001, 1, 'first');

BandStopIndexSimE  = find(abs(FrequencySimE - BandStartFreqSimE) < 0.001, 1, 'first');
BandSimE     = (BandStartIndexSimE:1:BandStopIndexSimE);
FreqBandSimE = FrequencySimE(BandSimE);
TxSimEDRBand = TxSimEDR(BandSimE);
TxSimETHBand = TxSimETH(BandSimE);
HalfMaxSimEDR = 0.5 * max(TxSimEDRBand);
HalfMaxSimETH = 0.5 * max(TxSimETHBand);
MaskSimEDR = abs(TxSimEDRBand - HalfMaxSimEDR) < 0.01*HalfMaxSimEDR;
MaskSimETH = abs(TxSimETHBand - HalfMaxSimETH) < 0.01*HalfMaxSimETH;
DropFWHMSimE    = abs(max(FreqBandSimE(MaskSimEDR)) - min(FreqBandSimE(MaskSimEDR))) * 1E3  % GHz
ThroughFWHMSimE = abs(max(FreqBandSimE(MaskSimETH)) - min(FreqBandSimE(MaskSimETH))) * 1E3  % GHz

% --- Sim ---
BandStartIndexSim = find(abs(FrequencySim - BandStopFreqSim)  < 0.01, 1, 'first');
BandStopIndexSim  = find(abs(FrequencySim - BandStartFreqSim) < 0.01, 1, 'first');
BandSim     = (BandStartIndexSim:1:BandStopIndexSim);
FreqBandSim = FrequencySim(BandSim);
TxSimDRBand = TxSimDR(BandSim);
TxSimTHBand = TxSimTH(BandSim);
HalfMaxSimDR = 0.5 * max(TxSimDRBand);
HalfMaxSimTH = 0.5 * max(TxSimTHBand);
MaskSimDR = abs(TxSimDRBand - HalfMaxSimDR) < 0.01*HalfMaxSimDR;
MaskSimTH = abs(TxSimTHBand - HalfMaxSimTH) < 0.01*HalfMaxSimTH;
DropFWHMSim    = abs(max(FreqBandSim(MaskSimDR)) - min(FreqBandSim(MaskSimDR))) * 1E3  % GHz
ThroughFWHMSim = abs(max(FreqBandSim(MaskSimTH)) - min(FreqBandSim(MaskSimTH))) * 1E3 % GHz

figure(3)
clf
subplot(1,2,1)
hold on
plot(FrequencyDR,TxDRNorm,'-k',LineWidth=1.25)
plot(FrequencySimE,TxSimEDR,'-r',LineWidth=1.25)
plot(FrequencySim,TxSimDR,'-b',LineWidth=1.25)
FreqAtHalfDR     = FreqBand(MaskDR);
FreqAtHalfSimEDR = FreqBandSimE(MaskSimEDR);
FreqAtHalfSimDR  = FreqBandSim(MaskSimDR);
yline(HalfMaxDR / max(TxDR), '--k', Alpha=0.5);  
yline(HalfMaxSimEDR,'--r',Alpha=0.5);
yline(HalfMaxSimDR, '--b',Alpha=0.5);
xline(FreqAtHalfDR(1),    '--k',Alpha=0.5);
xline(FreqAtHalfDR(end),  '--k',Alpha=0.5);
xline(FreqAtHalfSimEDR(1),  '--r',Alpha=0.5);
xline(FreqAtHalfSimEDR(end),'--r',Alpha=0.5);
xline(FreqAtHalfSimDR(1),   '--b',Alpha=0.5);
xline(FreqAtHalfSimDR(end), '--b',Alpha=0.5);
hold off
legend('Exp Drop','Sim Euler Drop','Sim Drop');
xlabel('Frequency (THz)');
ylabel('Transmission (normalized)');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('FWHM Check - Drop')
xlim([192.2,194.7])
grid on;

subplot(1,2,2)
hold on
plot(FrequencyTH,TxTHNorm,'-k',LineWidth=1.25)
plot(FrequencySimE,TxSimETH,'-r',LineWidth=1.25)
plot(FrequencySim,TxSimTH,'-b',LineWidth=1.25)
FreqAtHalfTH     = FreqBand(MaskTH);
FreqAtHalfSimETH = FreqBandSimE(MaskSimETH);
FreqAtHalfSimTH  = FreqBandSim(MaskSimTH);
yline(HalfMaxTH / max(TxTH), '--k', Alpha=0.5);  
yline(HalfMaxSimETH,'--r',Alpha=0.5);
yline(HalfMaxSimTH, '--b',Alpha=0.5);
xline(FreqAtHalfTH(1),    '--k',Alpha=0.5);
xline(FreqAtHalfTH(end),  '--k',Alpha=0.5);
xline(FreqAtHalfSimETH(1),  '--r',Alpha=0.5);
xline(FreqAtHalfSimETH(end),'--r',Alpha=0.5);
xline(FreqAtHalfSimTH(1),   '--b',Alpha=0.5);
xline(FreqAtHalfSimTH(end), '--b',Alpha=0.5);
hold off
legend('Exp Through','Sim Euler Through','Sim Through');
xlabel('Frequency (THz)');
ylabel('Transmission (normalized)');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('FWHM Check - Through')
xlim([192.2,194.8])
grid on;
figure(4)
clf
FWHMData = [DropFWHM,     ThroughFWHM;
            DropFWHMSimE, ThroughFWHMSimE;
            DropFWHMSim,  ThroughFWHMSim];
b = bar(FWHMData);
b(1).FaceColor = 'k';
b(2).FaceColor = [0.6 0.6 0.6];
xticklabels({'Exp','Sim Euler','Sim'})
ylabel('FWHM (GHz)')
title('FWHM Comparison - Drop vs Through')
legend('Drop','Through')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters Extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Exp ---
DRContrastdB = max(TxDRdB(Band)) - min(TxDRdB(Band));
THContrastdB = max(TxTHdB(Band)) - min(TxTHdB(Band));
DRContrast   = 10^(DRContrastdB/10);
THContrast   = 10^(THContrastdB/10);

DropFWHMRad    = DropFWHM    * 1e9 * 2*pi; % rad/s
ThroughFWHMRad = ThroughFWHM * 1e9 * 2*pi; % rad/s

Kex = 0.25 * DropFWHMRad * (1 - 1/sqrt(THContrast));
Kin = 0.5  * DropFWHMRad / sqrt(THContrast);

KexFrequency = Kex / (2*pi); % Hz
KinFrequency = Kin / (2*pi); % Hz

K             = 2*Kex / (Vg/LengthRing);
T             = 1 - K;
alpha         = (Kin/LengthRing) / (Vg/LengthRing);
alpha_dB_cm   = alpha * 10/log(10) / 100;
RoundTripTime = LengthRing / Vg;
PhotonLifeTime = 1 / (2*(2*Kex + Kin))
ExpectedDelay  = 1 / (2*Kex);
Finesse1 = 2*pi * PhotonLifeTime / RoundTripTime;

% --- Sim Euler ---
DRContrastdBSimE = max(TxSimEDRdB(BandSimE)) - min(TxSimEDRdB(BandSimE));
THContrastdBSimE = max(TxSimETHdB(BandSimE)) - min(TxSimETHdB(BandSimE));
DRContrastSimE   = 10^(DRContrastdBSimE/10);
THContrastSimE   = 10^(THContrastdBSimE/10);

DropFWHMRadSimE    = DropFWHMSimE    * 1e9 * 2*pi; % rad/s
ThroughFWHMRadSimE = ThroughFWHMSimE * 1e9 * 2*pi; % rad/s

KexSimE = 0.25 * DropFWHMRadSimE * (1 - 1/sqrt(THContrastSimE));
KinSimE = 0.5  * DropFWHMRadSimE / sqrt(THContrastSimE);

KexFrequencySimE = KexSimE / (2*pi); % Hz
KinFrequencySimE = KinSimE / (2*pi); % Hz

KSimE             = 2*KexSimE / (Vg/LengthRing);
TSimE             = 1 - KSimE;
alphaSimE         = (KinSimE/LengthRing) / (Vg/LengthRing);
alphaSimE_dB_cm   = alphaSimE * 10/log(10) / 100;
PhotonLifeTimeSimE = 1 / (2*(2*KexSimE + KinSimE))
Finesse1SimE = 2*pi * PhotonLifeTimeSimE / RoundTripTime;

% --- Sim ---
DRContrastdBSim = max(TxSimDRdB(BandSim)) - min(TxSimDRdB(BandSim));
THContrastdBSim = max(TxSimTHdB(BandSim)) - min(TxSimTHdB(BandSim));
DRContrastSim   = 10^(DRContrastdBSim/10);
THContrastSim   = 10^(THContrastdBSim/10);

DropFWHMRadSim    = DropFWHMSim    * 1e9 * 2*pi; % rad/s
ThroughFWHMRadSim = ThroughFWHMSim * 1e9 * 2*pi; % rad/s

KexSim = 0.25 * DropFWHMRadSim * (1 - 1/sqrt(THContrastSim));
KinSim = 0.5  * DropFWHMRadSim / sqrt(THContrastSim);

KexFrequencySim = KexSim / (2*pi); % Hz
KinFrequencySim = KinSim / (2*pi); % Hz

KSim             = 2*KexSim / (Vg/LengthRing);
TSim             = 1 - KSim;
alphaSim         = (KinSim/LengthRing) / (Vg/LengthRing);
alphaSim_dB_cm   = alphaSim * 10/log(10) / 100;
PhotonLifeTimeSim = 1 / (2*(2*KexSim + KinSim))
Finesse1Sim = 2*pi * PhotonLifeTimeSim / RoundTripTime;

figure(5)
clf
subplot(1,3,1)
bar([KexFrequency; KexFrequencySimE; KexFrequencySim]*1e-9)
xticklabels({'Exp','Sim Euler','Sim'})
ylabel('K_{ex} (GHz)')
title('External Coupling Rate')
grid on

subplot(1,3,2)
bar([KinFrequency; KinFrequencySimE; KinFrequencySim]*1e-9)
xticklabels({'Exp','Sim Euler','Sim'})
ylabel('K_{in} (GHz)')
title('Internal Loss Rate')
grid on

subplot(1,3,3)
bar([alpha_dB_cm; alphaSimE_dB_cm; alphaSim_dB_cm])
xticklabels({'Exp','Sim Euler','Sim'})
ylabel('Loss (dB/cm)')
title('Propagation Loss')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CMT Fit - Exp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W  = 2*pi * linspace(193.119e12, 193.180e12, 10000); % rad/s
W0 = 2*pi * 193.151e12;                              % rad/s

KexFit = Kex;
KinFit = Kin;

EIn = 1;
for m = 1:length(W)
    a(m)        = EIn * (-sqrt(2*KexFit)) / (1i*(W(m)-W0) + (KexFit+KexFit+KinFit));
    EThrough(m) = EIn + sqrt(2*KexFit)*a(m);
    EDrop(m)    = -sqrt(2*KexFit)*a(m);
    PThrough(m) = abs(EThrough(m))^2;
    PDrop(m)    = abs(EDrop(m))^2;
end

WGHz = W/(2*pi*1e9); % GHz
FreqBandGHz = FreqBand * 1e3; % THz -> GHz

figure(6)
clf
subplot(1,2,1)
hold on
plot(FreqBandGHz, 10*log10(TxDRBand/max(TxDRBand)), '-k', LineWidth=1.25)
plot(WGHz, 10*log10(PDrop/max(PDrop)), '--r', LineWidth=1.25)
hold off
legend('Exp Drop','CMT Fit');
xlabel('Frequency (GHz)');
ylabel('Transmission (dB)');
title('CMT Fit - Drop')
grid on

subplot(1,2,2)
hold on
plot(FreqBandGHz, 10*log10(TxTHBand/max(TxTHBand)), '-k', LineWidth=1.25)
plot(WGHz, 10*log10(PThrough/max(PThrough)), '--r', LineWidth=1.25)
% plot(WGHz, 10*log10(PThrough), '--r', LineWidth=1.25)
hold off
legend('Exp Through','CMT Fit');
xlabel('Frequency (GHz)');
ylabel('Transmission (dB)');
title('CMT Fit - Through')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fig 8 - Aligned Spectra (Exp vs Sim with frequency shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ShiftSimE = -0.07+0.0135; % THz
ShiftSim  = -0.65-0.0304; % THz
ShiftExpTx = 1.2;

FrequencySimEShifted = FrequencySimE + ShiftSimE;
FrequencySimShifted  = FrequencySim  + ShiftSim;
TxTHdBShifted = TxTHdB - ShiftExpTx;

figure(8)
clf
subplot(1,2,1)
hold on
plot(FrequencyDR,          TxTHdB,     '-k', LineWidth=1.25)
plot(FrequencySimEShifted, TxSimEDRdB, '-r', LineWidth=1.25)
plot(FrequencySimShifted,  TxSimDRdB,  '-b', LineWidth=1.25)
hold off
legend('Exp Drop','Sim Euler Drop (shifted)','Sim Drop (shifted)');
xlabel('Frequency (THz)');
ylabel('Transmission Drop (dB)');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('Aligned Spectra - Drop')
xlim([193.1,193.25])
grid on;

subplot(1,2,2)
hold on
plot(FrequencyTH,          TxTHdBShifted,     '-k', LineWidth=1.25)
plot(FrequencySimEShifted, TxSimETHdB, '-r', LineWidth=1.25)
plot(FrequencySimShifted,  TxSimTHdB,  '-b', LineWidth=1.25)
hold off
legend('Exp Through','Sim Euler Through (shifted)','Sim Through (shifted)');
xlabel('Frequency (THz)');
ylabel('Transmission Through (dB)');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('Aligned Spectra - Through')
xlim([193.1,193.25])
grid on;