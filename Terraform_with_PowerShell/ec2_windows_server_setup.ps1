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

Install-ADDSForest -DomainName vigschools.org -InstallDNS

Restart-Computer -Wait

Import-Module ActiveDirectory

$vigschools = "vigschools"

$DC = "vigschools"

$Domain = "@vigschools.org"

$StudentAccounts = "StudentAccounts"

$HighSchool = "HighSchool"

$MiddleSchool = "MiddleSchool"

$ElementarySchool = "ElementarySchool"

$FacultyAccounts = "FacultyAccounts"

$OrganizationalUnits = @("StudentAccounts", "HighSchoolStudents", "ClassOf2023", "ClassOf2024", "ClassOf2025", "ClassOf2026", "ClassOf2027",
"MiddleSchoolStudents", "ClassOf2027", "ClassOf2028", "ClassOf2029", "ClassOf2030", "ElementarySchoolStudents", "ClassOf2031", "ClassOf2032", "ClassOf2033", "ClassOf2034",
"FacultyAccounts", "HighSchoolFaculty", "MiddleSchoolFaculty", "ElementarySchoolFaculty")

function CheckOU{
    foreach ($OU in $OrganizationalUnits){
        if (Get-ADOrganizationalUnit -Filter 'Name -like $OU' | Format-Table Name, DistinguishedName -A) {
            Write-Host "$OU already exists."
}
else {

Write-Host "Creating OU named $OU"
}

}
}

CheckOU

# Add student OUs below:

New-ADOrganizationalUnit -Name "StudentAccounts" -Path "DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "HighSchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2023" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2024" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2025" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2026" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "MiddleSchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2027" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2028" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2029" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2030" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ElementarySchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2031" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2032" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2033" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2034" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

#Add faculty OUs below:

New-ADOrganizationalUnit -Name "FacultyAccounts" -Path "DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "HighSchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "MiddleSchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ElementarySchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

# Logic to add CSV-Users to CSV

# CSV URLs

$HighSchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/teacher-names.csv"

$MiddleSchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/middle-school-teacher-names.csv"

$ElementarySchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/elementary-school-teacher-names.csv"

$ClassOf2023StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2023-student-names.csv" # HS

$ClassOf2024StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2024-student-names.csv" # HS

$ClassOf2025StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2025-student-names.csv" # HS

$ClassOf2026StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2026-student-names.csv" # HS

$ClassOf2027StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2027-student-names.csv" # MS

$ClassOf2028StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2028-student-names.csv" # MS

$ClassOf2029StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2029-student-names.csv" # MS

$ClassOf2030StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2030-student-names.csv" # MS

$ClassOf2031StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2031-student-names.csv" # ES

$ClassOf2032StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2032-student-names.csv" # ES

$ClassOf2033StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2033-student-names.csv" # ES

$ClassOf2034StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2034-student-names.csv" # ES

$ClassOf2035StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2035-student-names.csv" # ES

# High School Faculty:

New-Item -Path 'C:\Users\Administrator\Desktop\CSV-Data' -ItemType Directory

Invoke-WebRequest $HighSchoolFacultyNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\HighSchoolTeachers.csv
