#DNS Enumeration

$Text = Get-Content -Path txtFile.txt
$Text.GetType() | Format-Table -AutoSize

for($i = 0; $i -lt $name.length; i++) {
	Resolve-DnsName "Name: $name[i]"
}
