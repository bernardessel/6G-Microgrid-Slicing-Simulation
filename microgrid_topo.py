from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import RemoteController, OVSKernelSwitch
from mininet.link import TCLink
from mininet.cli import CLI
from mininet.log import setLogLevel
import os
import time

class MicrogridTopo(Topo):
    "6G Microgrid Topology with Slicing Requirements"

    def build(self):
        # 1. Base Station (Switch)
        bs = self.addSwitch('s1', cls=OVSKernelSwitch, protocols='OpenFlow13')

        # 2. Utility Server (Destination)
        server = self.addHost('h_server', ip='10.0.0.99/24', mac='00:00:00:00:00:99')
        
        # Link: Base Station <-> Server (100Mbps Backhaul)
        self.addLink(bs, server, bw=100)

        # 3. Slice 1: Protection Relay (URLLC - Fast)
        relay = self.addHost('h_relay', ip='10.0.0.1/24', mac='00:00:00:00:00:01')
        self.addLink(relay, bs, bw=100, delay='1ms') 

        # 4. Slice 2: Smart Meter (mMTC - Slow)
        meter = self.addHost('h_meter', ip='10.0.0.2/24', mac='00:00:00:00:00:02')
        self.addLink(meter, bs, bw=50, delay='5ms') 

def run_microgrid():
    topo = MicrogridTopo()
    # Connect to Remote Controller
    net = Mininet(topo=topo, controller=RemoteController, link=TCLink, switch=OVSKernelSwitch)

    print("[*] Starting 6G Microgrid Simulation...")
    net.start()
    
    # Forcing the switch to speak OpenFlow 1.3 to match Ryu
    os.system('ovs-vsctl set bridge s1 protocols=OpenFlow13')
    #------------------------------------------------------
        
    # Wait for switch to connect
    time.sleep(2)

    print("[*] Configuring Network Slices (QoS Queues)...")
    # Queue 0 (Fast): Min 70Mbps, Max 100Mbps
    # Queue 1 (Slow): Min 1Mbps,  Max 30Mbps
    os.system('ovs-vsctl -- set Port s1-eth1 qos=@newqos -- \
               --id=@newqos create QoS type=linux-htb other-config:max-rate=100000000 queues=0=@q0,1=@q1 -- \
               --id=@q0 create Queue other-config:min-rate=70000000 other-config:max-rate=100000000 -- \
               --id=@q1 create Queue other-config:min-rate=1000000 other-config:max-rate=30000000')

    print("[*] Slices Created. Ready.")
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    run_microgrid()


