# PortScanner

## Usage

```
powershell .\PortScanner.ps1 <ip>|<ip-range>|<ip-subnet> <port>|<port-range>|<port-list>
Example:
powershell .\PortScanner.ps1 192.168.10.0/24 22-80
powershell .\PortScanner.ps1 192.168.10.10-192.168.11.2 22,80,455
powershell .\PortScanner.ps1 192.168.10.129 80
```