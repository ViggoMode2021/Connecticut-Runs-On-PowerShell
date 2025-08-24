# List of Domain Controllers to audit
$DCs = @("DC1","DC2")  # Replace with your DC hostnames

# Array to store results
$Report = @()

foreach ($DC in $DCs) {
    Write-Host "Auditing $DC..." -ForegroundColor Cyan

    # Patch info
    $HotFixes = Get-HotFix -ComputerName $DC | Sort-Object InstalledOn -Descending
    $LastPatchDate = if ($HotFixes) { $HotFixes[0].InstalledOn } else { "Unknown" }

    # Replication check
    $ReplStatus = & repadmin /replsummary $DC 2>&1
    $ReplicationHealthy = if ($ReplStatus -match "Failed") { "Issues Detected" } else { "Healthy" }

    # SYSVOL and DNS check using dcdiag
    $DCDiag = & dcdiag /s:$DC /q 2>&1
    $SysvolStatus = if ($DCDiag -match "SYSVOL.*passed") { "Healthy" } else { "Check SYSVOL" }
    $DNSStatus = if ($DCDiag -match "DNS.*passed") { "Healthy" } else { "Check DNS" }

    # Disk space check (C: drive only, adjust if needed)
    $Disk = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $DC -Filter "DeviceID='C:'"
    $DiskFreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $DiskTotalGB = [math]::Round($Disk.Size / 1GB, 2)

    # FSMO roles
    $FSMORoles = netdom query fsmo

    # Backup status (requires Windows Server Backup)
    $BackupStatus = "Not Checked"
    try {
        $BackupStatus = Get-WBJob -ComputerName $DC -ErrorAction Stop | Select-Object -First 1 -ExpandProperty Status
    } catch { $BackupStatus = "Backup Module Not Available" }

    # Add to report
    $Report += [PSCustomObject]@{
        DomainController = $DC
        LastPatchDate    = $LastPatchDate
        Replication      = $ReplicationHealthy
        SYSVOL           = $SysvolStatus
        DNS              = $DNSStatus
        DiskFreeGB       = $DiskFreeGB
        DiskTotalGB      = $DiskTotalGB
        FSMORoles        = ($FSMORoles -join ", ")
        BackupStatus     = $BackupStatus
    }
}

# Export report to CSV
$OutputFile = "C:\DC_Health_Report.csv"
$Report | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "Audit complete! Report saved to $OutputFile" -ForegroundColor Green
