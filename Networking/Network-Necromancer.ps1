#https://lazyadmin.nl/it/netsh-wlan-commands/ 

$Current_Date = Get-Date -Format "MM/dd/yyyy" # Get today's date

$DesktopPath = [Environment]::GetFolderPath("Desktop")

$Current_Network = Get-NetConnectionProfile | Select-Object -expand Name

if($Current_Network -eq $null){

$Current_Network = "None"

}

if($Current_Network -notmatch "NordLynx"){

$VPN = "You are not connected to Nord VPN." -ForegroundColor "Red"

}

function Introduction{

Write-Host "#######################################################################################################################################################################################" -ForegroundColor "Green"

$Introduction = Read-Host "Welcome to the Network Necromancer! With this program, you can view, delete, and backup stored networks on your computer. You can also easily connect to a network or view the password
in the event that you may have forgotten it. 

Current Network(s): $Current_Network

$VPN

What would you like to do?

1. View all networks
2. View all networks and passwords
3. Backup all networks to XML files
4. Backup a specific network to XML file
5. Add network with XML file
6. Remove a network
7. Remove multiple networks

Please type the corresponding number here" 

####################################################### First main option ###############################################################

if($Introduction -eq "1"){

$All_Networks = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |
%{[PSCustomObject]@{ Network = $name}} | Format-Table -AutoSize | Out-Host

Write-Host $All_Networks 

$Network_Count = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} |
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Measure-Object | Select-Object -expandproperty Count | Out-String

Write-Host "You currently have $Network_Count `nnetworks on your device." -ForegroundColor "Yellow"

$Introduction_1_Second__Prompt = Read-Host "What would you like to do?

1. View a network's password
2. Remove a network 
3. Go back"

if($Introduction_1_Second__Prompt -eq "1"){

$Network_Password_Viewer = Read-Host "Which network's password would you like to view?"

if($Network_Password_Viewer -notmatch $All_Networks){

Write-Host "$Network_Password_Viewer is not located on the device, please try again."

Introduction

}

netsh wlan show profile name=$Network_Password_Viewer key=clear | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{[PSCustomObject]@{ Network = $Network_Password_Viewer;Password = $pass }} | Format-Table -AutoSize 

Introduction

}

if($Introduction_1_Second__Prompt -eq "2"){

$Network_Remover = Read-Host "Which network would you like to remove?"

if($Network_Remover -notmatch $All_Networks){

Write-Host "$Network_Remover is not located on the device, please try again."

Introduction

}

netsh wlan delete profile name=$Network_Remover

Write-Host "$Network_Remover has been removed from your computer" -ForegroundColor "Yellow"

}

if($Introduction_1_Second__Prompt -eq "3"){

Introduction

}

}

####################################################### Second main option ###############################################################

if($Introduction -eq "2"){

(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Format-Table -AutoSize 

$Network_Count = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} |
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Measure-Object | Select-Object -expandproperty Count | Out-String

Write-Host "You currently have $Network_Count networks on your device." -ForegroundColor "Yellow"

Sleep 2 

Introduction

}

####################################################### Third main option ###############################################################

if($Introduction -eq "3"){

if (Test-Path "XML-Network-Info"){

$Network_Search = Write-Host "All networks will be exported to the 'XML-Network-Info' directory in the same directory as this script." -ForegroundColor "Green"

netsh wlan export profile key=clear folder='XML-Network-Info'

$Total_XML_Files = (Get-ChildItem XML-Network-Info | Measure-Object ).Count;

Write-Host "$Total_XML_Files network XML files exported to the 'XML-Network-Info' directory."

Sleep 5

Introduction

}

else{

New-Item -Path 'XML-Network-Info' -ItemType Directory

Write-Host "All networks will be exported to the 'XML-Network-Info' directory in the same directory as this script. Press any key to continue."

netsh wlan export profile key=clear folder='XML-Network-Info'

$Total_XML_Files = (Get-ChildItem XML-Network-Info | Measure-Object ).Count;

Write-Host "$Total_XML_Files network XML files exported to the 'XML-Network-Info' directory."

Sleep 5

Introduction

}

}

####################################################### Fourth main option ###############################################################

if($Introduction -eq "4"){

$All_Networks = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Format-Table -AutoSize | Out-Host

Write-Host $All_Networks -ForegroundColor "Green"

$Network_To_XML = Read-Host "Which network would you like to backup to an XML file?"

if($Network_To_XML -notmatch $All_Networks){

Write-Host "$Network_To_XML is not located on the device, please try again." -ForegroundColor "Red"

Introduction

}

if (Test-Path "XML-Network-Info"){

$Network_Search = Read-Host "$Network_To_XML will be exported to the 'XML-Network-Info' directory in the same directory as this script. Press any key to continue."

netsh wlan export profile name=$Network_To_XML key=clear folder='XML-Network-Info'

$Total_XML_Files = (Get-ChildItem XML-Network-Info | Measure-Object ).Count;

Write-Host "$Network_To_XML exported to the 'XML-Network-Info' directory."

Sleep 2

Introduction

}

else{

New-Item -Path 'XML-Network-Info' -ItemType Directory

Write-Host "All networks will be exported to the 'XML-Network-Info' directory in the same directory as this script. Press any key to continue."

netsh wlan export profile key=clear folder='XML-Network-Info'

$Total_XML_Files = (Get-ChildItem XML-Network-Info | Measure-Object ).Count;

Write-Host "$Total_XML_Files network XML files exported to the 'XML-Network-Info' directory."

Sleep 5

Introduction

}

}

####################################################### Fifth main option ###############################################################

if($Introduction -eq "5"){

if (Test-Path "XML-Network-Info"){

Set-Location -Path XML-Network-Info

ls 

$Selected_Network_XML_File = Read-Host "Please specify full name of network XML file." 

}

else{ 

$Selected_Network_XML_File = Read-Host "Please specify full path to network XML file."

}

netsh wlan add profile filename=$Selected_Network_XML_File user=current

$Network_Name = Split-Path $Selected_Network_XML_File -Leaf

Write-Host $Network_Name

cd ..

$Connect_Question = Read-Host "Would you like to connect now to $Network_Name? Please type yes or no."

if($Connect_Question -eq "yes"){

$Connect_Name = $Network_Name.replace("Wi-Fi-", "")

$Connect_Name = $Connect_Name.replace(".xml", "")

Write-Host $Connect_Name

netsh wlan connect name=$Connect_Name

}

if($Connect_Question -eq "no"){

Introduction

}

cd .. 

}

####################################################### Sixth main option ###############################################################

if($Introduction -eq "6"){

(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Format-Table -AutoSize 

$Selected_Network_XML_File = Read-Host "Write the name of the network you wish to remove."

netsh wlan delete profile name = $Selected_Network_XML_File

$Network_Count = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} |
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Measure-Object | Select-Object -expandproperty Count | Out-String

Write-Host "You currently have $Network_Count networks on your device." -ForegroundColor "Yellow"

Introduction

}

####################################################### Seventh main option ###############################################################

if($Introduction -eq "7"){

(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | 
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Format-Table -AutoSize 


$Number_Of_Networks_To_Remove = Read-Host "How many networks do you wish to remove?" 

if($Number_Of_Networks_To_Remove -match "^\d+$"){

$Network_Remove_Count = $Number_Of_Networks_To_Remove

$Number_Of_Networks_To_Remove = [int]$Number_Of_Networks_To_Remove

}

else{

$Network_Remove_Count = 2 

Write-Host "You did not input a numerical value. Defaulting to 2." -ForegroundColor "Red"

}

$Network_Remove_Count = $Number_Of_Networks_To_Remove

$Networks = @()

1..$Network_Remove_Count | ForEach-Object {

$Selected_Network_XML_File = Read-Host "Write a name of one of the $Network_Remove_Count networks you wish to remove."

netsh wlan delete profile name = $Selected_Network_XML_File

}

$Networks

$Network_Count = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |
%{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} |
%{[PSCustomObject]@{ Network = $name;Password = $pass }} | Measure-Object | Select-Object -expandproperty Count | Out-String

Write-Host "You currently have $Network_Count networks on your device." -ForegroundColor "Yellow"

}

}

Introduction 
