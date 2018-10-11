#DNS Enumeration

$txtFile = $args[0]
$result = ""

foreach($line in Get-Content $txtFile) {
	if($line -match $regex) {
        $resulthost = "${line}: "
		$resolved = Resolve-DnsName -Type A $line | select -ExpandProperty Address
        $resulthost += $resolved -join ","
        $result += $resulthost + "`n"
	}
}

Write-Host $result
