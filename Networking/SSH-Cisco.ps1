# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

# Example - "192.168.0.11"

$IP_Of_Device = Read-Host "What is the IP address of the device you want to SSH to?"

Import-Module -Name Posh-SSH

$SSH_Session = New-SSHSession -ComputerName $IP_Of_Device -AcceptKey -Credential (Get-Credential admin)

$SSH_Stream = $SSH_Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$SSH_Stream.Write("Terminal Length 0 `n")
$SSH_Stream.Write("Show Running-Config `n")
Sleep 5
$SSH_Stream.Read()
