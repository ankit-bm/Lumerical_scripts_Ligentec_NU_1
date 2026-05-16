clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler';
cd(data_path);

T = readtable('Kappa2_vs_gap_Ligentec_R25_W1.csv');
T = sortrows(T, 'G');

figure(1)
clf;
hold on;
CLs = unique(T.CL)
for i = 1:length(CLs)
    m = T.CL == CLs(i);
    plot(T.G(m), T.Kx(m), '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
end
xlabel('Gap (nm)');
ylabel('\kappa^2');
legend('Location','best');
title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
hold off
grid on;

figure(2)
clf;
hold on;
for i = 1:length(CLs)
    m = T.CL == CLs(i);
    plot(T.G(m), T.Loss(m), '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
end
xlabel('Gap (nm)');
ylabel('Loss (dB)');
legend('Location','best');
title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
grid on;

figure(3)
clf;
hold on;
c  = 3e8;
ng = 2.1394;
vg = c / ng
R  = 25e-6;

for i = 1:length(CLs)
    m  = T.CL == CLs(i);
    Lc = CLs(i) * 1e-6;
    L  = 2*pi*R + 4*Lc;          % Lcx = Lcy = Lc
    kx_squre = T.Kx(m) ;          % fraction
    J  = (kx_squre / 2) .* (vg/L) / 1e9;  % GHz
    plot(T.G(m), J,  '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
end
xlabel('Gap (nm)');
ylabel('J (GHz)');
legend('Location','best');
title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
grid on;

figure(4)
clf;
hold on;
m0 = T.CL == CLs(1);
plot(T.G(m0), T.Kx(m0),'-x','LineWidth', 1);
xlabel('Gap (nm)');
ylabel('\kappa^2');
legend('Location','best');
title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
hold off
grid on;
%%
% figure(5)
% clf
% m0 = T.CL == CLs(1);
% Lc = CLs(1) * 1e-6;
% L  = 2*pi*R + 4*Lc;          % Lcx = Lcy = Lc
% kx_squre = T.Kx(m0) ;          % fraction
% J(m0)  = (kx_squre / 2) .* (vg/L) / 1e9;  % GHz
% plot(T.G(m0), J, '-x', 'LineWidth', 1.2, 'MarkerSize', 4);
% xlabel('Gap (nm)');
% ylabel('J (GHz)');
% legend('Location','best');
% grid on;
