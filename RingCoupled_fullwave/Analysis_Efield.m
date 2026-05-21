clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler Half Ring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_AQH_4x4_test';
cd(data_path);

T = readtable('Efield_Data_AQH_4x4_Rings_R25um_W1200nm_FCGap500nm_Gap300nm_Lc40um.txt', 'VariableNamingRule', 'preserve');


x = unique(T.x_um);
y = unique(T.y_um);

% Reshape and calculate dB (matching your Python math)
E_int = reshape(T.Ey_intensity, length(x), length(y))';
E_dB  = 10 * log10(E_int / max(E_int(:)) + 1e-20);

% Plot
imagesc(x, y, E_dB);
set(gca, 'YDir', 'normal');
colorbar;
clim([-40 0]); % Equivalent to Python's vmin=-40, vmax=0

xlabel('x (\mum)');
ylabel('y (\mum)');
title('Field Profile at 1550nm');