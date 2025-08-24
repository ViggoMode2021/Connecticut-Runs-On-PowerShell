$ADExportDir = "\Backups\AD_Objects\$(Get-Date -Format yyyy-MM-dd)"
New-Item -ItemType Directory -Path $ADExportDir -Force | Out-Null

# Export OUs
Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName |
    Export-Csv "$ADExportDir\OUs.csv" -NoTypeInformation

# Export Users
Get-ADUser -Filter * -Properties * |
    Select-Object SamAccountName, Name, Enabled, DistinguishedName, EmailAddress |
    Export-Csv "$ADExportDir\Users.csv" -NoTypeInformation

# Export Groups
Get-ADGroup -Filter * -Properties * |
    Select-Object Name, GroupScope, Members, DistinguishedName |
    Export-Csv "$ADExportDir\Groups.csv" -NoTypeInformation
