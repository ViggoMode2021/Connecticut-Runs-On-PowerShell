# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

# Example - "192.168.0.11"

# https://www.netwrix.com/cisco_commands_cheat_sheet.html

$Cisco_Commands = New-Object System.Collections.Generic.List[String] 
$Cisco_Commands.AddRange([String[]]("1.) hostname", 
        "`n2.) show running-config", 
        "`n3.) show running-config interface ___________", 
        "`n4.) show ip interface ___________",
        "`n5.) show vtp status", 
        "`n6.) show running-config", 
        "`n7.) show running-config interface ___________", 
        "`n8.) show ip interface ___________",
        "`n9.) show mac address-table",
        "`n10.) show cdp",
        "`n11.) show cdp neighbors",
        "`n12.) show interfaces",
        "`n13.) show interface status",
        "`n14.) show inmterfaces switchport",
        "`n15.) show interfaces trunk",
        "`n16.) show vlan",
        "`n17.) show vlan brief",
        "`n18.) show ip route",
        "`n19.) show ip rip database"
    ))

Write-Host $Cisco_Commands -ForegroundColor Green

$Selected_Command = Read-Host "### Please type number of command that you would like to send the results of to a text file. ###"

$Selected_Command = [int]$Selected_Command
$Selected_Command = $Selected_Command - 1
$Selected_Command = $Cisco_Commands[$Selected_Command]
$Remove_Closing_Parenthesis = $Selected_Command.IndexOf(") ")      
$Selected_Command = $Selected_Command.Substring($Remove_Closing_Parenthesis + 1)

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

$SSH_Stream = $SSH_Session.Session.CreateShellStream("", 0, 0, 0, 0, 1000)
$SSH_Stream.Write("$Selected_Command `n")
Start-Sleep 5
$SSH_Stream.Read() | Out-File .\$Selected_Command.txt
