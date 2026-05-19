clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler Half Ring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_3Ring_coupled_test';
cd(data_path);

T = readtable('R25um_W1200nm_FCGap400nm_Gap300nm_LcS12um_LcL12um.txt');
T.Properties.VariableNames


c = 3E8;
lambda_m = T.x_Wavelength_nm * 1e-9;
freq_THz = (c ./ lambda_m) / 1e12;

% Plot
figure;
plot(freq_THz, T.Tx_Through, 'b-', 'LineWidth', 1.5);
hold on;
plot(freq_THz, T.Tx_Drop, 'r-', 'LineWidth', 1.5);
hold off;

% Formatting
xlabel('Frequency (THz)');
ylabel('Transmission');
title('Transmission vs. Frequency');
legend('Through', 'Drop');
grid on;