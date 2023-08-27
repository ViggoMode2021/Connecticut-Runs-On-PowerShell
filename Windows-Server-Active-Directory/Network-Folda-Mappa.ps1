# Folder mapper # Reference https://www.youtube.com/watch?v=OVln4mAqP30

#https://winaero.com/enable-disable-inherited-permissions-windows-10/

<#

Remove-PSDrive -Name M

Remove-PSDrive -Name H

net use * /delete



#>

# Get-ADGroup -Filter "*" | Remove-ADGroup

# Get-ADGroup -Filter 'Name -like "Faculty-Share"' | Remove-ADGroup

# Steps:

#------------------------------------#

# 1.) Create security groups 

# 2.) Create folder

# 3.) Create SMB share 

# 4.) Map with letters

#------------------------------------#

$Domain = Get-ADDomain | Select -expand Name

New-ADGroup -Name MathFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Filter {Description -like "Math"} | % { Add-ADGroupMember 'MathFileShare' -Members $_ }

Write-Host "Creating Math fileshare" -ForegroundColor "Green"

New-ADGroup -Name HistoryFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Filter {Description -like "History"} | % { Add-ADGroupMember 'HistoryFileShare' -Members $_ }

New-Item -Type Directory -Name Math-FileShare -Path "C:\"

$Math_ACL = Get-ACL -Path C:\Math-FileShare

$Math_FileShare_Permissions = @("Administrators", "MathFileShare")

$Math_Folder_Permission = New-Object System.Security.AccessControl.FileSystemAccessRule("MathFileShare", "Read,Write", "ContainerInherit,ObjectInherit", "None", "Allow")

$Math_ACL.SetAccessRule($Math_Folder_Permission)

New-Item -Type Directory -Name History-FileShare -Path "C:\"

New-SMBShare `
    –Name Math-FileShare `
    –Path 'C:\Math-FileShare' ` `
    –FullAccess MathFileShare, Administrators ` 

$Hostname = hostname

New-PSDrive -Name "M" -PSProvider "FileSystem" -Root "\\$Hostname\Math-FileShare" -Persist

New-SMBShare `
    –Name History-FileShare `
    –Path 'C:\History-FileShare' ` `
    –FullAccess HistoryFileShare, Administrators ` 

New-PSDrive -Name "H" -PSProvider "FileSystem" -Root "\\$Hostname\History-FileShare" -Persist

Write-Host "Creating History fileshare" -ForegroundColor "Green"

$Math_Faculty = Get-ADUser -Filter {Description -like "Math"} | Select -expand SamAccountName

foreach ($Member in $Math_Faculty){

Write-Host $Member

Set-ADUser -Identity $Member -HomeDirectory "\\$Hostname\Math-FileShare\$Member" -HomeDrive M;

}

$History_Faculty = Get-ADUser -Filter {Description -like "History"} | Select -expand SamAccountName

foreach ($Member in $History_Faculty){

Write-Host $Member

Set-ADUser -Identity $Member -HomeDirectory "\\$Hostname\History-FileShare\$Member" -HomeDrive H;

}

<#


#Unhide 


$folder = Get-Item C:\History-FileShare -Force
$folder.Attributes = $folder.Attributes -band -bnot [System.IO.FileAttributes]::Hidden

$folder = Get-Item C:\Math-FileShare -Force
$folder.Attributes = $folder.Attributes -band -bnot [System.IO.FileAttributes]::Hidden

#>
