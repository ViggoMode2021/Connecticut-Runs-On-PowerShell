Import-Module ActiveDirectory # Import Active Directory PowerShell module

Add-Type -AssemblyName System.Windows.Forms # Add .NET Windows Forms functionality

$Current_Date = Get-Date -Format "MM/dd/yyyy" # Get today's date

# GUI form code below:

$Form_Object = [System.Windows.Forms.Form] # Entire form/window for GUI
$Label_Object = [System.Windows.Forms.Label] # Label object for text
$Button_Object = [System.Windows.Forms.Button] # Button object
$Combo_Box_Object = [System.Windows.Forms.ComboBox] # Dropdown object

# Base form code:

$Application_Form = New-Object $Form_Object # Create new form/window for GUI

$Application_Form.ClientSize= '500,300'

$Domain = Get-ADDomain -Current LocalComputer | Select Name | foreach { $_.Name } |  Out-String # Get-AD Domain name

$Application_Form.Text = "Disable and Enable unused accounts for $Domain on $Current_Date" # Name of application

$Application_Form.BackColor= "#ffffff" # White bkgr color

# Building the form:

    # Label/Text box #1:

$Label_Title = New-Object $Label_Object # Calling object

$Label_Title.Text= "Select an OU from the dropdown `r`n to see inactive users that never logged in."

$Label_Title.AutoSize = $true

$Label_Title.Font = 'Verdana,11,style=Bold'

$Label_Title.Location = New-Object System.Drawing.Point(320,20) # Add location to top center of GUI

    # Label/Text box #2:

$Label_Title_2 = New-Object $Label_Object 

$Label_Title_2.Text= "" # This text is NULL here but will change depending on function output 

$Label_Title_2.AutoSize = $true

$Label_Title_2.Font = 'Verdana,12,style=Bold'

$Label_Title_2.ForeColor = 'Green'

$Label_Title_2.Location = New-Object System.Drawing.Point(305,35) # Add location to top left of GUI

# Label/Text box #3:

$Label_Title_3 = New-Object $Label_Object

$Label_Title_3.Text= ""

$Label_Title_3.AutoSize = $true

$Label_Title_3.Font = 'Verdana,12,style=Bold'

$Label_Title_3.ForeColor = 'Red'

$Label_Title_3.Location = New-Object System.Drawing.Point(300,60)

# Label/Text box #4:

$Label_Title_4 = New-Object $Label_Object

$Label_Title_4.Text= ""

$Label_Title_4.AutoSize = $true

$Label_Title_4.ForeColor = 'Red'

$Label_Title_4.Font = 'Verdana,12,style=Bold'

$Label_Title_4.Location = New-Object System.Drawing.Point(400,550) # Add location to top left of GUI

    # Dropdown list:

$Disable_Users_Dropdown = New-Object $Combo_Box_Object

$Disable_Users_Dropdown.Width='300'

$Disable_Users_Dropdown.Text="Select an OU"

$Disable_Users_Dropdown.Font = New-Object System.Drawing.Font("Lucinda Console",12)

    # Dropdown list:

$Disable_Individual_Users_Dropdown = New-Object $Combo_Box_Object

$Disable_Individual_Users_Dropdown.Width='300'

$Disable_Individual_Users_Dropdown.Text="Select a user"

$Disable_Individual_Users_Dropdown.Font = New-Object System.Drawing.Font("Lucinda Console",12)

$Disable_Individual_Users_Dropdown.Location = New-Object System.Drawing.Point(700,4)

    # Input box: 

$Input_Box = New-Object System.Windows.Forms.TextBox

$Input_Box.Location = New-Object System.Drawing.Point (10,40)

$Input_Box.Size = New-Object System.Drawing.Size(275,500)

$Input_Box.Multiline = $false

$Input_Box.AcceptsReturn = $false

$Input_Box.Location = New-Object System.Drawing.Point(360,250)

    #Disable users button:

$Button_Object = [System.Windows.Forms.Button]

$Disable_Users_Button = New-Object $Button_Object

$Disable_Users_Button.Text= "Disable all users"

$Disable_Users_Button.AutoSize = $true

$Disable_Users_Button.Font = 'Verdana,12,style=Bold'

$Disable_Users_Button.Location = New-Object System.Drawing.Point(350,190)

    # Enable users button:

$Enable_Users_Button = New-Object $Button_Object

$Enable_Users_Button.Text= "Enable all users"

$Enable_Users_Button.AutoSize = $true

$Enable_Users_Button.Font = 'Verdana,12,style=Bold'

$Enable_Users_Button.Location = New-Object System.Drawing.Point(350,120)

    #Disable individual user button (this button disables an individual enabled user):

$Button_Object = [System.Windows.Forms.Button]

$Disable_Individual_User_Button = New-Object $Button_Object

$Disable_Individual_User_Button.Text= "Disable selected user"

$Disable_Individual_User_Button.AutoSize = $true

$Disable_Individual_User_Button.Font = 'Verdana,12,style=Bold'

$Disable_Individual_User_Button.Location = New-Object System.Drawing.Point(350,480)

    #Enable individual user button (this button enables an individual disabled user):

$Enable_Individual_User_Button = New-Object $Button_Object

$Enable_Individual_User_Button.Text= "Enable selected user"

$Enable_Individual_User_Button.AutoSize = $true

$Enable_Individual_User_Button.Font = 'Verdana,12,style=Bold'

$Enable_Individual_User_Button.Location = New-Object System.Drawing.Point(350,420)

    # Pack objects into form

$Application_Form.Controls.AddRange(@($Label_Title,$Disable_Users_Dropdown,$Label_Title_2, $Disable_Users_Button, $Enable_Users_Button, $Label_Title_3, $Label_Title_4, $Disable_Individual_Users_Dropdown, $Enable_Individual_User_Button,$Disable_Individual_User_Button))

    # Get all OUs for the GUI and add them to the dropdown list:

Get-ADOrganizationalUnit -Properties CanonicalName -Filter * | Where-Object DistinguishedName -notlike "*Domain Controllers*" |Sort-Object CanonicalName | ForEach-Object {$Disable_Users_Dropdown.Items.Add($_.Name)}

function Show_Inactive_Users{

    $Enable_Individual_User_Button.Add_Click({Enable_Individual_User}) # Enable button once function is executed

    $Disable_Users_Button.Add_Click({Disable_Inactive_Users}) # Enable button once function is executed
     
    $Enable_Users_Button.Add_Click({Enable_Inactive_Users}) # Enable button once function is executed

    $Disable_Individual_User_Button.Add_Click({Disable_Individual_User}) # Enable button once function is executed

    $Label_Title.Location = New-Object System.Drawing.Point(50,40) # Enable button once function is executed

    $Label_Title.Font = 'Verdana,10,style=Bold'

    $OU_Name=$Disable_Users_Dropdown.SelectedItem # Select OU name from dropdown

    $Disable_Users_Button.Text= "Disable all users in $OU_Name"

    $Enable_Users_Button.Text= "Enable all users in $OU_Name"

    $Disable_Individual_Users_Dropdown.Items.Clear() # Clear/reset individual users dropdown to be repopulated

    $OU_Name=$Disable_Users_Dropdown.SelectedItem # Assign OU_Name variable to selected OU from Disable_Users_Dropdown

    # Add users who haven't logged in (inactive users) to Disable_Individual_User_Dropdown and append '(DISABLED)' to their name in the dropdown to signify their status:
    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(DISABLED)")}

    # Add users who haven't logged in (inactive users) to Disable_Individual_User_Dropdown and append '(enabled)' to their name in the dropdown to signify their status:

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(enabled)")}

    # Show inactive users whose accounts are enabled on the left hand side of GUI

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Inactive_Users_Count = $Inactive_Users | Measure-Object # Count number of inactive users
    $Inactive_Users_Count = $Inactive_Users_Count.Count # Add .Count to make this variable callable

    # If there are zeros inactive and enabled users, update Label_Title_1 to signify that to the script user:

    if ($Inactive_Users_Count -eq 0){

    $Label_Title.Text = "No enabled accounts for `r`n users who never logged in."

    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text

    }

    # If there are more than zero inactive enabled users, list the number of inactive enabled users to the script user:

    else{
     
    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text
  
    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text
    }
}

function Disable_Inactive_Users{ # Similar to above function, but allows the user to disable all enabled inactive accounts by selecting an OU from the dropdown and the clicking the "Disable all uers" button:

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Disable-ADAccount

    $Disable_Individual_Users_Dropdown.Items.Clear()

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(DISABLED)")}

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(enabled)")}
    
    $Inactive_Users_Count = $Inactive_Users | Measure-Object
    $Inactive_Users_Count = $Inactive_Users_Count.Count

    if ($Inactive_Users_Count -eq 0){

    $Label_Title.Text = "No enabled accounts for `r`n users who neverlogged in."

    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text

    }

    else{
     
    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text
  
    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text
    }

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name)}

}

function Enable_Inactive_Users{ # Similar to above function, but allows the user to enable all disabled inactive accounts by selecting an OU from the dropdown and the clicking the "Enable all users" button:

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Remove($_.Name)}

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Enable-ADAccount

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Disable_Individual_Users_Dropdown.Items.Clear()

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(DISABLED)")}

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(enabled)")}

    $Label_Title.Text = $Inactive_Users

    $Inactive_Users_Count = $Inactive_Users | Measure-Object
    $Inactive_Users_Count = $Inactive_Users_Count.Count
    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text

    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text
}

function Disable_Individual_User{ # Similar to above function, but allows the user to disable a selected inactive account by selecting a user from the dropdown and the clicking the "Disable this user" button:

    $User_Name=$Disable_Individual_Users_Dropdown.SelectedItem # 

    if ($User_Name -Match "(DISABLED)"){

    $User_Name = $User_Name.replace("(DISABLED)","") # Remove "(DISABLED)" from User_Name in dropdown in order to present it to the script user.

    $Label_Title_4.Text= "$User_Name is already disabled."

    Sleep 0.75

    $Label_Title_4.Text= ""

    }

    if ($User_Name -eq $null){

    $Label_Title_4.Text= "Please select a user from the dropdown."

    Sleep 0.75

    $Label_Title_4.Text= ""

    }

    else{

    $User_Name = $User_Name.replace("(enabled)","") # Need to remove the "(DISABLED)" from the User_Name in the dropdown in order for the cmdlet to correctly find the user in AD.

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$User_Name*" | Disable-ADAccount

    $Label_Title_4.Text= "$User_Name has been disabled."

    Sleep 0.75

    $Label_Title_4.Text= ""

    #Get OU of user

    $Disable_Individual_Users_Dropdown.Items.Clear()

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(DISABLED)")}

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(enabled)")}

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Label_Title.Text = $Inactive_Users

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Inactive_Users_Count = $Inactive_Users | Measure-Object
    $Inactive_Users_Count = $Inactive_Users_Count.Count
    
    if ($Inactive_Users_Count -eq 0){

    $Label_Title.Text = "No enabled accounts for `r`n users who neverlogged in."

    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text

    }

    else{
     
    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text
  
    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text

    }
    }
    }

function Enable_Individual_User{ # Similar to above function, but allows the user to enable a selected inactive account by selecting a user from the dropdown and the clicking the "Enable this user" button:

    $User_Name=$Disable_Individual_Users_Dropdown.SelectedItem

    if ($User_Name -Match "(enabled)"){

    $User_Name = $User_Name.replace("(enabled)","")

    $Label_Title_4.Text= "$User_Name is already enabled."

    Sleep 0.75

    $Label_Title_4.Text= ""

    }

    if ($User_Name -eq $null){

    $Label_Title_4.Text= "Please select a user from the dropdown."

    Sleep 0.75

    $Label_Title_4.Text= ""

    }

    else{

    $User_Name = $User_Name.replace("(DISABLED)","")

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$User_Name*" | Enable-ADAccount

    $Label_Title_4.Text= "$User_Name has been enabled."

    Sleep 0.75

    $Label_Title_4.Text= ""

    #Get OU of user

    $Disable_Individual_Users_Dropdown.Items.Clear()

    $OU_Name=$Disable_Users_Dropdown.SelectedItem

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(DISABLED)")}

    Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | ForEach-Object {$Disable_Individual_Users_Dropdown.Items.Add($_.Name + "(enabled)")}

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Inactive_Users = $Inactive_Users | Out-String
    $Label_Title.Text = $Inactive_Users

    $Label_Title.Text = $Inactive_Users

    $Inactive_Users = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $true)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name

    $Inactive_Users_Count = $Inactive_Users | Measure-Object
    $Inactive_Users_Count = $Inactive_Users_Count.Count
    $Inactive_Users_Count_Text = [string]$Inactive_Users_Count + " active/enabled users that haven't logged in."
    $Label_Title_2.Text = $Inactive_Users_Count_Text

    $Total_Users_Not_Logged_In = Get-ADUser -Filter {(lastlogontimestamp -notlike "*") -and (enabled -eq $false)} | Where-Object DistinguishedName -like "*$OU_Name*" | Select Name
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In | Measure-Object
    $Total_Users_Not_Logged_In_Count = $Total_Users_Not_Logged_In_Count.Count
    $Total_Users_Not_Logged_In_Count_Text = [string]$Total_Users_Not_Logged_In_Count + " disabled users that haven't logged in."
    $Label_Title_3.Text = $Total_Users_Not_Logged_In_Count_Text
    }
    }

$Disable_Users_Dropdown.Add_SelectedIndexChanged({Show_Inactive_Users}) # Change index of the Disable_Users_Dropdown

$Application_Form.ShowDialog() # Show form on runtime

$Application_Form.Dispose() # Garbage collection
