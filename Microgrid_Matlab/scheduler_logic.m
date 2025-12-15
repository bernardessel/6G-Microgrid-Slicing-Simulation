function [Stats, Updated_Queue] = scheduler_logic(Queue, System, Grid_Status, Current_Time)
% =========================================================================
% Function: Advanced 6G Scheduler (Context-Aware + EDF)
% Description: Allocates resources dynamically based on Grid Faults.
% Inputs:
%   - Queue: Struct with fields .URLLC and .mMTC (Packet Arrays)
%   - System: Struct with Bandwidth, TTI, and Latency limits
%   - Grid_Status: 1 = Fault (Critical), 0 = Normal
%   - Current_Time: Current simulation clock (seconds)
% Outputs:
%   - Stats: Struct containing throughput and latency data
%   - Updated_Queue: The queue after processing/dropping packets
% =========================================================================

    %% 1. Initialization
    Spectral_Eff = 4; % bits/Hz (Approximate for decent SNR)
    
    % Calculate Total Bits capacity per TTI
    % Capacity = Bandwidth * Time * Efficiency
    Total_Bits_Capacity = System.Bandwidth * System.TTI * Spectral_Eff;
    
    Used_Bits = 0;
    Updated_Queue = Queue;
    
    % Initialize Stats for this TTI
    Stats.URLLC_Sent = 0;
    Stats.mMTC_Sent = 0;
    Stats.URLLC_Dropped = 0;
    Stats.URLLC_Latency = []; 

    %% 2. Reliability Check (Packet Aging)
    % Before scheduling, check if any URLLC packet has expired (>1ms delay).
    % If it's too late, drop it. It's useless to the protection relay now.
    
    valid_urllc = [];
    for i = 1:length(Updated_Queue.URLLC)
        pkt = Updated_Queue.URLLC(i);
        Wait_Time = Current_Time - pkt.ArrivalTime;
        
        if Wait_Time > System.MaxLatency_URLLC
            Stats.URLLC_Dropped = Stats.URLLC_Dropped + 1; % Log drop
        else
            valid_urllc = [valid_urllc, pkt]; % Keep valid packet
        end
    end
    Updated_Queue.URLLC = valid_urllc;

    %% 3. Sorting: Earliest Deadline First (EDF)
    % Sort URLLC packets so the ones closest to expiring get sent FIRST.
    if ~isempty(Updated_Queue.URLLC)
        % Extract arrival times to sort
        [~, sortIdx] = sort([Updated_Queue.URLLC.ArrivalTime]); 
        Updated_Queue.URLLC = Updated_Queue.URLLC(sortIdx);
    end

    %% 4. Define Resource Shares (The Slicing Logic)
    if Grid_Status == 1 % * FAULT DETECTED *
        % Emergency Mode: Give 100% to Protection
        Max_URLLC_Share = 1.0; 
        Max_mMTC_Share  = 0.05; % Choke meters to 5%
    else % * NORMAL MODE *
        % Standard Mode: Cap Protection to 30% to be fair to meters
        Max_URLLC_Share = 0.30; 
        Max_mMTC_Share  = 0.70; 
    end

    %% 5. Scheduling Loop
    
    % --- Step A: Process URLLC (Protection) ---
    while ~isempty(Updated_Queue.URLLC)
        pkt = Updated_Queue.URLLC(1); % Pick first packet
        
        % Check if we have space in the URLLC allocation
        if (Used_Bits + pkt.Size) <= (Total_Bits_Capacity * Max_URLLC_Share)
            
            % Transmit Packet
            Used_Bits = Used_Bits + pkt.Size;
            Stats.URLLC_Sent = Stats.URLLC_Sent + 1;
            
            % Calculate and Store Latency
            latency = Current_Time - pkt.ArrivalTime;
            Stats.URLLC_Latency = [Stats.URLLC_Latency, latency];
            
            % Remove from Queue
            Updated_Queue.URLLC(1) = [];
        else
            break; % Slice Full
        end
    end

    % --- Step B: Process mMTC (Metering) ---
    % Only schedule if there is remaining total capacity
    while ~isempty(Updated_Queue.mMTC)
        pkt = Updated_Queue.mMTC(1);
        
        % Check 1: Is there space in the TOTAL pipe?
        % Check 2: Have we exceeded the mMTC specific share?
        Condition1 = (Used_Bits + pkt.Size) <= Total_Bits_Capacity;
        Condition2 = (Used_Bits + pkt.Size) <= (Total_Bits_Capacity * (Max_URLLC_Share + Max_mMTC_Share));
        
        if Condition1 && Condition2
            Used_Bits = Used_Bits + pkt.Size;
            Stats.mMTC_Sent = Stats.mMTC_Sent + 1;
            Updated_Queue.mMTC(1) = [];
        else
            break; % Slice Full
        end
    end
end