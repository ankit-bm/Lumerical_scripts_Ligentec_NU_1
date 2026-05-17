clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler_HalfRing';
cd(data_path);

T1 = readtable('HalfRing_Kappa2_vs_gap_n1.97_R25_W1600nm.csv');
T1 = sortrows(T1, {'G'});

T2 = readtable('HalfRing_Kappa2_vs_gap_n1.97_R25_W1200nm.csv');
T2 = sortrows(T2, {'G'});

T3 = readtable('HalfRing_Kappa2_vs_gap_n1.97_R25_W1000nm.csv');
T3 = sortrows(T3, {'G'});

figure(1)
clf
hold on;

plot(T1.G, T1.Kappa_sq, '-o', LineWidth=1.5, MarkerSize=8, ...
    MarkerFaceColor='auto', DisplayName='W = 1600 nm');
plot(T2.G, T2.Kappa_sq, '-s', LineWidth=1.5, MarkerSize=8, ...
    MarkerFaceColor='auto', DisplayName='W = 1200 nm');
plot(T3.G, T3.Kappa_sq, '-^', LineWidth=1.5, MarkerSize=8, ...
    MarkerFaceColor='auto', DisplayName='W = 1000 nm');

xlabel('Gap (nm)'); ylabel('\kappa^2');
legend('Location','best');
title(sprintf('Half-Ring | R = %d µm | n = 1.97', T1.R(1)));
grid on; hold off;

% figure(2)
% clf;
% hold on;
% for i = 1:length(CLs)
%     m = T.CL == CLs(i);
%     plot(T.G(m), T.Loss(m), '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
% end
% xlabel('Gap (nm)');
% ylabel('Loss (dB)');
% legend('Location','best');
% title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
% grid on;

% figure(3)
% clf;
% hold on;
% c  = 3e8;
% ng = 2.1394;
% vg = c / ng
% R  = 25e-6;
% 
% for i = 1:length(CLs)
%     m  = T.CL == CLs(i);
%     Lc = CLs(i) * 1e-6;
%     L  = 2*pi*R + 4*Lc;          % Lcx = Lcy = Lc
%     Kappa_sq_squre = T.Kappa_sq(m) ;          % fraction
%     J  = (Kappa_sq_squre / 2) .* (vg/L) / 1e9;  % GHz
%     plot(T.G(m), J,  '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
% end
% xlabel('Gap (nm)');
% ylabel('J (GHz)');
% legend('Location','best');
% title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
% grid on;
% 
% figure(4)
% clf;
% hold on;
% m0 = T.CL == CLs(1);
% plot(T.G(m0), T.Kappa_sq(m0),'-x','LineWidth', 1);
% xlabel('Gap (nm)');
% ylabel('\kappa^2');
% legend('Location','best');
% title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
% hold off
% grid on;
%%
% figure(5)
% clf
% m0 = T.CL == CLs(1);
% Lc = CLs(1) * 1e-6;
% L  = 2*pi*R + 4*Lc;          % Lcx = Lcy = Lc
% Kappa_sq_squre = T.Kappa_sq(m0) ;          % fraction
% J(m0)  = (Kappa_sq_squre / 2) .* (vg/L) / 1e9;  % GHz
% plot(T.G(m0), J, '-x', 'LineWidth', 1.2, 'MarkerSize', 4);
% xlabel('Gap (nm)');
% ylabel('J (GHz)');
% legend('Location','best');
% grid on;
