#DNS Enumeration

$txtFile = Read-Host "Enter a file path"

foreach($line in Get-Content $txtFile) {
	if($line -match $regex) {
		Resolve-DnsName $line
	}
}
