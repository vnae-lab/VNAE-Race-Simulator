using Random
using Statistics
using Plots
using Distributions

# -----------------------------
# 1. USER CONFIGURATION
# -----------------------------
Random.seed!(123)

# Asymmetry Parameters
theta_1 = 1.10  # Power of Player 1
theta_2 = 1.00  # Power of Player 2
beta    = 0.20  # Global Rigidity / Constraint

# Environment Parameters
omega_noise     = 1.0   # Chaos/randomness
target_position = 5.0   # Goal distance
runs            = 10_000 # Total matches

# -----------------------------
# 2. VNAE LOGIC
# -----------------------------
# Effective probability based on VNAE asymmetry
get_effective_probability(theta, beta) = theta / (1 + beta)

prob_1 = get_effective_probability(theta_1, beta)
prob_2 = get_effective_probability(theta_2, beta)

# Normalize so they compete in the same probability space
total_p = prob_1 + prob_2
prob_1 /= total_p
prob_2 /= total_p

# -----------------------------
# 3. MONTE CARLO SIMULATION
# -----------------------------
wins_1 = 0
wins_2 = 0

println("Running $runs VNAE matches in Julia...")

for r in 1:runs
    pos_1 = 0.0
    pos_2 = 0.0
    
    # Competition continues until a player hits the target
    while pos_1 < target_position && pos_2 < target_position
        pos_1 += rand(Normal(prob_1, omega_noise))
        pos_2 += rand(Normal(prob_2, omega_noise))
    end
    
    if pos_1 > pos_2
        wins_1 += 1
    else
        wins_2 += 1
    end
end

# -----------------------------
# 4. RESULTS & ACCUMULATED VISUALIZATION
# -----------------------------
win_rate_1 = (wins_1 / runs) * 100
win_rate_2 = (wins_2 / runs) * 100

println("--- VNAE COMPETITION RESULTS ---")
println("Player 1 Win Rate: $(round(win_rate_1, digits=2))%")
println("Player 2 Win Rate: $(round(win_rate_2, digits=2))%")

# Horizontal Stacked Bar Chart
p = bar(["Competition Outcome"], [win_rate_1], 
        orientation=:horizontal, 
        color="#1f77b4", 
        label="Player 1 ($theta_1)",
        title="Accumulated Win Distribution (Beta: $beta)",
        ylabel="Total Wins (%)",
        xlims=(0, 100),
        legend=:bottom,
        size=(800, 400))

bar!(["Competition Outcome"], [win_rate_2], 
     orientation=:horizontal, 
     fillrange=[win_rate_1], 
     color="#d62728", 
     label="Player 2 ($theta_2)")

# Inside-bar text annotations
annotate!([
    (win_rate_1/2, 1, text("$(round(win_rate_1, digits=1))%", :white, :bold, 12)),
    (win_rate_1 + win_rate_2/2, 1, text("$(round(win_rate_2, digits=1))%", :white, :bold, 12))
])

display(p)
