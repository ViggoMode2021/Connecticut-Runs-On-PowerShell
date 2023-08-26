# Folder mapper # Reference https://www.youtube.com/watch?v=OVln4mAqP30

# Remove-PSDrive -Name L

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

New-ADGroup -Name MathFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org" | Get-ADUser -Properties Description -Filter {Description -like "History"} -SearchBase "OU=FacultyAccounts,DC=$Domain,DC=org" | ForEach-Object { Add-ADGroupMember -Identity $_.SamAccountName -Members $_ }

New-ADGroup -Name HistoryFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Properties Description -Filter {Description -like "Math"} -SearchBase 


New-ADGroup -Name HistoryFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Filter {Description -like "History"} | % { Add-ADGroupMember 'HistoryFileShare' -Members $_ }




New-Item -Type Directory -Name Math-FileShare -Path "C:\"

New-Item -Type Directory -Name History-FileShare -Path "C:\"

New-SMBShare `
    –Name Faculty-FileShares `
    –Path 'C:\Faculty-FileShares' ` `
    –FullAccess Faculty-FileShare ` 

$Hostname = hostname

New-PSDrive -Name "L" -PSProvider "FileSystem" -Root "\\$Hostname\Faculty-FileShares" -Persist
