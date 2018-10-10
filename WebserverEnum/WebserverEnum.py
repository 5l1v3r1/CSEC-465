from __future__ import print_function
import requests
import ipaddress
import sys

def main():
    if len(sys.argv) != 2:
        print("Usage: python {} <ip-range>|<ip-subnet>".format(sys.argv[0]))
        print("Example")
        print("python {} 192.168.10.10-192.168.20.1".format(sys.argv[0]))
        print("python {} 192.168.10.0/24".format(sys.argv[0]))
        return 1
    if sys.argv[1].find('/') != -1 and sys.argv[1].find('-') != -1:
        print("uncognized format")
        return 1
    elif sys.argv[1].find('/') != -1:
        network = ipaddress.ip_network(unicode(sys.argv[1]))
        for ip in network:
            print(ip)        
    elif sys.argv[1].find('-') != -1:
        ips = sys.argv[1].split('-')
        iprange = ipaddress.summarize_address_range(ipaddress.ip_address(unicode(ips[0])), ipaddress.ip_address(unicode(ips[1])))
        while True:
            try:
                network = iprange.next()
                for ip in network:
                    print(ip)
            except:
                break
    else:
        print("unrecognized format")
        return 1

if __name__ == '__main__':
    main()
