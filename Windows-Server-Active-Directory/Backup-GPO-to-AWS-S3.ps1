#https://docs.aws.amazon.com/powershell/latest/userguide/pstools-s3-bucket-create.html

Import-Module AWS.Tools.Common

#Set-AWSCredential -AccessKey "" -SecretKey "" # Put AWS keys here if needed

$Bucket_Name = Read-Host "What would you like to name your s3 bucket?"

New-S3Bucket -BucketName $Bucket_Name -Region us-east-1

$Desktop = [Environment]::GetFolderPath("Desktop")

New-Item -Path $Desktop -Name "Group-Policy-backups" -ItemType "Directory"

Backup-GPO -All -Path C:\Users\Administrator\desktop\Group-Policy-backups

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\" -Folder "C:\Users\Administrator\desktop\Group-Policy-backups" -Recurse
