function Export-DHCP-DNS-Server{

$BackupRoot = ""

$Today = Get-Date -Format "MM-dd-yyyy"

$BackupPath = "$BackupRoot\$Today"

$DHCP_DNS_Server = ""

# Create daily folder
New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null

# Export DHCP
Export-DhcpServer -ComputerName $DHCP_DNS_Server -File "$BackupPath\DHCPConfig.xml" -Leases -Force

$scopes = Get-DhcpServerv4Scope -ComputerName $DHCP_DNS_Server
$scopeCount = $scopes.Count

# Count reservations
$reservations = Get-DhcpServerv4Reservation -ComputerName $DHCP_DNS_Server -ScopeId $scopes.ScopeId
$resCount = $reservations.Count

# Count leases
$leases = Get-DhcpServerv4Lease -ComputerName $DHCP_DNS_Server
$leaseCount = $leases.Count

Write-Output "✅ DHCP Export Complete for $DHCP_DNS_Server':'"
Write-Output "   Scopes: $scopeCount"
Write-Output "   Reservations: $resCount"
Write-Output "   Leases: $leaseCount"

# Export DNS
Get-DnsServerZone -ComputerName $DHCP_DNS_Server | ForEach-Object {
    $zoneName = $_.ZoneName
    Get-DnsServerResourceRecord -ZoneName $zoneName -ComputerName "$DHCP_DNS_Server" |
        Export-Csv "$BackupPath\DNS_$zoneName.csv" -NoTypeInformation

    $count = $records.Count
    $totalDnsRecords += $count

    Write-Output "   Zone $zoneName → $count records on $DHCP_DNS_Server"
}

# Cleanup old backups (older than 30 days)
Get-ChildItem $BackupRoot | Where-Object { $_.PSIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Recurse -Force

}

Export-DHCP-DNS-Server
