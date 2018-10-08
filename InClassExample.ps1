$ip = Read-Host -prompt "Enter IP"
$port = Read-Host -prompt "Enter port"
try{
$socket = New-Object System.Net.Socket.TcpClient($ip, $port)
Write-Host "Open"
}
catch[System.Net.Sockets.SocketException]
{
Write-Host $_.Exception.ErrorCode
}