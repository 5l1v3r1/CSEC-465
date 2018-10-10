$ip = Read-Host -prompt "Enter IP"
$port1 = Read-Host -prompt "Enter start of port range"
$port2 = Read-Host -prompt "Enter end of port range"
$port1i = [int]$port1
$port2i = [int]$port2
while($port1i -lt ($port2i + 1))
{
    try
    {
        $socket = New-Object System.Net.Sockets.TcpClient($ip, $port1i)
        Write-Host "Port: ", [str]$port1i, " Open"
        $socket.Close()
	}
	catch [System.Net.Sockets.SocketException]
	{
        continue
	}
    finally
    {
        $port1i++
    }
}