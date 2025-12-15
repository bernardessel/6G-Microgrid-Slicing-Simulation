function System = config_parameters()
% =========================================================================
% Project: 6G Ready Network Slicing for Microgrids
% Component: System Configuration & Parameters
% Author: Bernard Kobina Forson Essel
% CONFIGURATION FILE
% Returns the 'System' struct containing all physics constants.
% Description: Defines the simulation constants for URLLC and mMTC slices.
% =========================================================================

    %% 1. 6G Network Parameters
    System.CarrierFreq = 28e9;      % 28 GHz (mmWave)
    System.Bandwidth   = 100e6;     % 100 MHz Total Bandwidth
    System.Subcarrier  = 120e3;     % 120 kHz SCS
    System.TTI         = 0.125e-3;  % 0.125 ms (Transmission Time Interval)

    %% 2. Latency Requirements
    System.MaxLatency_URLLC = 1e-3; % 1 ms (Critical limit for protection)
    
    %% 3. Slice Definitions
    % URLLC (Protection)
    System.Slice_URLLC.PacketSize = 32 * 8; % bits
    System.Slice_URLLC.Priority   = 1;
    
    % mMTC (Meters)
    System.Slice_mMTC.PacketSize  = 200 * 8; % bits
    System.Slice_mMTC.Priority    = 2;
    
    fprintf('System Parameters Loaded: %d MHz Bandwidth \n', System.Bandwidth/1e6);
end