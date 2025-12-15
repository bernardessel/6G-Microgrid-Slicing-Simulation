import sys
import time
from scapy.all import Ether, IP, UDP, Raw, sendp

def send_goose(interface, dscp_val, message_type):
    # IEC 61850 GOOSE usually runs directly over Ethernet (Ethertype 0x88B8)
    # However, for easier routing in Mininet/SDN, we often encapsulate in IP/UDP 
    # and use DSCP tags to mark the class of service.
    
    # DSCP Mapping:
    # 46 (EF) = Protection (High Crit)
    # 34 (AF41) = Control
    # 18 (AF21) = Telemetry
    # 0 (BE) = Maintenance

    print(f"Starting GOOSE Stream on {interface} with DSCP {dscp_val}...")
    
    # Create the packet
    # Tos field in IP header = DSCP << 2
    tos_val = int(dscp_val) << 2
    
    pkt = Ether(src='00:00:00:00:00:01', dst='00:00:00:00:00:02') / \
          IP(src='10.0.0.1', dst='10.0.0.2', tos=tos_val) / \
          UDP(sport=10000, dport=10000) / \
          Raw(load=f"GOOSE_IEC61850_Type:{message_type}_Timestamp:{time.time()}")

    # Send in a loop
    try:
        while True:
            sendp(pkt, iface=interface, verbose=False)
            time.sleep(0.01) # 10ms interval (100Hz frequency - typical for Grid)
            # Update timestamp in payload for latency checks later
            pkt[Raw].load = f"GOOSE_IEC61850_Type:{message_type}_Timestamp:{time.time()}"
    except KeyboardInterrupt:
        print("\nStopping GOOSE Stream")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 goose_gen.py <interface> <dscp>")
        sys.exit(1)
    
    iface = sys.argv[1]
    dscp = sys.argv[2]
    send_goose(iface, dscp, "TRIP_SIGNAL")
