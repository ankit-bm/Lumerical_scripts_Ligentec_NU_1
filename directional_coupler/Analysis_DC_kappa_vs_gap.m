clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler';
cd(data_path);

T = readtable('Kappa2_vs_gap_n1.97_R25_W1200nm.csv');
T.Properties.VariableNames
T = sortrows(T, {'G', 'E'});

% figure(1)
% clf;
% hold on;
% CLs = unique(T.CL)
% for i = 1:length(CLs)
%     m = T.CL == CLs(i);
%     plot(T.G(m), T.Kappa_sq(m), '-o', 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', 'auto', 'DisplayName', sprintf('Lc = %d µm', CLs(i)));
% end
% xlabel('Gap (nm)');
% ylabel('\kappa^2');
% legend('Location','best');
% title(sprintf('R = %d µm | W = %d nm', T.R(1), T.W(1)));
% hold off
% grid on;

T = sortrows(T, {'E', 'G'});

CLs = unique(T.CL);
Es  = unique(T.E);
nPerFig = 6;
nFigs = ceil(length(CLs) / nPerFig);

for f = 1:nFigs
    figure(f); clf; hold on;
    idx = (f-1)*nPerFig+1 : min(f*nPerFig, length(CLs));
    for i = idx
        for j = 1:length(Es)
            m = T.CL == CLs(i) & T.E == Es(j);
            if sum(m) == 0, continue; end
            if Es(j) == 1
                style = '-o';
            else
                style = '--s';
            end
            plot(T.G(m), T.Kappa_sq(m), style, LineWidth=1.5, MarkerSize=8, ...
                MarkerFaceColor="auto",...
                DisplayName=sprintf('Lc=%d µm | E=%d', CLs(i), Es(j)));
        end
    end
    xlabel('Gap (nm)'); ylabel('\kappa^2');
    legend('Location','best');
    title(sprintf('R = %d µm | W = %d nm | Lc %d–%d µm', ...
        T.R(1), T.W(1), CLs(idx(1)), CLs(idx(end))));
    grid on; hold off;
end

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
