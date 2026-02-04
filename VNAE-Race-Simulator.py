import numpy as np
import matplotlib.pyplot as plt

# -----------------------------
# 1. USER CONFIGURATION (Play with these!)
# -----------------------------
np.random.seed(123)

# Asymmetry Parameters: Change these to make one player "stronger"
theta_1 = 1.10  # Power of Player 1
theta_2 = 1.00  # Power of Player 2
beta = 0.20     # Global Rigidity / Constraint

# Environment Parameters
omega_noise = 1.0       # Higher = more chaos/randomness
target_position = 5.0   # Goal distance
runs = 10_000           # Total number of matches simulated

# -----------------------------
# 2. VNAE LOGIC
# -----------------------------
def get_effective_probability(theta, beta):
    return theta / (1 + beta)

prob_1 = get_effective_probability(theta_1, beta)
prob_2 = get_effective_probability(theta_2, beta)

# Normalize probabilities so they compete within the same scale
total_p = prob_1 + prob_2
prob_1 /= total_p
prob_2 /= total_p

# -----------------------------
# 3. MONTE CARLO SIMULATION
# -----------------------------
wins_1 = 0
wins_2 = 0

for r in range(runs):
    pos_1 = 0.0
    pos_2 = 0.0
    
    # Each match continues until someone hits the target
    while pos_1 < target_position and pos_2 < target_position:
        pos_1 += np.random.normal(prob_1, omega_noise)
        pos_2 += np.random.normal(prob_2, omega_noise)

    if pos_1 > pos_2:
        wins_1 += 1
    else:
        wins_2 += 1

# -----------------------------
# 4. RESULTS & ACCUMULATED VISUALIZATION
# -----------------------------
win_rate_1 = (wins_1 / runs) * 100
win_rate_2 = (wins_2 / runs) * 100

print(f"--- VNAE COMPETITION RESULTS ---")
print(f"Player 1 Win Rate: {win_rate_1:.2f}%")
print(f"Player 2 Win Rate: {win_rate_2:.2f}%")

# Create Accumulated Bar Chart
labels = ['Competition Outcome']
plt.figure(figsize=(8, 5))

# We use a horizontal stacked bar to show the "market share" of wins
p1 = plt.barh(labels, [win_rate_1], color='#1f77b4', edgecolor='white', label=f'Player 1 ({theta_1})')
p2 = plt.barh(labels, [win_rate_2], left=[win_rate_1], color='#d62728', edgecolor='white', label=f'Player 2 ({theta_2})')

# Add percentage text inside the bars
plt.text(win_rate_1/2, 0, f'{win_rate_1:.1f}%', va='center', ha='center', color='white', fontweight='bold', fontsize=14)
plt.text(win_rate_1 + (win_rate_2/2), 0, f'{win_rate_2:.1f}%', va='center', ha='center', color='white', fontweight='bold', fontsize=14)

# Formatting
plt.title(f"Accumulated Win Distribution (Beta: {beta})", fontsize=14, fontweight='bold')
plt.xlabel("Percentage of Total Wins (%)")
plt.xlim(0, 100)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, frameon=True, shadow=True)
plt.tight_layout()

plt.show()
