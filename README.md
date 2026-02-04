# VNAE-Race-Simulator

A multi-language stochastic playground for the **Victoria-Nash Asymmetric Equilibrium (VNAE) and/or Victoria-Nash Geometry** framework. This repository provides Monte Carlo simulations to explore how structural asymmetry ($\theta$) and environmental constraints ($\beta$) influence competitive convergence and win rates.

---

## Overview

The **VNAE Race Simulator** models a stochastic competition between two players. Unlike standard random walks, this model incorporates VNAE Structural Factors to determine effective probabilities. It demonstrates that even minor advantages in node "rigidity" or "power" lead to predictable geometric stability over large-scale iterations.



---

## Features

* **Multi-Language Support:** Optimized implementations in **Python, R, Julia, and MATLAB**.
* **VNAE Logic:** Real-time calculation of effective probabilities based on the VNAE fundamental equation.
* **Monte Carlo Engine:** Simulated "races" with customizable noise levels and target boundaries.
* **Visual Analytics:** Professional-grade stacked bar charts to visualize the "Market Share" of wins.

---

## Core Parameters

| Parameter         | Description                | Impact                                                                 |
| :---------------- | :------------------------- | :--------------------------------------------------------------------- |
| `theta_1`         | Player 1 Structural Power  | Higher values increase effective win probability.                       |
| `theta_2`         | Player 2 Structural Power  | The competitive baseline for asymmetry.                                |
| `beta`            | Global Rigidity            | Structural factor that scales the impact of $\theta$.                  |
| `target_position` | Goal Distance              | Threshold for convergence; defines length of exposure to asymmetry.    |
| `omega_noise`     | Stochastic Entropy         | Represents environmental noise and uncertainty.                        |

---

## Contributing

Feel free to fork this repository and add implementations in other languages (e.g., Rust, C++, or Go) or suggest improvements to the visualization modules.

---

## Reference

Pereira, D. H. (2025). Riemannian Manifolds of Asymmetric Equilibria: The Victoria-Nash Geometry.
