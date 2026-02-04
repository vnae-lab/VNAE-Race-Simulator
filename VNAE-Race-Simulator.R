# -----------------------------
# VNAE Toy Model Configuration
# -----------------------------
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

set.seed(123)

# Structural parameters
theta_1 <- 1.10
theta_2 <- 1.00
beta    <- 0.20

# Environment
omega_noise     <- 1.0
target_position <- 5.0
runs            <- 10000

# -----------------------------
# VNAE Logic
# -----------------------------
effective_probability <- function(theta, beta) {
  return(theta / (1 + beta))
}

prob_1 <- effective_probability(theta_1, beta)
prob_2 <- effective_probability(theta_2, beta)

# Normalize
total_p <- prob_1 + prob_2
prob_1  <- prob_1 / total_p
prob_2  <- prob_2 / total_p

# -----------------------------
# Monte Carlo Simulation
# -----------------------------
wins_1 <- 0
wins_2 <- 0

for (r in 1:runs) {
  pos_1 <- 0.0
  pos_2 <- 0.0
  
  while (pos_1 < target_position && pos_2 < target_position) {
    pos_1 <- pos_1 + rnorm(1, mean = prob_1, sd = omega_noise)
    pos_2 <- pos_2 + rnorm(1, mean = prob_2, sd = omega_noise)
  }
  
  if (pos_1 > pos_2) {
    wins_1 <- wins_1 + 1
  } else {
    wins_2 <- wins_2 + 1
  }
}

# -----------------------------
# Visualization (Accumulated Bar)
# -----------------------------
win_rate_1 <- (wins_1 / runs) * 100
win_rate_2 <- (wins_2 / runs) * 100

df <- data.frame(
  Player = c("Player 1", "Player 2"),
  WinRate = c(win_rate_1, win_rate_2)
)

# Plotting with ggplot2
ggplot(df, aes(x = "", y = WinRate, fill = Player)) +
  geom_bar(stat = "identity", width = 0.5, color = "white") +
  coord_flip() +
  scale_fill_manual(values = c("Player 1" = "#1f77b4", "Player 2" = "#d62728")) +
  theme_minimal() +
  labs(title = paste("Accumulated Win Distribution (Beta:", beta, ")"),
       subtitle = paste("Goal Distance:", target_position),
       x = "", y = "Percentage of Total Wins (%)") +
  geom_text(aes(label = paste0(round(WinRate, 1), "%")), 
            position = position_stack(vjust = 0.5), 
            color = "white", fontface = "bold", size = 6) +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold", size = 14),
        axis.text.y = element_blank())
