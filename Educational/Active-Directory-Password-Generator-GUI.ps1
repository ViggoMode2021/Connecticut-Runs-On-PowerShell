# Generate a random password for an Active Directory user:

     # 1. Select a CSV file from local computer.
	 
     # 2. Select Active Directory user from dropdown.
	 
     # 3. Check the optional "Include special characters" checkbox to append special characters to the file. 

     # 4. Click the "Generate Password" button to generate 

Import-Module ActiveDirectory # Import Active Directory PowerShell module

Add-Type -AssemblyName System.Windows.Forms # Add .NET Windows Forms functionality

Add-Type -AssemblyName PresentationCore,PresentationFramework

$Current_Date = Get-Date -Format "MM/dd/yyyy" # Get today's date

$Domain = Get-ADDomain -Current LocalComputer | Select Name | foreach { $_.Name } | Out-String # Get-AD Domain name

$Min_Password_Length = Get-ADDefaultDomainPasswordPolicy | Select -ExpandProperty MinPasswordLength

$Min_Password_Length = [int]$Min_Password_Length

$Global:Selected_File = $null

# GUI form code below:

$Form_Object = [System.Windows.Forms.Form] # Entire form/window for GUI
$Label_Object = [System.Windows.Forms.Label] # Label object for text
$Button_Object = [System.Windows.Forms.Button] # Button object
$Combo_Box_Object = [System.Windows.Forms.ComboBox] # Dropdown object

$Application_Form = New-Object $Form_Object # Create new form/window for GUI

$Application_Form.ClientSize= '300,300'

$Application_Form.Text = "Password generator for AD users in $Domain on $Current_Date" # Name of application

$Application_Form.BackColor= "#ffffff" # White bkgr color

# Building the form:

## ---------------------------------------------------------------------------- ## 

    # Label #1:

$Password_Length = New-Object $Label_Object # Calling object

$Password_Length.Text= "Password length:"

$Password_Length.AutoSize = $true

$Password_Length.Font = 'Verdana,8,style=Bold'

$Password_Length.Location = New-Object System.Drawing.Point(200,20)

## ---------------------------------------------------------------------------- ## 
                                                           
    # Label #2:

$CSV_Name_Label = New-Object $Label_Object # Calling object

$CSV_Name_Label.AutoSize = $true

$CSV_Name_Label.Font = 'Verdana,8,style=Bold'

$CSV_Name_Label.Location = New-Object System.Drawing.Point(370,80) 

if($Selected_File -eq $null){

$CSV_Name_Label.Text= ""

}

else{

$CSV_Name_Label.Text= "Current CSV: $CSV_Filename"

}

## ---------------------------------------------------------------------------- ## 

    # Label #3:

$Generated_Password_Label = New-Object $Label_Object # Calling object

$Generated_Password_Label.Text= ""

$Generated_Password_Label.AutoSize = $true

$Generated_Password_Label.Font = 'Verdana,8,style=Bold'

$Generated_Password_Label.Location = New-Object System.Drawing.Point(620,620)

## ---------------------------------------------------------------------------- ## 

    # Label #4:

$User_Name_Password_Label = New-Object $Label_Object # Calling object

$User_Name_Password_Label.Text= "*Change password for (username)*"

$User_Name_Password_Label.AutoSize = $true

$User_Name_Password_Label.Font = 'Verdana,11,style=Bold'

$User_Name_Password_Label.ForeColor = 'Blue'

$User_Name_Password_Label.Location = New-Object System.Drawing.Point(20,150)

## ---------------------------------------------------------------------------- ## 

    # Label #5:

$User_Password_Last_Set = New-Object $Label_Object # Calling object

$User_Password_Last_Set.Text= ""

$User_Password_Last_Set.AutoSize = $true

$User_Password_Last_Set.Font = 'Verdana,10,style=Bold'

## ---------------------------------------------------------------------------- ## 

# Label #6:

$Select_Name_Label = New-Object $Label_Object # Calling object

$Select_Name_Label.AutoSize = $true

$Select_Name_Label.Font = 'Verdana,8,style=Bold'

$Select_Name_Label.Location = New-Object System.Drawing.Point(470,30)

## ---------------------------------------------------------------------------- ## 

# Label #7:

$CSV_Length_Label = New-Object $Label_Object # Calling object

$CSV_Length_Label.AutoSize = $true

$CSV_Length_Label.Font = 'Verdana,8,style=Bold'

$CSV_Length_Label.Location = New-Object System.Drawing.Point(370,120) 

    # Select user button:

$Select_User_Button = New-Object $Button_Object

$Select_User_Button.Text= "Select user"

$Select_User_Button.AutoSize = $true

$Select_User_Button.Font = 'Verdana,12,style=Bold'

$User_Name_Password_Label.ForeColor = 'Blue'

$Select_User_Button.Location = New-Object System.Drawing.Point(220,40)

$Select_User_Button.Add_Click({Select_User})

## ---------------------------------------------------------------------------- ## 

# Change CSV button:

$Change_CSV_Button = New-Object $Button_Object

$Change_CSV_Button.Text= "Change CSV"

$Change_CSV_Button.AutoSize = $true

$Change_CSV_Button.Font = 'Times,10,style=Bold'

$Change_CSV_Button.ForeColor = 'Red'

$Change_CSV_Button.Location = New-Object System.Drawing.Point(475,42)

$Change_CSV_Button.Add_Click({Change_CSV})

## ---------------------------------------------------------------------------- ## 

# Label #7:

$Min_Password_Length_Label = New-Object $Label_Object # Calling object

$Min_Password_Length_Label.Text= "Minimum password length for $Domain is $Min_Password_Length"

$Min_Password_Length_Label.AutoSize = $true

$Min_Password_Length_Label.Font = 'Arial,10,style=Italic'

$Min_Password_Length_Label.Location = New-Object System.Drawing.Point(40,630)

## ---------------------------------------------------------------------------- ## 

    # MessageBoxes:

$ButtonTypeOk = [System.Windows.MessageBoxButton]::Ok

$ButtonTypeYesNo = [System.Windows.MessageBoxButton]::YesNoCancel 

$MessageIconWarning = [System.Windows.MessageBoxImage]::Warning

$MessageIconError = [System.Windows.MessageBoxImage]::Error
  
$Upload_CSV_Button = New-Object $Button_Object

$Upload_CSV_Button.Name = "Upload"
$Upload_CSV_Button.Text = "Upload CSV"
$Upload_CSV_Button.Location = New-Object System.Drawing.Point(375,45)

## ---------------------------------------------------------------------------- ##

$Include_Special_Characters_Checkbox = New-Object System.Windows.Forms.CheckedListBox

$Include_Special_Characters_Checkbox.Location = New-Object System.Drawing.Size(10,350)

$Include_Special_Characters_Checkbox.Items.Insert(0, "Include Special Characters"); 

$Include_Special_Characters_Checkbox.ClearSelected()

$Include_Special_Characters_Checkbox.CheckOnClick = $true

$Include_Special_Characters_Checkbox.Size = New-Object System.Drawing.Size(240,190)
$Include_Special_Characters_Checkbox.Height = 40
$Include_Special_Characters_Checkbox.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)

    # OU Dropdown list:

$OU_Select_Dropdown = New-Object $Combo_Box_Object

$OU_Select_Dropdown.Width= '190'

$OU_Select_Dropdown.Text= "Select an OU"

$OU_Select_Dropdown.Font = New-Object System.Drawing.Font("Lucinda Console",12)

$OU_Select_Dropdown.Location = New-Object System.Drawing.Point(10,10) # Add location to top left of GUI

# User Dropdown list:

$Users_Dropdown = New-Object $Combo_Box_Object

$Users_Dropdown.Width= '190'

$Users_Dropdown.Text= "Select a user"

$Users_Dropdown.Font = New-Object System.Drawing.Font("Lucinda Console",12)

$Users_Dropdown.Location = New-Object System.Drawing.Point(10,40) # Add location to top left of GUI

# Generate Password Button:

$Generate_Password_Button = New-Object $Button_Object

$Generate_Password_Button.Text= "*no file selected*"

$Generate_Password_Button.AutoSize = $true

$Generate_Password_Button.Font = 'Verdana,12,style=Bold'

$Generate_Password_Button.ForeColor = 'Green'

$Generate_Password_Button.Location = New-Object System.Drawing.Point(10,400)

$Generate_Password_Button.Add_Click({Generate_Password})

$Upload_CSV_Button.Add_Click({Select_CSV})

## Corresponding functions

Get-ADOrganizationalUnit -Properties CanonicalName -Filter * | Where-Object DistinguishedName -notlike "*Domain Controllers*" |Sort-Object CanonicalName | ForEach-Object {$OU_Select_Dropdown.Items.Add($_.Name)}

$User_Name=$Users_Dropdown.SelectedItem

# Function to show OUs: 

function Show_OUs{

$Users_Dropdown.Items.Clear()

$OU_Name=$OU_Select_Dropdown.SelectedItem

$global:OU_Global = $OU_Name

Get-ADUser -Filter {(enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Users_Dropdown.Items.Add($_.Name)}

}

$OU_Select_Dropdown.Add_SelectedIndexChanged({Show_OUs})

function Select_User{

    $User_Name=$Users_Dropdown.SelectedItem
	
	if($User_Name -eq $null){

	$MessageBoxTitle = "No user or OU selected error!"

    $MessageBoxBody = "Please select a user and/or OU from the dropdown."

    $Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeOk,$MessageIconError)

	}
	
	else{

    $global:User_Name_Global = $User_Name

    $User_Name_Password_Label.Text = "Change password for $User_Name"

    $User_Name_Password_Last_Set = Get-ADUser -Filter {(enabled -eq $true)} -Properties PwdLastSet,PasswordLastSet | Where-Object DistinguishedName -like "*$User_Name*" | Select -ExpandProperty PasswordLastSet					

    $User_Password_Last_Set.Text = "Password Last Set: " + $User_Name_Password_Last_Set

    $User_Password_Last_Set.Location = New-Object System.Drawing.Point(50,190)

    }
}

## ---------------------------------------------------------------------------- ##

$Desktop = 'Desktop'

function Select_CSV ($Desktop){
	
	if (!$Selected_File){
	
	Try{
		
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "(*.csv)|*.csv|SpreadSheet (*.xlsx)|*.xlsx'"
    # Out-Null supresses the "OK" after selecting the file.
    $OpenFileDialog.ShowDialog() | Out-Null

    $Global:Selected_File = $OpenFileDialog.FileName

    $CSV_Filename = Split-Path $Selected_File -Leaf

    $CSV = [string]$CSV_Filename
	
	$CSV_Length = Import-CSV $Selected_File | Measure-Object | Select-Object -expand Count
	
	$CSV_Length_Label.Text = "This CSV file contains $CSV_Length values for password creation."

    [bool]$string
	
	}
	Catch{
		
	"NOOOO"
		
	}

    if(!$CSV){

    $MessageBoxTitle = "No file selected error!"

    $MessageBoxBody = "No file has been selected. Please select a csv file."

    $Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeOk,$MessageIconWarning)
	
	Invoke-Expression Select_CSV

    }

    elseif($CSV_Name_Label.Text= "Current CSV: $CSV_Filename"){

    $Generate_Password_Button.Text = 'Generate Password'

    $CSV_Name_Label.Text= "Current CSV: $CSV_Filename"

    $Upload_CSV_Button.Text = "Selected"

    $Upload_CSV_Button.ForeColor = 'Green'
	
	$CSV_Length = Import-CSV $Selected_File | Measure-Object | Select-Object -expand Count
	
	$CSV_Length_Label.Text = "This CSV file contains $CSV_Length values for password creation."
	
	$Application_Form.Controls.AddRange(@($CSV_Name_Label, $Upload_CSV_Button, $Min_Password_Length_Label, $Include_Special_Characters_Checkbox, $Generate_Password_Button, $Groupbox_2, $Generated_Password_Label,
	$OU_Select_Dropdown, $Users_Dropdown, $Select_User_Button, $User_Name_Password_Label, $User_Password_Last_Set,
	$Select_Name_Label, $Change_CSV_Button))
	
	$Change_CSV_Button.Add_Click({Change_CSV})

    }

    else{

    $Generate_Password_Button.Text = 'Select random word'

    $CSV_Name_Label.Text= "Current CSV: $CSV_Filename"
	
	$CSV_Length = Import-CSV $Selected_File | Measure-Object | Select-Object -expand Count
	
	$CSV_Length_Label.Text = "This CSV file contains $CSV_Length values for password creation."

    $Upload_CSV_Button.Text = "Selected"

    $Upload_CSV_Button.ForeColor = 'Green'
	
	$Application_Form.Controls.AddRange(@($CSV_Name_Label, $Upload_CSV_Button, $Min_Password_Length_Label, $Include_Special_Characters_Checkbox, $Generate_Password_Button, $Groupbox_2, $Generated_Password_Label,
	$OU_Select_Dropdown, $Users_Dropdown, $Select_User_Button, $User_Name_Password_Label, $User_Password_Last_Set,
	$Select_Name_Label, $Change_CSV_Button))
	
	$Change_CSV_Button.Add_Click({Change_CSV})

    }
	}

}

function Change_CSV{
	
$Global:Selected_File = $null

Invoke-Expression Select_CSV

}
	
function Generate_Password{
	
$User_Name=$Users_Dropdown.SelectedItem
	
if($User_Name -eq $null){

$MessageBoxTitle = "No user or OU selected error!"

$MessageBoxBody = "Please select a user and/or OU from the dropdown."

$Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeOk,$MessageIconError)

#break

}

elseif($Selected_File -eq $null){

$MessageBoxTitle = "No file error!"

$MessageBoxBody = "No CSV file loaded. You need to select one."

$Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeOk,$MessageIconWarning)

}

else{

Import-Csv $Selected_File | ForEach-Object {
    if($null -eq $First_Column_Name) {
        # first row, grab the first column name
        $First_Column_Name = @($_.psobject.Properties)[0].Name
    }
    }
    
    # access the value in the given column

$Random_CSV_Word = Import-Csv $Selected_File | select -ExpandProperty $First_Column_Name | Get-Random

$Generated_Password_Label.Text = "$Random_CSV_Word"

$Generated_Password = $Random_CSV_Word

$Generated_Password_Label.Text = $Generated_Password

$Generated_Password_Length = $Generated_Password.Length

if($Include_Special_Characters_Checkbox.CheckedItems -Contains "Include Special Characters"){
		
		$random_array = "!#$%&''()*+,-./:;<=>?@[\]^_`{|}~".ToCharArray()
		$random_object = New-Object System.Random
		$random_string = ""
		$random_integer = Get-Random -Minimum 1 -Maximum 5
		for ($i = $random_integer; $i -lt 6; $i++) {
			$random_index = $random_object.Next(0, $random_array.Length)
			$random_character = $random_array[$random_index]
			$random_string += $random_character
}
		
		$Generated_Password = $Generated_Password + $random_string
		
	}

$Generated_Password_Length = $Generated_Password.Length

$New_User_Password = ConvertTo-SecureString $Generated_Password -AsPlainText -Force

$MessageBoxTitle = "Change password for $User_Name_Global"

$MessageBoxBody = "Change password to '$Generated_Password' for '$User_Name_Global'?"

$Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeYesNo,$MessageIconWarning)

$Sam_Account_Name = Get-ADUser -Filter {(enabled -eq $true)} | Where-Object DistinguishedName -like "*$User_Name_Global*" | Select -ExpandProperty SamAccountName

if($Confirmation -eq 'Yes' -and $Generated_Password_Length -eq $Min_Password_Length){
	Set-ADAccountPassword -Identity $Sam_Account_Name -NewPassword $New_User_Password -Reset
	$Generated_Password_Label.Text = "Password updated for $User_Name_Global on $Current_Date."
	
	$User_Name_Password_Last_Set = Get-ADUser -Filter {(enabled -eq $true)} -Properties PwdLastSet,PasswordLastSet | Where-Object DistinguishedName -like "*$User_Name*" | Select -ExpandProperty PasswordLastSet					

    $User_Password_Last_Set.Text = "Password Last Set: " + $User_Name_Password_Last_Set
	
	$MessageBoxTitle = "Password updated successfully"

	$MessageBoxBody = "Password updated successfully. Would you like to copy the password to your clipboard?"

	$Confirmation_2 = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeYesNo,$MessageIconWarning)
	
	if($Confirmation_2 -eq 'Yes'){
		
	$Generated_Password | Set-Clipboard }

	if($Confirmation_2 -eq 'No'){
			
	}
	
}

if($Confirmation -eq 'Yes' -and $Generated_Password_Length -gt $Min_Password_Length){
	Set-ADAccountPassword -Identity $Sam_Account_Name -NewPassword $New_User_Password -Reset
	$Generated_Password_Label.Text = "Password updated for $User_Name_Global on $Current_Date."
	
	$User_Name_Password_Last_Set = Get-ADUser -Filter {(enabled -eq $true)} -Properties PwdLastSet,PasswordLastSet | Where-Object DistinguishedName -like "*$User_Name*" | Select -ExpandProperty PasswordLastSet					

    $User_Password_Last_Set.Text = "Password Last Set: " + $User_Name_Password_Last_Set
	
	$MessageBoxTitle = "Password updated successfully"

	$MessageBoxBody = "Password updated successfully. Would you like to copy the password to your clipboard?"

	$Confirmation_2 = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeYesNo,$MessageIconWarning)
	
	if($Confirmation_2 -eq 'Yes'){
		
	$Alternate_Password | Set-Clipboard }

	if($Confirmation_2 -eq 'No'){
			
	}
}

if($Confirmation -eq 'No') {
    $Generated_Password_Label.Text = ""
	
	Invoke-Expression Generate_Password
} 

if($Confirmation -eq 'Yes' -and $Generated_Password_Length -lt $Min_Password_Length){
	
	$MessageBoxTitle = "Password length error!"

	$MessageBoxBody = "Length of $Generated_Password_Length doesn't satisfy min password length of $Domain of $Min_Password_Length."

	$Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeOk,$MessageIconError)
	
	$Password_Length_Difference = $Min_Password_Length - $Generated_Password_Length
	
	$Random_Number = Get-Random -Minimum 1000 -Maximum 999999

	$Random_Number = [string]$Random_Number
	
	$Alternate_Password = $Random_CSV_Word + $Random_Number
	
	$New_User_Password = ConvertTo-SecureString $Alternate_Password -AsPlainText -Force
	
	$MessageBoxTitle = "Alternate password for $User_Name_Global"

	$MessageBoxBody = "The alternate password '$Alternate_Password' satisfies the domain's password contstraints. Would you like to use this password?"

	$Confirmation = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeYesNo,$MessageIconWarning)
	
	if($Confirmation -eq 'Yes'){
	Set-ADAccountPassword -Identity $Sam_Account_Name -NewPassword $New_User_Password -Reset
	$Generated_Password_Label.Text = "Password updated for $User_Name_Global on $Current_Date."
	
	$MessageBoxTitle = "Password updated successfully"

	$MessageBoxBody = "Password updated successfully. Would you like to copy the password to your clipboard?"

	$Confirmation_2 = [System.Windows.MessageBox]::Show($MessageBoxBody,$MessageBoxTitle,$ButtonTypeYesNo,$MessageIconWarning)
	
	if($Confirmation_2 -eq 'Yes'){
		
	$Alternate_Password | Set-Clipboard }

	if($Confirmation_2 -eq 'No'){
			
	}
	
	if($Confirmation -eq 'No') {
    $Generated_Password_Label.Text = ""
	
	Invoke-Expression Generate_Password
}       
}
	
}

}

}

## ---------------------------------------------------------------------------- ##

function Copy_Password_To_Clipboard{

$Generated_Password_Label.Text | Set-Clipboard

}

## ---------------------------------------------------------------------------- ##

$Application_Form.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation 

$Application_Form.Controls.AddRange(@($CSV_Name_Label, $Upload_CSV_Button, $Min_Password_Length_Label, $Include_Special_Characters_Checkbox, $Generate_Password_Button, $Groupbox_2, $Generated_Password_Label,
$Copy_To_Clipboard_Button, $OU_Select_Dropdown, $Users_Dropdown, $Select_User_Button, $User_Name_Password_Label, $User_Password_Last_Set,
$Select_Name_Label, $CSV_Length_Label))

#$Groupbox_2.Controls.AddRange(@())

$Application_Form.ShowDialog() # Show form on runtime

$Application_Form.Dispose() # Garbage collection
