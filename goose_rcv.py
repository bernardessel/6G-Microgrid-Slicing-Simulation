import sys
import time
from scapy.all import sniff, Raw, IP

def handle_packet(pkt):
    # Check if packet has Raw data (payload)
    if Raw in pkt:
        # Decode broadly
        payload = pkt[Raw].load.decode('utf-8', errors='ignore')
        
        # DEBUG: Print what we see!
        print(f"DEBUG RAW PAYLOAD: {payload}")

        if "Timestamp:" in payload:
            try:
                data_parts = payload.split("Timestamp:")
                # The timestamp is the second part
                sent_time_str = data_parts[1]
                sent_time = float(sent_time_str)
                
                current_time = time.time()
                latency_ms = (current_time - sent_time) * 1000
                
                print(f"✅ [Slice {pkt[IP].tos >> 2}] Latency: {latency_ms:.3f} ms")
            except Exception as e:
                print(f"❌ Error calculating latency: {e}")
        else:
            print("⚠️ Packet received, but 'Timestamp:' not found in it.")

if name == "main":
    if len(sys.argv) != 2:
        print("Usage: python3 goose_recv.py <interface>")
        sys.exit(1)

    print(f"Listening for GOOSE latency on {sys.argv[1]}...")
    sniff(iface=sys.argv[1], prn=handle_packet, filter="udp", store=0)
