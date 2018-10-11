# CSEC-465-Lab3
Tools for CSEC-465 Lab 03

## DNSEnum

### Usage

```
powershell .\DNS_Enumeration.ps1 <input-file>
Example:
.\DNS_Enumeration.ps1 .\txtFile.txt
google.com: 172.217.15.110
protegototalum.faith: 185.199.108.153,185.199.109.153,185.199.110.153,185.199.111.153
simpleguy.tech: 18.206.31.34
```

## PingSweeper

### Usage

```
./pingsweeper.sh <ip-range>|<ip-subnet>

Example:
./pingsweeper.sh 192.168.1.10-192.168.2.20
./pingsweeper.sh 192.168.10.0/24
```

## OS Fingerprint Tool

### Usage

```
python OSFingerprint.py -f <input-file>
```

Output is saved to `output_<input-file>`

### Credits
Work is based on Ofir Arkin's research on Remote ICMP Based OS Fingerprinting Techniques: https://www.defcon.org/images/defcon-10/dc-10-presentations/dc10-arkin-xprobe.pdf

## PortScanner

### Usage

```
powershell .\PortScanner.ps1 <ip>|<ip-range>|<ip-subnet> <port>|<port-range>|<port-list>
Example:
powershell .\PortScanner.ps1 192.168.10.0/24 22-80
powershell .\PortScanner.ps1 192.168.10.10-192.168.11.2 22,80,455
powershell .\PortScanner.ps1 192.168.10.129 80
```

## Webserver Enumeration

### Usage

```
Usage: python WebserverEnum.py <ip-range>|<ip-subnet>
Example
python WebserverEnum.py 192.168.10.10-192.168.20.1
python WebserverEnum.py 192.168.10.0/24
```
