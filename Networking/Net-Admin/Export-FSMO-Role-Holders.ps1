# Save FSMO role holders
$Domain = Get-ADDomain
$Forest = Get-ADForest

@"
Domain Naming Master: $($Forest.DomainNamingMaster)
Schema Master: $($Forest.SchemaMaster)
PDC Emulator: $($Domain.PDCEmulator)
RID Master: $($Domain.RIDMaster)
Infrastructure Master: $($Domain.InfrastructureMaster)
"@ | Out-File "\Backups\FSMO_Roles.txt"
