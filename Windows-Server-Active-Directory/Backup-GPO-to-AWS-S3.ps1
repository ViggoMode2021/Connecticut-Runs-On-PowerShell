#https://docs.aws.amazon.com/powershell/latest/userguide/pstools-s3-bucket-create.html - Setup

#https://docs.aws.amazon.com/powershell/latest/reference/items/S3_cmdlets.html - Commands

Import-Module AWS.Tools.Common

Write-Host "Welcome to Windows Server backup to AWS S3. With this script, you can backup data from your Windows Server environment to
AWS S3." -ForegroundColor "Green"

$Access_Key = Read-Host "Please put your AWS Access Key here. *Note that your generated AWS credentials should only contain the 'AmazonS3FullAccess'
policy."

$Secret_Access_Key = Read-Host "Please put your AWS Secret Access key here."

Set-AWSCredential -AccessKey $Access_Key -SecretKey $Secret_Access_Key

do{

$Bucket_Name = Read-Host "What would you like to name your s3 bucket?"

if(Test-S3Bucket -BucketName $Bucket_Name){

Write-Host "Bucket named $Bucket_Name already exists." -ForegroundColor Red

}

}

until(!(Test-S3Bucket -BucketName $Bucket_Name))

Write-Host "Creating bucket named $Bucket_Name." -ForegroundColor Green

New-S3Bucket -BucketName $Bucket_Name -Region us-east-1

$Desktop = [Environment]::GetFolderPath("Desktop")

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\" -Folder "$Desktop\Group-Policy-backups"

$Invalid_Chars = ':\\/' + [RegEx]::Escape(-join [IO.Path]::InvalidPathChars)

New-Item -Path $Desktop -Name "Group-Policy-backups" -ItemType "Directory"

$Backup_Directory = '$Desktop\Group-Policy-backups'

Get-GPO -All | ForEach-Object {
  $Name = $_.DisplayName -replace "[$invalidChars]", '_'
  Write-Host "Backing up GPO named $Name to $Bucket_Name" -ForegroundColor Green
  $GPO_Directory = Join-Path $Backup_Directory -ChildPath $Name
  New-Item $GPO_Directory -Type Directory | Out-Null
  Backup-GPO -Guid $_.Id -Path $GPO_Directory
}

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\Group-Policy-backups" -Folder "$Desktop\Group-Policy-backups" -Recurse

Get-ADUser -Filter * | Select Name, GivenName, SamAccountName, DistinguishedName | Export-CSV "$Desktop\Users.csv"

Write-Host "Backing up Active Directory users to bucket $Bucket_Name as a csv file." -ForegroundColor Green

Write-S3Object -BucketName $Bucket_Name -KeyPrefix "\" -Key "Users.csv" -File "$Desktop\Users.csv"
