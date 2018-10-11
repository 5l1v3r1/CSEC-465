# Getting IP range
$ips = $args[0]
$rangeIdx = $ips.ToString().IndexOf('-')
$networkIdx = $ips.ToString().IndexOf('/')

If ($rangeIdx -ne -1 -and $networkIdx -ne -1) {
    echo "Unrecognized IP format"
} ElseIf($rangeIdx -ne -1) {
    $ips = $ips.ToString().Split('-')
    $startIP = ([IPAddress]$ips[0]).GetAddressBytes()
    [Array]::Reverse($startIP)
    $startIP = [uint32]([IPAddress]$startIP).Address
    $endIP = ([IPAddress]$ips[1]).GetAddressBytes()
    [Array]::Reverse($endIP)
    $endIP = [uint32]([IPAddress]$endIP).Address
} ElseIf($networkIdx -ne -1) {
    $ips = $ips.ToString().Split('/')
    $network = $ips[0]
    $netmask = $ips[1]
    $network = ([IPAddress]$network).GetAddressBytes()
    [Array]::Reverse($network)
    $network = [uint32]([IPAddress]$network).Address
    $startIP = $network
    $endIP = $startIP -bor (([uint32]1 -shl (32 - [uint32]$netmask)) - 1)
} Else {
    $startIP = ([IPAddress]$ips).GetAddressBytes()
    [Array]::Reverse($startIP)
    $startIP = [uint32]([IPAddress]$startIP).Address
    $endIP = ([IPAddress]$ips).GetAddressBytes()
    [Array]::Reverse($endIP)
    $endIP = [uint32]([IPAddress]$endIP).Address
} 

# Getting port range
If ($args.Length -lt 2) {
    echo "No ports specified"
    exit(1)
}
$portRangeIdx = $args[1].ToString().IndexOf('-')
$portListIdx = $args[1].ToString().IndexOf(',')

If ($portRangeIdx -ne -1) {
    $portrange = $args[1].ToString().Split('-')
    $startPort = [int]$portrange[0]
    $endPort = [int]$portrange[1]
} ElseIf ($portListIdx -ne -1) {
    $portList = $args[1].ToString().Split(',')
} Else {
    $portListIdx = 0
    $portList = $args[1]
}

$result = "`nResult:`n"

For($ip = [uint32]$startIP ; $ip -lt ([uint32]$endIP + 1); $ip++) {
    $ip1 = ([IPAddress]$ip).GetAddressBytes()
    [Array]::Reverse($ip1)
    $ip1 = ([IPAddress]$ip1).IPAddressToString
    ping -n 1 -w 100 $ip1 | Out-Null
    If ($? -eq $False) {
        echo "$ip1 is down"
        Continue
    }
    echo "Scanning $ip1"
    $resultString = "${ip1}: "
    If ($portRangeIdx -ne -1) {
        For($port = $startPort; $port -lt ($endPort + 1); $port++) {
            #echo "Scanning $port"
            Try {
                $socket = New-Object System.Net.Sockets.TcpClient($ip1, $port)
                echo "Port $port is open"
                $resultString += "$port "
                $socket.Close()
	        } Catch [System.Net.Sockets.SocketException] {
                $errorCode = $_.Exception.InnerException.ErrorCode
                If ($errorCode -eq 10061) {
                    echo "Port $port is closed"
                } ElseIf ($errorCode -eq 10060) {
                    echo "Port $port is filtered"
                }
	        }
        }
    } ElseIf ($portListIdx -ne -1) {
        foreach($port in $portList) {
            #echo "Scanning $port"
            Try {
                $socket = New-Object System.Net.Sockets.TcpClient($ip1, $port)
                echo "Port $port is open"
                $resultString += "$port "
                $socket.Close()
	        } Catch [System.Net.Sockets.SocketException] {
                $errorCode = $_.Exception.InnerException.ErrorCode
                If ($errorCode -eq 10061) {
                    echo "Port $port is closed"
                } ElseIf ($errorCode -eq 10060) {
                    echo "Port $port is filtered"
                }
	        }
        }
    }
    $result += $resultString + "`n"
}
echo $result