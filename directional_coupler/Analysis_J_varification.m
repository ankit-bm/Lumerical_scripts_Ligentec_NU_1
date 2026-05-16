clc
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ring Resonator Through Port
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_path = 'D:\Ring_MIT_Sid_chip\results_data\Data_RingMod_QuantumComb';
cd(data_path);
data = readmatrix('Data_RingMOD_Squeez_CLx_2.0um_CLy_2.0um_R100.0um_LambdaRange1547-1553nm_GapIO500nm_Tx.txt', 'NumHeaderLines', 14);

Tx = data(:,3);
FreqsData = data(:,2);
InvT = 1-Tx;

[peaks, locations] = findpeaks(InvT, 'MinPeakProminence', 1E-9, 'MinPeakDistance', 2,'MinPeakHeight',0.5);     
Freqs = FreqsData(locations);

figure(1)
clf;
plot(FreqsData, InvT, '-', 'LineWidth', 1);
hold on;
plot(Freqs, InvT(locations), 'rx', 'MarkerSize', 8);
xlabel('Frequency (THz)');
ylabel('Through');
grid on;