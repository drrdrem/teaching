import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load data
filename = 'lab2_1.csv'  # Change this to your CSV file name
data = pd.read_csv(filename, skiprows=1)

# Select columns for x and y
x = data['Volt']
y = data['Volt.2']


# Define subsequence range
start_idx = 719
end_idx = 1215

# Extract subsequence
x_sub = x.iloc[start_idx:end_idx+1]
y_sub = y.iloc[start_idx:end_idx+1] / 100

# Compute moving average for smoothing
window_size = 50  # Adjust for more/less smoothing
y_avg = y_sub.rolling(window=window_size, center=True).mean()

# Alternative: Implement moving average manually from scratch
# y_avg = np.zeros(len(y_sub))
# for i in range(len(y_sub)):
#     start_win = max(0, i - window_size // 2)
#     end_win = min(len(y_sub), i + window_size // 2 + 1)
#     y_avg[i] = np.mean(y_sub.iloc[start_win:end_win])

# Plot the data
plt.figure(figsize=(8, 6))
plt.scatter(x_sub, y_sub, s=10, c='k', alpha=0.3, label='_nolegend_')  # Small black dots
plt.plot(x_sub, y_avg, 'r-', linewidth=2, label='Moving Average')  # Red solid line

plt.xlabel('Voltage (Volts)')
plt.ylabel('Current (A)')
plt.legend(loc='lower right')
plt.title('MOSFET Characteristic')
plt.grid(True)
plt.show()