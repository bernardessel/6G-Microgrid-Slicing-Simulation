% =========================================================================
% Project: 6G Ready Network Slicing for Microgrids
% Component: System Configuration & Parameters
% Author: Bernard Kobina Forson Essel
% Description: Defines the simulation constants for URLLC and mMTC slices.
% =========================================================================

clc; clear; close all;

%% 1. 6G Network Parameters
System.CarrierFreq = 28e9;      % 28 GHz (mmWave band for 6G)
System.Bandwidth   = 100e6;     % 100 MHz Total Bandwidth
System.Subcarrier  = 120e3;     % 120 kHz SCS (Numerology 3 for Low Latency)
System.TTI         = 0.125e-3;  % Transmission Time Interval (0.125 ms)

%% 2. Slice Definitions (The Logic)
% Slice 1: URLLC (Protection Relays)
% Priority: Critical (1), Low Data, Ultra Reliability
Slice_URLLC.PacketSize = 32 * 8; % 32 Bytes (converted to bits)
Slice_URLLC.MaxLatency = 1e-3;   % 1 ms Maximum allowed latency
Slice_URLLC.Priority   = 1;      % Highest Priority

% Slice 2: mMTC (Smart Meters)
% Priority: Standard (2), High Density, Delay Tolerant
Slice_mMTC.PacketSize  = 200 * 8; % 200 Bytes (converted to bits)
Slice_mMTC.MaxLatency  = 50e-3;   % 50 ms allowed latency
Slice_mMTC.Priority    = 2;       % Lower Priority

%% 3. Simulation Environment
Num_Relays = 10;    % Number of protection devices
Num_Meters = 500;   % Number of smart meters (High density)

disp('System Parameters Loaded Successfully.');
disp(['Total Bandwidth: ', num2str(System.Bandwidth/1e6), ' MHz']);
disp(['URLLC Target Latency: ', num2str(Slice_URLLC.MaxLatency*1000), ' ms']);
