# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

# Example - "192.168.0.11"

$list = New-Object System.Collections.Generic.List[String] 
$list.AddRange([String[]]("1.) Hostname", "`n2.) Show Running-Config", "`n3.) show running-config interface ___________", "`n4.) show ip interface _________________"))
Write-Host $List 
$list[1] 

if (Get-Module -ListAvailable -Name Posh-SSH) {
    Write-Host "Posh-SSH is installed." -ForegroundColor Green
} 
else {
    Write-Host "Posh-SSH is not installed." -ForegroundColor Red
    Install-Module -Name Posh-SSH -RequiredVersion 3.0.8
}

Import-Module -Name Posh-SSH

$IP_Of_Device = Read-Host "What is the IP address of the device you want to SSH to?"

$SSH_Session = New-SSHSession -ComputerName $IP_Of_Device -AcceptKey -Credential (Get-Credential admin)

$SSH_Stream = $SSH_Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$SSH_Stream.Write("Show Running-Config `n")
Start-Sleep 5
$SSH_Stream.Read() | Out-File .\cisco.txt
