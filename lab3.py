import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Author: Sean Yin
# Date: 12-Feb-2025
# Purpose: This script models MOSFET behavior with ID vs. VGS data,
# plots the data, selects specific points, performs linear and quadratic regression, and calculates related parameters.


# Selected device points  (Change this to your data)
selected_VGS = np.array([1.2121, 2.4747, 3.7374, 4.4949])
selected_ID = np.array([0.001, 0.1625, 0.6438, 1.0857])
selected_index = 2
quadratic_fit = False

# Load data from CSV. % Change this to your CSV file name
filename = 'lab2_1.csv'
data = pd.read_csv(filename, skiprows=1)

# Select columns for x and y
x = data['Volt']
y = data['Volt.2']
# Define subsequence range
start_idx = 1000
end_idx = 1215



# Plotting selected points with potential linear and quadratic fits
plt.figure()
plt.scatter(selected_ID, selected_VGS, color='blue', label='Selected Points')
plt.xlabel('$I_D$ (A)', fontsize=12)
plt.ylabel('$V_{GS}$ (V)', fontsize=12)
plt.title('Selected Points with Linear and Quadratic Fits')
plt.grid(True)

# Linear fit
p_linear = np.polyfit(selected_ID, selected_VGS, 1)
fitted_linear = np.polyval(p_linear, selected_ID)
plt.plot(selected_ID, fitted_linear, 'r--', label=f'Linear fit: y = {p_linear[0]:.2f}x + {p_linear[1]:.2f}')

# Conditionally perform quadratic fit
if quadratic_fit:
    p_quad = np.polyfit(selected_ID, selected_VGS, 2)
    fitted_quad = np.polyval(p_quad, selected_ID)
    plt.plot(selected_ID, fitted_quad, 'b--', label=f'Quadratic fit: y = {p_quad[0]:.2f}x² + {p_quad[1]:.2f}x + {p_quad[2]:.2f}')

plt.legend()
plt.show()

# Calculating parameters using the linear fit
Vtn_est = p_linear[1]  # Estimate Vtn as the intercept from the linear fit
vGS_example = selected_VGS[selected_index]  # Example VGS
iD_example = selected_ID[selected_index]  # Corresponding ID
K_est = iD_example / (vGS_example - Vtn_est) ** 2
gm = 2 * K_est * (vGS_example - Vtn_est)

print(f'Estimated Vtn = {Vtn_est:.2f} V')
print(f'Estimated K = {K_est:.4f} A/V^2')
print(f'Calculated gm = {gm:.4f} S')

# Additional data processing example
x_sub = x[start_idx:end_idx]
y_sub = y[start_idx:end_idx] / 100 * 10**3

# Plotting the additional data with linear fit
plt.figure()
plt.scatter(x_sub, y_sub, color='blue', label='Subsequence Points')
p2 = np.polyfit(x_sub, y_sub, 1)
fitted_linear2 = np.polyval(p2, x_sub)
plt.plot(x_sub, fitted_linear2, 'r--', label=f'Fit: y = {p2[0]:.2f}x + {p2[1]:.2f}')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Additional Data Linear Fit')
plt.legend()
plt.show()

# Additional calculations
ro_est = 1 / p2[0]
lambda_val = (1 / ro_est) * 15
Va = ro_est * 15

print(f'Estimated ro = {ro_est:.2f} Ohms')
print(f'Calculated $\lambda$ = {lambda_val:.2f} (unitless)')
print(f'Calculated Va = {Va:.2f} V')
