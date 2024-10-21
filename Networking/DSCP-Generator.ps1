Add-Type -AssemblyName System.Windows.Forms #Add .NET framework for Forms

Add-Type -AssemblyName PresentationCore,PresentationFramework #Add .NET framework for
Presentation

$Form = New-Object System.Windows.Forms.Form
$Form.StartPosition = 'CenterScreen'
$Form.Text = "DSCP Generator"
$Form.BackColor = "White"
$Form.Font = 'Verdana,11,style=Bold'

##

$INT_Box = New-Object System.Windows.Forms.TextBox
$INT_Box.Location = New-Object System.Drawing.Point(80,130)
$INT_Box.Size = New-Object System.Drawing.Size(60,20)
$INT_Box.Text = "0"
$INT_Box.Font = 'Microsoft Sans Serif,15'

##

$INT_Box_2 = New-Object System.Windows.Forms.TextBox
$INT_Box_2.Location = New-Object System.Drawing.Point(150,130)
$INT_Box_2.Size = New-Object System.Drawing.Size(60,20)
$INT_Box_2.Text = "0"
$INT_Box_2.Font = 'Microsoft Sans Serif,15'

##

$Description = New-Object system.Windows.Forms.Label
$Description.text = "Generate point to point IPV6 addresses and appropriate configs."
$Description.AutoSize = $false
$Description.width = 450
$Description.height = 50
$Description.location = New-Object System.Drawing.Point(300,500)
$Description.Font = 'Microsoft Sans Serif,10'

[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$DSCP_Base_Image_Path = (get-item "C:\Users\ryans\Desktop\DSCP-Photos\DSCP Default.png")
$DSCP_Base_Image = [System.Drawing.Image]::Fromfile($DSCP_Base_Image_Path);

[System.Windows.Forms.Application]::EnableVisualStyles();

$DSCP_Base_Image_Box = new-object Windows.Forms.PictureBox
$DSCP_Base_Image_Box.Location = New-Object System.Drawing.Size(0,1)
$DSCP_Base_Image_Box.Size = New-Object System.Drawing.Size($DSCP_Base_Image.Width,$DSCP_Base_Image.Height)
$DSCP_Base_Image_Box.Image = $DSCP_Base_Image

function Generate_DSCP_Values {
}

function Copy_Commands_1{

}

$Generate_BTN.Add_Click({ Generate_IPV6_ULA_Addresses })

Generate_IPV6_ULA_Addresses

$Form.Controls.AddRange(@($Description, $Title, $INT_Box, $INT_Box_2, $Commands_BTN_1, $Commands_BTN_2, $Generate_BTN, $DSCP_Base_Image_Box, $Class_Box_1))

$Form.AutoScale = $true
$Form.AutoScaleMode = "Font"
$Form.ShowDialog()
