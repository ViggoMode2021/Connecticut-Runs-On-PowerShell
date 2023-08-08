#https://docs.aws.amazon.com/powershell/latest/userguide/pstools-s3-bucket-create.html - Setup

#https://docs.aws.amazon.com/powershell/latest/reference/items/S3_cmdlets.html - Commands

Import-Module AWS.Tools.Common

Write-Host "Welcome to Windows Server backup to AWS S3. With this script, you can backup data from your Windows Server environment to
AWS S3." -ForegroundColor "Green"

$Access_Key = Read-Host "Please put your AWS Access Key here. *Note that your generated AWS credentials should only contain the 'AmazonS3FullAccess'
policy."

$Secret_Access_Key = Read-Host "Please put your AWS Secret Access key here."

Set-AWSCredential -AccessKey $Access_Key -SecretKey $Secret_Access_Key

$Bucket_Name = Read-Host "What would you like to name your s3 bucket?"

New-S3Bucket -BucketName $Bucket_Name -Region us-east-1

$Desktop = [Environment]::GetFolderPath("Desktop")

New-Item -Path $Desktop -Name "Group-Policy-backups" -ItemType "Directory"

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\" -Folder "$Desktop\Group-Policy-backups"

Backup-GPO -All -Path C:\Users\Administrator\desktop\Group-Policy-backups

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\Group-Policy-backups" -Folder "C:\Users\Administrator\desktop\Group-Policy-backups" -Recurse
