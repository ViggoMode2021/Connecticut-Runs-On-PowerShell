# This script sets up a Windows Server custom image

# Part one

## https://techgenix.com/active-directory-infrastructure-in-aws-ec2/ ##

function Setup_Windows_Firewall_Custom_Rules{

# FireShell

# This script will recursively block all IP addresses associated with the websites below. 

# You can view and alter these settings via Windows Defender Firewall with Advanced Security.

$Adult_Websites = "pornhub.com", "xvideos.com", "xnxx.com", "youporn.com", "xhamster.com", "hqporner.com",  "pornpics.com"

foreach ($Website in $Adult_Websites){

$IP_Addresses = Resolve-DnsName $Website | Select -Expand IPAddress

$IP_Count = $IP_Addresses | Measure-Object | Select -expand Count

Write-Host "Blocking all $IP_Count IP addresses associated with $Website." -ForeGroundColor "Cyan"

foreach ($IP in $IP_Addresses){

New-NetFirewallRule -DisplayName "Block $Website HTTPS" -Direction Outbound -RemotePort 443 -Protocol TCP -Action Block -RemoteAddress $IP

Write-Host "Successfully blocked $Website" -ForeGroundColor "Green"

}

}

$Social_Media_Webistes = "facebook.com", "instagram.com", "myspace.com", "linkedin.com", "discord.com", "reddit.com", "4chan.com"

foreach ($Website in $Social_Media_Webistes){

$IP_Addresses = Resolve-DnsName $Website | Select -Expand IPAddress

$IP_Count = $IP_Addresses | Measure-Object | Select -expand Count

Write-Host "Blocking all $IP_Count IP addresses associated with $Website." -ForeGroundColor "Cyan"

foreach ($IP in $IP_Addresses){

New-NetFirewallRule -DisplayName "Block $Website HTTPS" -Direction Outbound -RemotePort 443 -Protocol TCP -Action Block -RemoteAddress $IP

Write-Host "Successfully blocked $Website" -ForeGroundColor "Green"

}

}

}

Setup_Windows_Firewall_Custom_Rules

## Part two

function Install_Chocolatey {

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

}

Install_Chocolatey

# Part three 

Write-Host 'Please allow several minutes for the install to complete. '


# Install Google Chrome x64 on 64-Bit systems? $True or $False
$Installx64 = $True

# Define the temporary location to cache the installer.
$TempDirectory = "$ENV:Temp\Chrome"

# Run the script silently, $True or $False
$RunScriptSilent = $True

# Set the system architecture as a value.
$OSArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

# Exit if the script was not run with Administrator priveleges
$User = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if (-not $User.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )) {
	Write-Host 'Please run again with Administrator privileges.' -ForegroundColor Red
    if ($RunScriptSilent -NE $True){
        Read-Host 'Press [Enter] to exit'
    }
    exit
}


Function Download-Chrome {
    Write-Host 'Downloading Google Chrome... ' -NoNewLine

    # Test internet connection
    if (Test-Connection google.com -Count 3 -Quiet) {
		if ($OSArchitecture -eq "64-Bit" -and $Installx64 -eq $True){
			$Link = 'http://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi'
		} ELSE {
			$Link = 'http://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi'
		}
    

        # Download the installer from Google
        try {
	        New-Item -ItemType Directory "$TempDirectory" -Force | Out-Null
	        (New-Object System.Net.WebClient).DownloadFile($Link, "$TempDirectory\Chrome.msi")
            Write-Host 'success!' -ForegroundColor Green
        } catch {
	        Write-Host 'failed. There was a problem with the download.' -ForegroundColor Red
            if ($RunScriptSilent -NE $True){
                Read-Host 'Press [Enter] to exit'
            }
	        exit
        }
    } else {
        Write-Host "failed. Unable to connect to Google's servers." -ForegroundColor Red
        if ($RunScriptSilent -NE $True){
            Read-Host 'Press [Enter] to exit'
        }
	    exit
    }
}

Function Install-Chrome {
    Write-Host 'Installing Chrome... ' -NoNewline

    # Install Chrome
    $ChromeMSI = """$TempDirectory\Chrome.msi"""
	$ExitCode = (Start-Process -filepath msiexec -argumentlist "/i $ChromeMSI /qn /norestart" -Wait -PassThru).ExitCode
    
    if ($ExitCode -eq 0) {
        Write-Host 'success!' -ForegroundColor Green
    } else {
        Write-Host "failed. There was a problem installing Google Chrome. MsiExec returned exit code $ExitCode." -ForegroundColor Red
        Clean-Up
        if ($RunScriptSilent -NE $True){
            Read-Host 'Press [Enter] to exit'
        }
	    exit
    }
}

Function Clean-Up {
    Write-Host 'Removing Chrome installer... ' -NoNewline

    try {
        # Remove the installer
        Remove-Item "$TempDirectory\Chrome.msi" -ErrorAction Stop
        Write-Host 'success!' -ForegroundColor Green
    } catch {
        Write-Host "failed. You will have to remove the installer yourself from $TempDirectory\." -ForegroundColor Yellow
    }
}

Download-Chrome
Install-Chrome
Clean-Up

if ($RunScriptSilent -NE $True){
    Read-Host 'Install complete! Press [Enter] to exit'
}

Sleep 2

function Custom_Registry_Edits {

New-Item -Path "HKCR:\Directory\Background\shell" -Name "Check Email" 

New-Item -Path "HKCR:\Directory\Background\shell\Check Email" -Name "command" 

New-ItemProperty -Path "HKCR:\Directory\Background\shell\Check Email\command" -Name "(Default)" -Value '"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "gmail.com"' -Type String

##

}

Custom_Registry_Edits

Rename-Computer -NewName "vigschools-domain-controller"

Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

$Install_ADDS_Params = @{
    CreateDnsDelegation           = $False
    DatabasePath                  = "C:\Windows\NTDS"
    DomainMode                    = "WinThreshold"
    DomainName                    = "vigschools.org"
    DomainNetbiosName             = "vigschools"
    SafeModeAdministratorPassword = (ConvertTo-SecureString -String "!" -AsPlainText -Force)
    ForestMode                    = "WinThreshold"
    InstallDns                    = $True
    LogPath                       = "C:\Windows\NTDS"
    NoRebootOnCompletion          = $False
    SysvolPath                    = "C:\Windows\SYSVOL"
    Force                         = $True

Install-ADDSForest @Install_ADDS_Params 
