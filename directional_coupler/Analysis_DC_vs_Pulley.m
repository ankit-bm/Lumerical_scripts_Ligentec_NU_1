clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler Half Ring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path   = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler';
cd(data_path);

T = readtable('Kappa2_vs_gap_n1.97_R25_W1200nm.csv');
T = sortrows(T, {'E', 'G'});

% Define actual Coupling Length values you want to plot (e.g., [8, 10, 15])
CL_to_check = [4,6,8];
E_to_plot  =[1]

CLs = intersect(unique(T.CL), CL_to_check)
Es  = intersect(unique(T.E),E_to_plot);

figure(1); 
clf; 
hold on;
for i = 1:length(CLs)
    for j = 1:length(Es)
        m = T.CL == CLs(i) & T.E == Es(j);
        if sum(m) == 0, continue; end
        
        style = '-o';
        if Es(j) == 0, style = '--s'; end
        
        plot(T.G(m), T.Kappa_sq(m), style, 'LineWidth', 1.5, 'MarkerSize', 8, ...
            'MarkerFaceColor', "auto", ...
            'DisplayName', sprintf('Lc=%d µm | E=%d', CLs(i), Es(j)));
    end
end
xlabel('Gap (nm)'); 
ylabel('\kappa^2');
legend('Location','best');

% --- CHANGE 3: Fixed title logic to handle single or multiple plotted CLs ---
if length(CLs) == 1
    title(sprintf('R = %d µm | W = %d nm | Lc = %d µm', T.R(1), T.W(1), CLs(1)));
else
    title(sprintf('R = %d µm | W = %d nm | Lc = %d–%d µm', T.R(1), T.W(1), min(CLs), max(CLs)));
end

grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler - Pulley 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pulley_data_path = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler_Pulley';
cd(pulley_data_path);

T_pulley = readtable('DC_Pulley_Kappa2_vs_gap_n1.97_R25_W1600nm_WIO1200nm.csv');
T_pulley = sortrows(T_pulley, {'E', 'G'});

CL_to_check = [8,10,12,14,16,18,20];
E_to_plot   = [1];

CLs = intersect(unique(T_pulley.CL), CL_to_check);
Es  = intersect(unique(T_pulley.E), E_to_plot); 

my_colors = turbo(length(CLs)); 

figure(1); 
hold on;  
for i = 1:length(CLs)
    for j = 1:length(Es)

        m = T_pulley.CL == CLs(i) & T_pulley.E == Es(j);
        if sum(m) == 0 
            continue; 
        end
        
        style = '-^';
        if Es(j) == 0 
            style = '--d'; 
        end

        plot(T_pulley.G(m), T_pulley.Kappa_sq(m), style, 'LineWidth', 1.5, 'MarkerSize', 8, ...
            'MarkerFaceColor', "auto", 'Color', my_colors(i,:), ...
            'DisplayName', sprintf('Pulley: Lc=%d µm | E=%d', CLs(i), Es(j)));
    end
end

legend('Location','best');
title('Coupling Efficiency: DC vs. DC Pulley');
grid on; hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directional Coupler - Half ring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HalfRing_data_path = 'D:\Ligentic_NU_1_TapeOut_April2026\results_data\Data_directional_coupler_Pulley';
cd(HalfRing_data_path);

T_HR = readtable('DC_Pulley_Kappa2_vs_gap_n1.97_R25_W1600nm_WIO1200nm.csv');
T_HR = sortrows(T_HR, {G'});

% CL_to_check = [8,10,12,14,16,18,20];
% E_to_plot   = [1];
% 
% CLs = intersect(unique(T_pulley.CL), CL_to_check);
% Es  = intersect(unique(T_pulley.E), E_to_plot); 
% 
% my_colors = turbo(length(CLs)); 
% 
% figure(1); 
% hold on;  
% for i = 1:length(CLs)
%     for j = 1:length(Es)
% 
%         m = T_pulley.CL == CLs(i) & T_pulley.E == Es(j);
%         if sum(m) == 0 
%             continue; 
%         end
% 
%         style = '-^';
%         if Es(j) == 0 
%             style = '--d'; 
%         end
% 
%         plot(T_pulley.G(m), T_pulley.Kappa_sq(m), style, 'LineWidth', 1.5, 'MarkerSize', 8, ...
%             'MarkerFaceColor', "auto", 'Color', my_colors(i,:), ...
%             'DisplayName', sprintf('Pulley: Lc=%d µm | E=%d', CLs(i), Es(j)));
%     end
% end
% 
% legend('Location','best');
% title('Coupling Efficiency: DC vs. DC Pulley');
% grid on; hold off;