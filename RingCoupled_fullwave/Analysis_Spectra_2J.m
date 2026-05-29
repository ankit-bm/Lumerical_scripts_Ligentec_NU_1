clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler Half Ring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_AQH_CB_6x6_test';
cd(data_path);

T = readtable('Test_AQH_6x6_CB_FCGap_500nm_Rings_R25um_W1200nm_Gap300nm_Lc40um_decay1e-05.txt');
T.Properties.VariableNames


c = 3E8;
lambda_m = T.x_Wavelength_nm * 1e-9;
freq_THz = (c ./ lambda_m) / 1e12;

% Plot
figure(1);
plot(lambda_m*1e9, T.Tx_Through, 'b-', 'LineWidth', 1.5);
hold on;
plot(lambda_m*1e9, T.Tx_Drop, 'r-', 'LineWidth', 1.5);
hold off;
xlabel('Wavelength (nm)');
ylabel('Transmission');
title('Transmission vs. Frequency');
legend('Through', 'Drop');
grid on;

figure(2);
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