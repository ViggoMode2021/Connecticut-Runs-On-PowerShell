# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

$IP = "192.168.0.11"

Import-Module -Name Posh-SSH

$SSHSession = New-SSHSession -ComputerName $IP -AcceptKey -Credential (Get-Credential admin)

$stream = $SSHSession.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("Terminal Length 0 `n")
$stream.Write("Show Running-Config `n")
Sleep 5
$stream.read()
