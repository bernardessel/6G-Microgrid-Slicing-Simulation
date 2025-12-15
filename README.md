# 6G-Ready Network Slicing for Microgrid Resilience

![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Language](https://img.shields.io/badge/Language-Python%203-blue)
![Platform](https://img.shields.io/badge/Platform-Mininet%20%7C%20Ryu%20SDN-orange)
![Domain](https://img.shields.io/badge/Domain-Telecoms%20%7C%20Smart%20Grid-purple)

---

## 📌 Project Overview

This repository presents a **6G-ready SDN-based Network Slicing framework** for enhancing **communication resilience in Smart Microgrid environments**.

As Microgrids integrate increasing numbers of Distributed Energy Resources (DERs), heterogeneous communication requirements arise:

1. **Ultra-Reliable Low-Latency Communications (URLLC)**  
   Required for protection relays, fault isolation, and real-time control  
   *(Target latency < 1 ms)*

2. **Massive Machine-Type Communications (mMTC)**  
   Required for smart meters and high-density sensor networks

To address these conflicting demands, this project applies **Software-Defined Networking (SDN)** using a **Ryu OpenFlow 1.3 controller** to implement **logical network slices** over shared physical infrastructure.

---

## 🚀 Key Features

- Microgrid network emulation using **Mininet**
- Custom **SDN Controller** implemented in Python (Ryu)
- **Network Slicing Algorithm**
  - **Slice 1 (Critical):** Protection Relays → High-priority queue (unrestricted)
  - **Slice 2 (Non-Critical):** Smart Meters → Throttled queue
- Traffic classification via ARP handling and IPv4-based slicing
- Research-grade, reproducible simulation framework

---

## 📊 Performance Evaluation

Throughput was evaluated using **iperf** under congestion conditions.

| Slice | Device Type | Policy Applied | Throughput | Result |
|------|------------|---------------|------------|--------|
| Slice 1 | Protection Relay | Priority Queue (Q0) | **94.0 Mbit/s** | ✅ Guaranteed |
| Slice 2 | Smart Meter | Throttled Queue (Q1) | **28.3 Mbit/s** | ⚠️ Limited |

> **Conclusion:**  
> The slicing algorithm successfully isolated critical protection traffic, ensuring near-full link utilization while restricting non-critical metering data.

---

## 📂 Repository Structure

```text
6G-Microgrid-Slicing-Simulation/
├── controllers/
│   └── my_slicer.py          # Ryu SDN network slicing controller
├── topology/
│   └── microgrid_topo.py     # Mininet microgrid topology
├── docs/
│   └── Architecture_Diagram.png
├── .gitignore
└── README.md
````

> **Note:**
> The Ryu framework itself is installed as a dependency and is **not included** in this repository.

---

## 🛠️ How to Run the Simulation

### 1️⃣ Prerequisites

* **Operating System:** Ubuntu 20.04+ (Linux recommended)
* **Software Dependencies:**

  * Python 3
  * Mininet
  * Ryu SDN Controller
  * Open vSwitch

Install required tools:

```bash
sudo apt update
sudo apt install -y mininet openvswitch-switch
pip install ryu
```

---

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/bernardessel/6G-Microgrid-Slicing-Simulation.git
cd 6G-Microgrid-Slicing-Simulation
```

---

### 3️⃣ Start the SDN Controller (Terminal 1)

**Controller file:**

```
controllers/my_slicer.py
```

Run from the repository root:

```bash
ryu-manager controllers/my_slicer.py
```

Expected output:

```text
--- SLICER APP INITIALIZED CORRECTLY ---
```

---

### 4️⃣ Start the Microgrid Network (Terminal 2)

**Topology file:**

```
topology/microgrid_topo.py
```

```bash
sudo mn -c
sudo python3 topology/microgrid_topo.py
```

---

### 5️⃣ Validate Operation (Mininet CLI)

#### Connectivity Test

```bash
pingall
```

Expected: **0% packet loss**

#### Bandwidth Evaluation

```bash
# Start server
h_server iperf -s &

# Smart Meter (throttled slice)
h_meter iperf -c h_server -t 10

# Protection Relay (high-priority slice)
h_relay iperf -c h_server -t 10
```

---

## 📅 Roadmap

* [1] Problem Definition & Microgrid Modeling
* [2] Mininet Topology Design
* [3] SDN Network Slicing Algorithm (Ryu)
* [4] Performance Evaluation (QoS & Throughput)
* [ 5] AI/ML-based Dynamic Slice Adaptation *(Future Work)*

---

## ✍️ Author

**Bernard Kobina Forson Essel**
Research & Teaching Assistant
Department of Telecommunications Engineering, KNUST

**Research Interests:**
SDN • Network Slicing • Smart Grids • 5G/6G Systems

---

## 📜 License

This project is released for **academic and research purposes**.

````

