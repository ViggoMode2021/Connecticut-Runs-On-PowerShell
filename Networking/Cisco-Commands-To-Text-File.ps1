# Install-Module -Name Posh-SSH -RequiredVersion 3.0.8

# Example - "192.168.0.11"

# https://www.netwrix.com/cisco_commands_cheat_sheet.html

if (Get-Module -ListAvailable -Name Posh-SSH) {

    Write-Host ".\Posh-SSH is installed." -ForegroundColor Green

} 
else {

    Write-Host "Posh-SSH is not installed." -ForegroundColor Red

    Install-Module -Name Posh-SSH -RequiredVersion 3.0.8
}

Import-Module -Name Posh-SSH

do {
    
    $IP_Of_Device = Read-Host "What is the IP address of the device you want to SSH to?"

    if ($IP_Of_Device -notmatch "\b(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\b") {

        Write-Host "$IP_Of_Device is not a valid IP address. Please try again." -ForegroundColor Red
        
    }

}

until($IP_Of_Device -match "\b(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\b")

Write-Host "An SSH connection will be established for $IP_Of_Device." -ForegroundColor Green

$SSH_User = Read-Host "Which user will be establishing the SSH connection?"

$SSH_Session = New-SSHSession -ComputerName $IP_Of_Device -AcceptKey -Credential (Get-Credential $SSH_User)

$Cisco_Commands = New-Object System.Collections.Generic.List[String]

$Cisco_Commands.AddRange([String[]]("1.) hostname", 
        "`n2.) show running-config", 
        "`n3.) show running-config interface", 
        "`n4.) show interfaces",
        "`n5.) show vtp status", 
        "`n6.) show running-config",
        "`n7.) show running-config interface", 
        "`n8.) show ip interface",
        "`n9.) show mac address-table",
        "`n10.) show cdp",
        "`n11.) show cdp neighbors",
        "`n12.) show interfaces",
        "`n13.) show interface status",
        "`n14.) show interfaces switchport",
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

$Selected_Command_String = [string]$Selected_Command

$Interface_Commands = "3", "4", "7", "8"

if ($Interface_Commands -contains $Selected_Command_String) {

    $Selected_Interface = Read-Host "Please type interface number."

    $Selected_Command = $Cisco_Commands[$Selected_Command]

    $Remove_Closing_Parenthesis = $Selected_Command.IndexOf(") ")

    $Selected_Command = $Selected_Command + $Selected_Interface

    Write-Host $Selected_Command -ForegroundColor Yellow

    $Selected_Command = $Cisco_Commands[$Selected_Command]

    $Remove_Closing_Parenthesis = $Selected_Command.IndexOf(") ")  

    $Selected_Command = $Selected_Command.Substring($Remove_Closing_Parenthesis + 1)

    Write-Host "Please wait, executing '$Selected_Command' to $IP_Of_Device as $SSH_User...." -ForegroundColor Green

    $SSH_Stream = $SSH_Session.Session.CreateShellStream("", 0, 0, 0, 0, 1000)

    $SSH_Stream.Write("$Selected_Command `n")

    Start-Sleep 5

    $SSH_Stream.Read() | Out-File .\$Selected_Command.txt

}

else {

    $Selected_Command = $Cisco_Commands[$Selected_Command]

    $Remove_Closing_Parenthesis = $Selected_Command.IndexOf(") ")  

    $Selected_Command = $Selected_Command.Substring($Remove_Closing_Parenthesis + 1)

    Write-Host "Please wait, executing $Selected_Command to $IP_Of_Device as $SSH_User...." -ForegroundColor Green

    $SSH_Stream = $SSH_Session.Session.CreateShellStream("", 0, 0, 0, 0, 1000)

    $SSH_Stream.Write("$Selected_Command `n")

    Start-Sleep 5

    $SSH_Stream.Read() | Out-File .\$Selected_Command.txt

}
