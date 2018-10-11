from __future__ import print_function
import requests
import ipaddress
import sys
import multiprocessing
import subprocess

pingTimeout = 0.1
scanTimeout = 0.1
#ports = [80, 443]
ports = range(1000)
nprocs = 10

def scan(args):
    port = args[1]
    ip = args[0]
#    print("Scanning " + str(args))
    try:
        r = requests.get('http://{}:{}'.format(ip, port), timeout=scanTimeout)
        return port
    except:
        return None

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
            try:
                subprocess.check_call('timeout {} ping -c 1 {} >/dev/null 2>&1'.format(pingTimeout, ip), shell=True)
            except:
                continue
            print("Scanning " + str(ip))
            pool = multiprocessing.Pool(processes=nprocs)
            for res in pool.map(scan, [(str(ip), port) for port in ports]):
                if res:
                    print(res)
            pool.close()
            pool.join()
    elif sys.argv[1].find('-') != -1:
        ips = sys.argv[1].split('-')
        iprange = ipaddress.summarize_address_range(ipaddress.ip_address(unicode(ips[0])), ipaddress.ip_address(unicode(ips[1])))
        while True:
            try:
                network = iprange.next()
                for ip in network:
                    try:
                        subprocess.check_call('timeout {} ping -c 1 {} >/dev/null 2>&1'.format(pingTimeout, ip), shell=True)
                    except:
                        continue
                    print("Scanning " + str(ip))
                    pool = multiprocessing.Pool(processes=nprocs)
                    for res in pool.imap_unordered(scan, [(str(ip), port) for port in ports]):
                        if res:
                            print(res)
                    pool.close()
                    pool.join()
            except:
                break
    else:
        ip = sys.argv[1]
        try:
            subprocess.check_call('timeout {} ping -c 1 {} >/dev/null 2>&1'.format(pingTimeout, ip), shell=True)
        except:
            pass
        print("Scanning " + str(ip))
        pool = multiprocessing.Pool(processes=nprocs)
        for res in pool.imap_unordered(scan, [(str(ip), port) for port in ports]):
            if res:
                print(res)
        pool.close()
        pool.join()

if __name__ == '__main__':
    main()
