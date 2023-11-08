Install-Module -Name Net.SSH

# Import the Net.SSH module
Import-Module Net.SSH

# Define the Cisco device details
$DeviceIP = Read-Host "Specify the device IP"
$Username = Read-Host "Specify the SSH username"
$Password = Read-Host "Specify the SSH password"
$ConfigFilePath = [Environment]::GetFolderPath("Desktop")

# Create an SSH client session
$session = New-SshSession -ComputerName $DeviceIP -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $Username, (ConvertTo-SecureString -String $Password -AsPlainText -Force))

# Execute the command to retrieve the configuration
$Config = Invoke-SshCommand -SessionId $session -Command "show running-config"

# Store the configuration in a text file
$Config | Out-File -FilePath $ConfigFilePath

# Close the SSH session
Remove-SshSession -SessionId $session

Write-Host "Configuration backup completed. The configuration is saved in $ConfigFilePath"

