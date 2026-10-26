clear all; close all;
%% MATLAB Script for Extracting and Plotting Time Series Data
% Author: Sean Yin
% Date:   09-Feb-2025
% Purpose: This script reads a CSV file, extracts a subsequence of data, 
%          and plots it as a scatter plot with a moving average line.
%          The legend only appears for the averaging line.

filename = 'lab2_1.csv'; % Change this to your CSV file name
data = readtable(filename);


% Select the columns for x and y
x = data.Var2;
y = data.Var4;


% Define subsequence range
start_idx = 719;
end_idx = 1215;

% Extract subsequence
x_sub = x(start_idx:end_idx);
y_sub = y(start_idx:end_idx)/100;

% Compute moving average for smoothing
window_size = 50; % Adjust for more/less smoothing
y_avg = movmean(y_sub, window_size);

% Inplement moving average manually from scratch.
% y_avg = zeros(size(y_sub)); % Preallocate for efficiency
% 
% % Implement moving average from scratch
% for i = 1:length(y_sub)
%     start_win = max(1, i - floor(window_size / 2)); % Ensure no negative indices
%     end_win = min(length(y_sub), i + floor(window_size / 2)); % Ensure within bounds
%     y_avg(i) = mean(y_sub(start_win:end_win)); % Compute average over the window
% end


% Plot the data
figure(2);
scatter(x_sub, y_sub, 10, 'k', 'filled', 'MarkerFaceAlpha', 0.3); % Small black dots
hold on;
h_avg = plot(x_sub, y_avg, 'r-', 'LineWidth', 2); % Red solid line

xlabel('Voltage (Volts)');
ylabel('Current (A)');
legend(h_avg, 'Moving Average', 'Location', 'southeast');
title('MOSFET Characteristic');
grid on;
