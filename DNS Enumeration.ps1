#DNS Enumeration

$txtFile = Read-Host "Enter a file path"

foreach($line in Get-Content $txtFile) {
	if($line -match $regex) {
		[System.Net.Dns]::GetHostAddresses($line)
		#Resolve-DnsName $line
	}
}
