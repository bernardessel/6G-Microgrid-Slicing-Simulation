# 6G-Ready Network Slicing for Microgrid Resilience

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Language](https://img.shields.io/badge/Language-MATLAB-blue)
![Domain](https://img.shields.io/badge/Domain-Telecoms%20%7C%20Smart%20Grid-green)

## 📌 Project Overview
This repository contains the MATLAB simulation framework and research documentation for a 6G-enabled Network Slicing architecture designed specifically for Microgrid environments.

As Microgrids integrate more Distributed Energy Resources (DERs), they require communication networks that can handle two conflicting demands:
1.  Ultra-Reliability & Low Latency (URLLC): For critical protection relays and fault isolation (Target: <1ms latency).
2.  Massive Machine Type Communications (mMTC): For high-density smart metering and sensor data (Target: High connection density).

This project simulates a dynamic resource allocation algorithm that utilizes 6G capabilities to prioritize critical grid traffic during fault events, ensuring grid stability.

---

##  Key Objectives
* Model a 6G Radio Access Network (RAN): Operating at 28 GHz (mmWave) with 120 kHz SCS.
* Simulate Network Slicing: Create distinct logical networks for Protection (URLLC) and Metering (mMTC) on shared infrastructure.
* Dynamic Orchestration: Implement an algorithm that dynamically reallocates bandwidth during "Grid Fault" events.
* Performance Analysis: Evaluate the system based on End-to-End Latency, Packet Success Rate, and Throughput.

---
📂  Repository Structure

```text
6G-Microgrid-Slicing/
├── Docs/                  # Thesis drafts, diagrams, and presentation slides
│   ├── System_Architecture.pdf
│   └── Problem_Statement.md
├── src/                   # MATLAB Source Code
│   ├── config_parameters.m    # System constants (Bandwidth, Frequency, TTI)
│   ├── channel_model.m        # (Upcoming) Signal-to-Noise Ratio & Path Loss models
│   ├── scheduler_logic.m      # (Upcoming) The slicing algorithm
│   └── main_simulation.m      # (Upcoming) The main execution loop
├── results/               # Generated graphs and plots
│   └── latency_vs_load.jpg
└── README.md              # Project Documentation

🛠️ How to Run
Clone this repository:

Bash

git clone [https://github.com/YourUsername/6G-Microgrid-Slicing.git](https://github.com/YourUsername/6G-Microgrid-Slicing.git)
Open MATLAB.

Navigate to the src folder.

Run config_parameters.m to load the system environment.

(Upcoming) Run main_simulation.m to execute the traffic model and generate plots.

## 📅 Roadmap
Phase 1: Problem Statement & System Parameters.

Phase 2: Channel Model (Path Loss & Fading).

Phase 3: Dynamic Slicing Algorithm (The "Scheduler").

Phase 4: Results (Latency & Throughput Graphs).

Phase 5: Final Thesis & IEEE Publication.

✍️ Author
Bernard Kobina Forson Essel Research and Teaching Assistant,Department of Telecommunications Engineering,KNUST | Network Slicing & Smart Grid Researcher

