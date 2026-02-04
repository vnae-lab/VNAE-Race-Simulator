% -------------------------------------------------------------------------
% VNAE Framework: Asymmetric Competitive Sandbox
% Purpose: Monte Carlo Simulation of Strategic Convergence
% -------------------------------------------------------------------------

clear; clc;

% --- [ 1. USER CONFIGURATION ] ---
rng(123); % For reproducibility

% Asymmetry Parameters
theta_1 = 1.10;  % Power of Player 1
theta_2 = 1.00;  % Power of Player 2
beta = 0.20;     % Global Rigidity / Constraint

% Environment Parameters
omega_noise = 1.0;       % Noise/Entropy level
target_position = 5.0;   % Goal distance (Convergence threshold)
runs = 10000;            % Total simulated matches

% --- [ 2. VNAE LOGIC ] ---
% Effective probability mapping
get_eff_p = @(theta, b) theta / (1 + b);

prob_1 = get_eff_p(theta_1, beta);
prob_2 = get_eff_p(theta_2, beta);

% Normalization to competitive unit space
total_p = prob_1 + prob_2;
prob_1 = prob_1 / total_p;
prob_2 = prob_2 / total_p;

% --- [ 3. MONTE CARLO SIMULATION ] ---
wins_1 = 0;
wins_2 = 0;

fprintf('Simulating %d VNAE matches...\n', runs);

for r = 1:runs
    pos_1 = 0.0;
    pos_2 = 0.0;
    
    % Stochastic race until target boundary is reached
    while pos_1 < target_position && pos_2 < target_position
        pos_1 = pos_1 + normrnd(prob_1, omega_noise);
        pos_2 = pos_2 + normrnd(prob_2, omega_noise);
    end
    
    if pos_1 > pos_2
        wins_1 = wins_1 + 1;
    else
        wins_2 = wins_2 + 1;
    end
end

% --- [ 4. DATA VISUALIZATION ] ---
win_rate_1 = (wins_1 / runs) * 100;
win_rate_2 = (wins_2 / runs) * 100;

fprintf('--- VNAE COMPETITION RESULTS ---\n');
fprintf('Player 1 Win Rate: %.2f%%\n', win_rate_1);
fprintf('Player 2 Win Rate: %.2f%%\n', win_rate_2);

% Render Stacked Distribution Chart
figure('Color', 'w', 'Position', [100, 100, 800, 400]);

% Horizontal bar plotting
b = barh(1, [win_rate_1, win_rate_2], 'stacked', 'EdgeColor', 'w', 'LineWidth', 1.5);
b(1).FaceColor = [31, 119, 180]/255; % Corporate Blue
b(2).FaceColor = [214, 39, 40]/255;  % Alert Red

% Aesthetics and Labeling
title(sprintf('Accumulated Win Distribution (Beta: %.2f)', beta), 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Percentage of Total Wins (%)', 'FontSize', 12);
set(gca, 'YTick', 1, 'YTickLabel', {'VNAE Outcome'}, 'FontSize', 11);
xlim([0 100]);
grid on; set(gca, 'Layer', 'top', 'GridAlpha', 0.1);

% In-bar numerical annotations
text(win_rate_1/2, 1, sprintf('%.1f%%', win_rate_1), ...
    'HorizontalAlignment', 'center', 'Color', 'w', 'FontWeight', 'bold', 'FontSize', 14);
text(win_rate_1 + win_rate_2/2, 1, sprintf('%.1f%%', win_rate_2), ...
    'HorizontalAlignment', 'center', 'Color', 'w', 'FontWeight', 'bold', 'FontSize', 14);

% Legend configuration
lgd = legend({['Player 1 (\theta = ' num2str(theta_1) ')'], ['Player 2 (\theta = ' num2str(theta_2) ')']}, ...
    'Location', 'southoutside', 'Orientation', 'horizontal', 'FontSize', 10);
lgd.Box = 'on';
