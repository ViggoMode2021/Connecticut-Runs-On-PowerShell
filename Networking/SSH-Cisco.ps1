# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

# Example - "192.168.0.11"

Import-Module -Name Posh-SSH

$IP_Of_Device = Read-Host "What is the IP address of the device you want to SSH to?"

$SSH_Session = New-SSHSession -ComputerName $IP_Of_Device -AcceptKey -Credential (Get-Credential admin)

$SSH_Stream = $SSH_Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$SSH_Stream.Write("Show Running-Config `n")
$SSH_Stream.Write(" ")
$SSH_Stream.Write(" ")
$SSH_Stream.Write(" ")
Sleep 5
$SSH_Stream.Read() | Out-File .\cisco.txt
