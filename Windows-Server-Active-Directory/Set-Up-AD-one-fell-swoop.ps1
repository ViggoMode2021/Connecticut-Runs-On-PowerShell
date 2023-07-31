Add-WindowsFeature AD-Domain-Services

Install-ADDSForest -DomainName vigschools.org -InstallDNS

Restart-Computer

Import-Module ActiveDirectory

$vigschools = "vigschools"

$DC = "vigschools"

$Domain = "@vigschools.org"

$StudentAccounts = "StudentAccounts"

$HighSchool = "HighSchool"

$MiddleSchool = "MiddleSchool"

$ElementarySchool = "ElementarySchool"

$FacultyAccounts = "FacultyAccounts"

$OrganizationalUnits = @("StudentAccounts", "HighSchoolStudents", "ClassOf2023", "ClassOf2024", "ClassOf2025", "ClassOf2026", "ClassOf2027",
"MiddleSchoolStudents", "ClassOf2027", "ClassOf2028", "ClassOf2029", "ClassOf2030", "ElementarySchoolStudents", "ClassOf2031", "ClassOf2032", "ClassOf2033", "ClassOf2034",
"FacultyAccounts", "HighSchoolFaculty", "MiddleSchoolFaculty", "ElementarySchoolFaculty")

function CheckOU{
    foreach ($OU in $OrganizationalUnits){
        if (Get-ADOrganizationalUnit -Filter 'Name -like $OU' | Format-Table Name, DistinguishedName -A) {
            Write-Host "$OU already exists."
}
else {

Write-Host "Creating OU named $OU"
}

}
}

CheckOU

# Add student OUs below:

New-ADOrganizationalUnit -Name "StudentAccounts" -Path "DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "HighSchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2023" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2024" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2025" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2026" -Path "OU=$HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "MiddleSchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2027" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2028" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2029" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2030" -Path "OU=$MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ElementarySchool" -Path "OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2031" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2032" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2033" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ClassOf2034" -Path "OU=$ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"

#Add faculty OUs below:

New-ADOrganizationalUnit -Name "FacultyAccounts" -Path "DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "HighSchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "MiddleSchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

New-ADOrganizationalUnit -Name "ElementarySchoolFaculty" -Path "OU=$FacultyAccounts,DC=$DC,DC=ORG"

# Logic to add CSV-Users to CSV

# CSV URLs

$HighSchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/teacher-names.csv"

$MiddleSchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/middle-school-teacher-names.csv"

$ElementarySchoolFacultyNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/elementary-school-teacher-names.csv"

$ClassOf2023StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2023-student-names.csv" # HS

$ClassOf2024StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2024-student-names.csv" # HS

$ClassOf2025StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2025-student-names.csv" # HS

$ClassOf2026StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2026-student-names.csv" # HS

$ClassOf2027StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2027-student-names.csv" # MS

$ClassOf2028StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2028-student-names.csv" # MS

$ClassOf2029StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2029-student-names.csv" # MS

$ClassOf2030StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2030-student-names.csv" # MS

$ClassOf2031StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2031-student-names.csv" # ES

$ClassOf2032StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2032-student-names.csv" # ES

$ClassOf2033StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2033-student-names.csv" # ES

$ClassOf2034StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2034-student-names.csv" # ES

$ClassOf2035StudentNames = "https://raw.githubusercontent.com/ViggoMode2021/PowerShellScripts/main/class-of-2035-student-names.csv" # ES

# High School Faculty:

New-Item -Path 'C:\Users\Administrator\Desktop\CSV-Data' -ItemType Directory

Invoke-WebRequest $HighSchoolFacultyNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\HighSchoolTeachers.csv

$HighSchoolFacultyCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\HighSchoolTeachers.csv"

$High_School_Faculty_Count = $HighSchoolFacultyCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $HighSchoolFacultyCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=HighSchoolFaculty,OU=$FacultyAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $True `
-Name "$Last_Name$Comma $First_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $true

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $High_School_Faculty_Count to HighSchoolFaculty OU!" -BackgroundColor DarkGreen -ForegroundColor White

# Middle School Faculty:

Invoke-WebRequest $MiddleSchoolFacultyNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\MiddleSchoolTeachers.csv

$MiddleSchoolFacultyCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\MiddleSchoolTeachers.csv"

$Middle_School_Faculty_Count = $MiddleSchoolFacultyCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $MiddleSchoolFacultyCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=MiddleSchoolFaculty,OU=$FacultyAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $True `
-Name "$Last_Name$Comma $First_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $true

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Middle_School_Faculty_Count to MiddleSchoolFaculty OU!" -BackgroundColor DarkGreen -ForegroundColor White

# Elementary school teachers

Invoke-WebRequest $ElementarySchoolFacultyNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ElementarySchoolTeachers.csv

$ElementarySchoolFacultyCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ElementarySchoolTeachers.csv"

$Elementary_School_Faculty_Count = $ElementarySchoolFacultyCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ElementarySchoolFacultyCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ElementarySchoolFaculty,OU=$FacultyAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $True `
-Name "$Last_Name$Comma $First_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $true

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Elementary_School_Faculty_Count to ElementarySchoolFaculty OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2023

Invoke-WebRequest $ClassOf2023StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2023Students.csv

$ClassOf2023StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2023Students.csv"

$Class_Of_2023_Students_Count = $ClassOf2023StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2023StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2023,OU=HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2023_Students_Count to ClassOf2023Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2024

Invoke-WebRequest $ClassOf2024StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2024Students.csv

$ClassOf2024StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2024Students.csv"

$Class_Of_2024_Students_Count = $ClassOf2024StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2024StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2024,OU=HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2024_Students_Count to ClassOf2024Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2025

Invoke-WebRequest $ClassOf2025StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2025Students.csv

$ClassOf2025StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2025Students.csv"

$Class_Of_2025_Students_Count = $ClassOf2025StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2025StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2025,OU=HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2025_Students_Count to ClassOf2025Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2026

Invoke-WebRequest $ClassOf2026StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2026Students.csv

$ClassOf2026StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2026Students.csv"

$Class_Of_2026_Students_Count = $ClassOf2026StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2026StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2026,OU=HighSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2026_Students_Count to ClassOf2026Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2027

Invoke-WebRequest $ClassOf2027StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2027Students.csv

$ClassOf2027StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2027Students.csv"

$Class_Of_2027_Students_Count = $ClassOf2027StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2027StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2027,OU=MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2027_Students_Count to ClassOf2027Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2028

Invoke-WebRequest $ClassOf2028StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2028Students.csv

$ClassOf2028StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2028Students.csv"

$Class_Of_2028_Students_Count = $ClassOf2028StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2028StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2028,OU=MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2028_Students_Count to ClassOf2028Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2029

Invoke-WebRequest $ClassOf2029StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2029Students.csv

$ClassOf2029StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2029Students.csv"

$Class_Of_2029_Students_Count = $ClassOf2029StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2029StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2029,OU=MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2029_Students_Count to ClassOf2029Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2030

Invoke-WebRequest $ClassOf2030StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2030Students.csv

$ClassOf2030StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2030Students.csv"

$Class_Of_2030_Students_Count = $ClassOf2030StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2030StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2030,OU=MiddleSchool,OU=$StudentAccounts,DC=$DC,DC=ORG" `
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2030_Students_Count to ClassOf2030Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2031

Invoke-WebRequest $ClassOf2031StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2031Students.csv

$ClassOf2031StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2031Students.csv"

$Class_Of_2031_Students_Count = $ClassOf2031StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2031StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2031,OU=ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"`
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2031_Students_Count to ClassOf2031Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2032

Invoke-WebRequest $ClassOf2032StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2032Students.csv

$ClassOf2032StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2032Students.csv"

$Class_Of_2032_Students_Count = $ClassOf2032StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2032StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2032,OU=ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"`
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2032_Students_Count to ClassOf2032Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2033

Invoke-WebRequest $ClassOf2033StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2033Students.csv

$ClassOf2033StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2033Students.csv"

$Class_Of_2033_Students_Count = $ClassOf2033StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2033StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2033,OU=ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"`
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2033_Students_Count to ClassOf2033Students OU!" -BackgroundColor DarkGreen -ForegroundColor White

# ClassOf2034

Invoke-WebRequest $ClassOf2034StudentNames -OutFile C:\Users\Administrator\Desktop\CSV-Data\ClassOf2034Students.csv

$ClassOf2034StudentsCSV=Import-CSV "C:\Users\Administrator\Desktop\CSV-Data\ClassOf2034Students.csv"

$Class_Of_2034_Students_Count = $ClassOf2034StudentsCSV | Measure-Object | Select-Object -expand count

ForEach ($User in $ClassOf2034StudentsCSV) {

$First_Name=$User.first_name

$Last_Name=$User.last_name

$First_Initial = $First_Name.Substring(0,1).ToLower()

$First_Name_Lower = $First_Name.ToLower()
$Last_Name_Lower = $Last_Name.ToLower()
$Username = "$First_Initial$Last_Name_Lower"

$Enrollment_Date =  Get-Date -Format "MMddyy"

$Password = "$vigschools$Enrollment_Date"

$Default_Password = $Password | ConvertTo-SecureString -AsPlainText -Force

New-ADUser `
-Path "OU=ClassOf2034,OU=ElementarySchool,OU=$StudentAccounts,DC=$DC,DC=ORG"`
-Enabled $True `
-ChangePasswordAtLogon $False `
-Name "$First_Name $Last_Name" `
-GivenName $First_Name `
-Surname $Last_Name `
-AccountPassword $Default_Password `
-SamAccountName $Username `
-UserPrincipalName "$Username $Domain" `
-Displayname "$First_Name $Last_Name" `
-ScriptPath "logon.bat" `
-HomeDrive "Y:" `
-HomeDirectory "\\mfr-server01\users\$Username" `
-EmailAddress "$Username$Domain"

Unlock-ADAccount -Identity $Username

Enable-ADAccount -Identity $Username

Set-ADUser -Identity $Username -ChangePasswordAtLogon $false

Write-Host "Adding $Username, please wait..."

}

Write-Host "Added $Class_Of_2034_Students_Count to ClassOf2034Students OU!"

$TotalFacultyCount = $High_School_Faculty_Count + $Middle_School_Faculty_Count + $Elementary_School_Faculty_Count

$TotalStudentsCount = $Class_Of_2023_Students_Count + $Class_Of_2024_Students_Count + $Class_Of_2025_Students_Count `
 + $Class_Of_2026_Students_Count + $Class_Of_2027_Students_Count + $Class_Of_2028_Students_Count + $Class_Of_2029_Students_Count `
 + $Class_Of_2030_Students_Count + $Class_Of_2031_Students_Count + $Class_Of_2032_Students_Count + $Class_Of_2033_Students_Count + `
 $Class_Of_2034_Students_Count

Write-Host "$TotalFacultyCount faculty added." -BackgroundColor DarkGreen -ForegroundColor White

Write-Host "$TotalStudentsCount students added." -BackgroundColor DarkGreen -ForegroundColor White
