clear all;
close all;

% Author: Sean Yin
% Date: 12-Feb-2025
% Purpose: This script models MOSFET behavior with ID vs. VGS data,
% plots the data, selects specific points, performs linear and quadratic regression, and calculates related parameters.

% Pick points from one device and plot with linear and quadratic fits (Change this to your data)
selected_VGS =[1.2121    2.4747    3.7374    4.4949];
selected_ID = [0.001    0.1625    0.6438    1.0857];
selected_index = 2;
quadratic_fit = false;

filename = 'lab2_1.csv'; % Change this to your CSV file name
data = readtable(filename);

% Select columns for x and y
x = data.Var2;
y = data.Var4;

% Define subsequence range
start_idx = 1000;
end_idx = 1215;


figure(1);
plot(selected_ID, selected_VGS, 'o');
xlabel('$I_{D}$ (A)', 'Interpreter', 'latex');
ylabel('$V_{GS}$ (V)', 'Interpreter', 'latex');
title('Selected Points with Linear and Quadratic Fits', 'Interpreter', 'latex');
grid on;
hold on;

% Linear fit
p_linear = polyfit(selected_ID, selected_VGS, 1); % Linear fit
fitted_linear = polyval(p_linear, selected_ID);
plot(selected_ID, fitted_linear, 'r--');
strLinear = sprintf('y = %.2fx + %.2f', p_linear(1), p_linear(2));
text(mean(selected_ID), mean(fitted_linear), strLinear, 'Color', 'red', 'FontSize', 12);

if quadratic_fit
    % Quadratic fit
    p_quad = polyfit(selected_ID, selected_VGS, 2); % Quadratic fit
    fitted_quad = polyval(p_quad, selected_ID);
    plot(selected_ID, fitted_quad, 'b--');
    strQuad = sprintf('y = %.2fx^2 + %.2fx + %.2f', p_quad(1), p_quad(2), p_quad(3));
    text(max(selected_ID), polyval(p_quad, max(selected_ID)), strQuad, 'Color', 'blue', 'FontSize', 12, 'VerticalAlignment', 'top');
end

hold off;

% Solve for K and calculate gm using a single point
Vtn_est = p_linear(2); % Estimate Vtn as the intercept from the linear fit
Vtn = Vtn_est;
vGS_example = selected_VGS(selected_index); % Example VGS
iD_example = selected_VGS(selected_index); % Corresponding ID
K_est = iD_example / (vGS_example - Vtn)^2;

% Calculate gm
gm = 2 * K_est * (vGS_example - Vtn);

% Display results with proper units and LaTeX formatting
disp(['Estimated $V_{tn}$ = ', num2str(Vtn), ' V']);
disp(['Estimated $K$ = ', num2str(K_est), ' A/V^2']);
disp(['Calculated $g_m$ = ', num2str(gm), ' S']);

% Additional data processing example (assumed from your input)
% Extract subsequence
x_sub = x(start_idx:end_idx);
y_sub = y(start_idx:end_idx)/100*10^3;
p2 = polyfit(x_sub, y_sub, 1); % Linear fit

figure(2);
plot(x_sub, y_sub, 'o');
hold on;
fitted_linear2 = polyval(p2, x_sub);
plot(x_sub, fitted_linear2, 'r--');
strLinear = sprintf('y = %.2fx + %.2f', p2(1), p2(2));
text(mean(x_sub), mean(fitted_linear2), strLinear, 'Color', 'red', 'FontSize', 12);

% Calculate additional parameters and display with LaTeX
ro_est = 1/p2(1);
lambda = (1/ro_est)*15;
Va = ro_est*15;

disp(['Estimated $r_o$ = ', num2str(ro_est), ' $\Omega$', ' Interpreter', 'latex']);
disp(['Calculated $\lambda$ = ', num2str(lambda), ' (unitless)', ' Interpreter', 'latex']);
disp(['Calculated $V_a$ = ', num2str(Va), ' V', ' Interpreter', 'latex']);
