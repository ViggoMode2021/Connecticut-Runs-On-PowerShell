# fc00::/7
## First Hextet
Add-Type -AssemblyName System.Windows.Forms #Add .NET framework for Forms

Add-Type -AssemblyName PresentationCore,PresentationFramework #Add .NET framework for
Presentation

$Form = New-Object System.Windows.Forms.Form
$Form.StartPosition = 'CenterScreen'
$Form.Text = "IPV6 Address Generator"
$Form.BackColor = "White"
$Form.Font = 'Verdana,11,style=Bold'

$INT_Box = New-Object System.Windows.Forms.TextBox
$INT_Box.Location = New-Object System.Drawing.Point(80,130)
$INT_Box.Size = New-Object System.Drawing.Size(60,20)
$INT_Box.Text = "type int #"
$INT_Box.Font = 'Microsoft Sans Serif,9.5'

$INT_Box_2 = New-Object System.Windows.Forms.TextBox
$INT_Box_2.Location = New-Object System.Drawing.Point(80,230)
$INT_Box_2.Size = New-Object System.Drawing.Size(60,20)
$INT_Box_2.Text = "type int #"
$INT_Box_2.Font = 'Microsoft Sans Serif,9.5'

$First_INT = $INT_Box.Text

$Description = New-Object system.Windows.Forms.Label
$Description.text = "Generate point to point IPV6 addresses and appropriate configs."
$Description.AutoSize = $false
$Description.width = 450
$Description.height = 50
$Description.location = New-Object System.Drawing.Point(20,50)
$Description.Font = 'Microsoft Sans Serif,10'

function Generate_IPV6_ULA_Addresses {
Clear-Variable IPV6_ULA_1
Clear-Variable IPV6_ULA_2
$FD = "FD"
$Colon = ":"
$Prefix_Length = "/48"

$First_Hextet_chars = @{
1 = [Char[]]'0123456789ABCDEF'
2 = [Char[]]'0123456789ABCDEF'
}
$First_Hextet_1 = Get-Random -Count 1 -InputObject $First_Hextet_chars.1
$First_Hextet_2 = Get-Random -Count 1 -InputObject $First_Hextet_chars.2
$First_Hextet = $First_Hextet_1 + $First_Hextet_2

## Second Hextet
$Second_Hextet_chars = @{
1 = [Char[]]'0123456789ABCDEF'
2 = [Char[]]'0123456789ABCDEF'
3 = [Char[]]'0123456789ABCDEF'
4 = [Char[]]'0123456789ABCDEF'
}
$Second_Hextet_1 = Get-Random -Count 1 -InputObject $Second_Hextet_chars.1
$Second_Hextet_2 = Get-Random -Count 1 -InputObject $Second_Hextet_chars.2
$Second_Hextet_3 = Get-Random -Count 1 -InputObject $Second_Hextet_chars.3
$Second_Hextet_4 = Get-Random -Count 1 -InputObject $Second_Hextet_chars.4
$Second_Hextet = $Second_Hextet_1 + $Second_Hextet_2 + $Second_Hextet_3 + $Second_Hextet_4

## Third Hextet
$Third_Hextet_chars = @{
1 = [Char[]]'0123456789ABCDEF'
2 = [Char[]]'0123456789ABCDEF'
3 = [Char[]]'0123456789ABCDEF'
4 = [Char[]]'0123456789ABCDEF'
}
$Third_Hextet_1 = Get-Random -Count 1 -InputObject $Third_Hextet_chars.1
$Third_Hextet_2 = Get-Random -Count 1 -InputObject $Third_Hextet_chars.2
$Third_Hextet_3 = Get-Random -Count 1 -InputObject $Third_Hextet_chars.3
$Third_Hextet_4 = Get-Random -Count 1 -InputObject $Third_Hextet_chars.4
$Third_Hextet = $Third_Hextet_1 + $Third_Hextet_2 + $Third_Hextet_3 + $Third_Hextet_4

$IPV6_ULA_Prefix = $FD + $First_Hextet + $Colon + $Second_Hextet + $Colon + $Third_Hextet + $Colon
+ $Colon + $Prefix_Length

$global:IPV6_ULA_1 = $FD + $First_Hextet + $Colon + $Second_Hextet + $Colon + $Third_Hextet + $Colon + $Colon + "1" + $Prefix_Length

$global:IPV6_ULA_2 = $FD + $First_Hextet + $Colon + $Second_Hextet + $Colon + $Third_Hextet + $Colon + $Colon + "2" + $Prefix_Length

$Address_1.text = "$global:IPV6_ULA_1"

$Address_2.text = "$global:IPV6_ULA_2"

$global:Random_RID_1 = [IPAddress]::Parse([String] (Get-Random) ).IPAddressToString
$global:Random_RID_2 = [IPAddress]::Parse([String] (Get-Random) ).IPAddressToString
}

function Copy_Commands_1{

$First_INT = $INT_Box.Text

$Cisco_Script =
"en
conf t
ipv6 unicast-routing
ipv6 router ospf 1
router-id $global:Random_RID_1
$First_INT
no sh
ipv6 enable
ipv6 address $global:IPV6_ULA_1
ipv6 ospf 1 area 0
description ** Link to $global:IPV6_ULA_2 **
do wr"

$Cisco_Script | Set-Clipboard
}

function Copy_Commands_2{

$Second_INT = $INT_Box_2.Text

$Cisco_Script_2 =
"en
conf t
ipv6 unicast-routing
ipv6 router ospf 1
router-id $global:Random_RID_2
$Second_INT
no sh
ipv6 enable
ipv6 address $global:IPV6_ULA_2
ipv6 ospf 1 area 0
description ** Link to $global:IPV6_ULA_1 **
do wr
exit
"

$Cisco_Script_2 | Set-Clipboard

}

$Address_1 = New-Object system.Windows.Forms.Label
$Address_1.text = "$IPV6_ULA_1"
$Address_1.AutoSize = $false
$Address_1.width = 150
$Address_1.height = 50
$Address_1.location = New-Object System.Drawing.Point(160,120)
$Address_1.Font = 'Microsoft Sans Serif,10'

$Address_2 = New-Object system.Windows.Forms.Label
$Address_2.text = "$IPV6_ULA_2"
$Address_2.AutoSize = $false
$Address_2.width = 450
$Address_2.height = 50
$Address_2.location = New-Object System.Drawing.Point(160,200)
$Address_2.Font = 'Microsoft Sans Serif,10'

$Commands_BTN_1 = New-Object system.Windows.Forms.Button
$Commands_BTN_1.text = "Copy"
$Commands_BTN_1.width = 90
$Commands_BTN_1.height = 30
$Commands_BTN_1.location = New-Object System.Drawing.Point(310,140)
$Commands_BTN_1.Font = 'Microsoft Sans Serif,8'
$Commands_BTN_1.Add_Click({ Copy_Commands_1 })

$Commands_BTN_2 = New-Object system.Windows.Forms.Button
$Commands_BTN_2.text = "Copy"
$Commands_BTN_2.width = 90
$Commands_BTN_2.height = 30
$Commands_BTN_2.location = New-Object System.Drawing.Point(310,240)
$Commands_BTN_2.Font = 'Microsoft Sans Serif,8'
$Commands_BTN_2.Add_Click({ Copy_Commands_2 })

$Generate_BTN = New-Object system.Windows.Forms.Button
$Generate_BTN.text = "Generate"
$Generate_BTN.width = 90
$Generate_BTN.height = 30
$Generate_BTN.location = New-Object System.Drawing.Point(410,340)
$Generate_BTN.Font = 'Microsoft Sans Serif,8'

$Generate_BTN.Add_Click({ Generate_IPV6_ULA_Addresses })

Generate_IPV6_ULA_Addresses

$Form.Controls.AddRange(@($Description, $Title, $INT_Box, $INT_Box_2, $Address_1,
$Address_2, $Commands_BTN_1, $Commands_BTN_2, $Generate_BTN))

$Form.AutoScale = $true
$Form.AutoScaleMode = "Font"
$Form.ShowDialog()
