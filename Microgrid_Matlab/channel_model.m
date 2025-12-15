function [SNR_dB, PathLoss_dB] = channel_model(Distance, System)
% =========================================================================
% Function: 6G Channel Model (mmWave)
% Description: Calculates Path Loss and SNR based on distance and freq.
% Inputs:
%   - Distance: Distance between Base Station and Device (meters)
%   - System: Struct containing bandwidth and frequency params
% Outputs:
%   - SNR_dB: Signal-to-Noise Ratio (Decibels)
%   - PathLoss_dB: Total signal loss over the air
% =========================================================================

    %% 1. Constants
    c = 3e8; % Speed of light (m/s)
    Tx_Power_dBm = 43; % Transmission Power (Typical for Microgrid BS: 20 Watts)
    Tx_Gain_dBi = 15;  % Antenna Gain (Directional Beamforming)
    Rx_Gain_dBi = 5;   % Receiver Antenna Gain

    %% 2. Calculate Path Loss (Free Space Path Loss Model)
    % Formula: PL = 20log10(d) + 20log10(f) + 20log10(4*pi/c)
    % Note: Frequency must be in Hz
    lambda = c / System.CarrierFreq;
    
    % FSPL Calculation
    PathLoss_dB = 20*log10(Distance) + 20*log10(System.CarrierFreq) + ...
                  20*log10(4*pi/c);
              
    % Add simplified rain/atmospheric attenuation for 28GHz (approx 0.5 dB/km)
    Atmospheric_Loss = 0.5 * (Distance/1000); 
    
    Total_PL = PathLoss_dB + Atmospheric_Loss;

    %% 3. Calculate Thermal Noise
    % Boltzmann constant k = 1.38e-23 J/K
    % T = 290K (Standard Temperature)
    % Noise Spectral Density (No) approx -174 dBm/Hz
    
    Noise_Spectral_Density = -174; 
    Thermal_Noise_dBm = Noise_Spectral_Density + 10*log10(System.Bandwidth);

    %% 4. Calculate SNR
    % SNR = (Tx_Power + Gains) - PathLoss - Noise
    Received_Power_dBm = Tx_Power_dBm + Tx_Gain_dBi + Rx_Gain_dBi - Total_PL;
    
    SNR_dB = Received_Power_dBm - Thermal_Noise_dBm;

end