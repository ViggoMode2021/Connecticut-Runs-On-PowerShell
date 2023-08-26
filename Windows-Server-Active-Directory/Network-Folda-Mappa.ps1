# Folder mapper # Reference https://www.youtube.com/watch?v=OVln4mAqP30

# Remove-PSDrive -Name M

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


New-ADGroup -Name HistoryFileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Filter {Description -like "History"} | % { Add-ADGroupMember 'HistoryFileShare' -Members $_ }


New-Item -Type Directory -Name Math-FileShare -Path "C:\"

New-Item -Type Directory -Name History-FileShare -Path "C:\"

New-SMBShare `
    –Name Math-FileShare `
    –Path 'C:\Math-FileShare' ` `
    –FullAccess MathFileShare ` 

$Hostname = hostname

New-PSDrive -Name "M" -PSProvider "FileSystem" -Root "\\$Hostname\Math-FileShare" -Persist

New-SMBShare `
    –Name History-FileShare `
    –Path 'C:\History-FileShare' ` `
    –FullAccess HistoryFileShare ` 

New-PSDrive -Name "H" -PSProvider "FileSystem" -Root "\\$Hostname\History-FileShare" -Persist
