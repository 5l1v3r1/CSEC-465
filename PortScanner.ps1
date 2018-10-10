$ip = Read-Host -prompt "Enter IP"
$port1 = Read-Host -prompt "Enter start of port range"
$port2 = Read-Host -prompt "Enter end of port range"
while($port1 <= $port2)
{
	try{
	$socket = New-Object System.Net.Socket.TcpClient($ip, $port)
	Write-Host "Open"
	}
	catch[System.Net.Sockets.SocketException]
	{
	Write-Host $_.Exception.ErrorCode
	}
	$port1++
}