# Folder mapper # Reference https://www.youtube.com/watch?v=OVln4mAqP30

$Domain = Get-ADDomain | Select -expand Name

Get-ADUser -Properties Description -Filter {Description -like "Math"} -SearchBase

New-ADGroup -Name Math-FileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

Get-ADUser -Properties Description -Filter {Description -like "History"} -SearchBase

New-ADGroup -Name History-FileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

New-ADGroup -Name Faculty-FileShare -GroupCategory Security -GroupScope DomainLocal -Path "OU=FacultyAccounts,DC=$Domain,DC=org"

New-Item -Type Directory -Name Faculty-FileShares -Path "C:\"

New-SMBShare `
    –Name Faculty-FileShares `
    –Path 'C:\Faculty-FileShares' ` `
    –FullAccess Faculty-FileShare ` 

$Hostname = hostname

New-PSDrive -Name "L" -PSProvider "FileSystem" -Root "\\$Hostname\Faculty-FileShares" -Persist
