$OS = systeminfo | findstr /B /C:"OS Version"

Write-Host $OS

$OS_Appended = $OS.replace("N/A Build 19045", "")

$Desktop_Path = [Environment]::GetFolderPath("Desktop")

$Date = Get-Date 

$Computer = Hostname

$Ok_Button = [System.Windows.MessageBoxButton]::Ok

$Icon = [System.Windows.MessageBoxImage]::Warning

$Start_Title = “Windows update has commenced”

$Start_Body = “Windows has commenced on $Date for $Computer”

$Already_Updated_Title = “$Computer is already running $OS_Appended”

$Already_Updated_Body = “$Computer is already running $OS_Appended. No further action is required.”

if($OS -notmatch "10.0.19045"){

[System.Windows.MessageBox]::Show($Start_Title,$Start_Body,$Ok_Button,$Icon)

Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=799445" -OutFile "$Desktop_Path\Windows_Update_Assistant.exe"

Set-Location -Path $Desktop_Path

Start-Process -FilePath Windows_Update_Assistant.exe -Wait -Passthru

Remove-Item -Path Windows_Update_Assistant.exe -Force

}

else{

[System.Windows.MessageBox]::Show($Already_Updated_Body,$Already_Updated_Title,$Ok_Button,$Icon)

}
