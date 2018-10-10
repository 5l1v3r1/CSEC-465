#DNS Enumeration

foreach($line in Get-Content C:\Users\castr\txtFile.txt) {
	if($line -match $regex) {
		Resolve-DnsName $line
	}
}
