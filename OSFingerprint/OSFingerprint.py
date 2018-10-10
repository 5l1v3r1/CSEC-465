from __future__ import print_function
import sys
import argparse
from scapy.all import *

parser = argparse.ArgumentParser(description='OS Fingerprint using ICMP')
parser.add_argument('-f', type=str, required=True, metavar='<input-file>', help='input file')
args = parser.parse_args()
UDP_PAYLOAD = 'A' * 100

def main():
    try:
        f = open(args.f)
        outfile = 'output_' + args.f
    except:
        print('Error opening input file')
        return 1
    fout = open(outfile, 'w')
    ips = f.read().strip().split('\n')
    i = ICMP(code=61)
    for ip in ips:
        print("Scanning " + ip)
        p = sr1(IP(dst=ip)/i, timeout=2, verbose=0) 
        if p == None:
            fout.write(ip + ': Host is down\n')
            continue
        if p.payload.code == 0:
            fout.write(ip + ': Windows\n')
        else:
            u = UDP(dport=4)
            u.add_payload(UDP_PAYLOAD)
            p1 = sr1(IP(dst=ip)/u, timeout=2, verbose=0)
            if p1 == None:
                fout.write(ip + ': Failed to fingerprint\n')
                continue
            if p1.tos == 0xc0:
                assert(type(p1.payload) == scapy.layers.inet.ICMP)
                assert(p1.payload.type == 3) # Destination unreachable
                assert(p1.payload.code == 3) # Port unreachable
                assert(type(p1.getlayer(3)) == scapy.layers.inet.UDPerror)
                if UDP_PAYLOAD.startswith(p1.getlayer(5).load):
                    fout.write(ip + ': Linux\n')
                else:
                    fout.write(ip + ': Others - 1\n')
            else:
                fout.write(ip + ': Others - 2\n')
    fout.close()
    print ("Done. Output written to " + outfile)
    return 0

if __name__ == '__main__':
    main()
