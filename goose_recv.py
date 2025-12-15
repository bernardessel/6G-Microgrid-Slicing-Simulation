import sys
import time
from scapy.all import sniff, Raw, IP

def handle_packet(pkt):
    if Raw in pkt:
        # Decode the payload we sent earlier
        payload = pkt[Raw].load.decode('utf-8', errors='ignore')

        # Look for our timestamp tag
        if "Timestamp:" in payload:
            try:
                # Extract the time it was sent
                sent_time = float(payload.split("Timestamp:")[1])
                current_time = time.time()

                # Calculate latency in milliseconds
                latency_ms = (current_time - sent_time) * 1000

                # Print it out
                print(f"[Slice {pkt[IP].tos >> 2}] Latency: {latency_ms:.3f} ms")
            except ValueError:
                pass

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 goose_recv.py <interface>")
        sys.exit(1)

    print(f"Listening for GOOSE latency on {sys.argv[1]}...")
    # Sniff UDP packets on the given interface
    sniff(iface=sys.argv[1], prn=handle_packet, filter="udp", store=0)
