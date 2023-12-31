#########################################
#      -  BrowsEnder Version 1.0  -     #
#                                       #
#         Author - Ryan Viglione        #
#########################################

Add-Type -AssemblyName System.Windows.Forms

Add-Type -AssemblyName PresentationCore, PresentationFramework

$Is_Browser_Open = Get-Process -Name '*edge*' | Where-Object { $_.MainWindowHandle -gt 0 }

$BrowsEnder_Window = New-Object System.Windows.Forms.Form

$BrowsEnder_Window.StartPosition = 'CenterScreen'

$BrowsEnder_Window.Text = "BrowsEnder"

$BrowsEnder_Window.BackColor = "White"

$BrowsEnder_Window.Font = 'Verdana,11,style=Bold'

$Label_Object = [System.Windows.Forms.Label]

$Date = Get-Date

$Body = New-Object $Label_Object

$Body.Text = "BrowsEnder `nstarted on `n`n$Date"

$Body.AutoSize = $true

$Body.Font = 'Verdana,10,style=Bold'

$Body.Location = New-Object System.Drawing.Point(0, 0)

$BrowsEnder_Window.FormBorderStyle = 'FixedDialog'

$BrowsEnder_Window.AutoScale = $false

$BrowsEnder_Window.MaximizeBox = $false

$BrowsEnder_Window.Controls.Add($Body)

$BrowsEnder_Window.ShowDialog()

if ($null -eq $Is_Browser_Open) {

    $Okay_Button = [System.Windows.MessageBoxButton]::Ok

    $Warning_Icon = [System.Windows.MessageBoxImage]::Warning
    
    $Message_Box_Title = "BrowsEnder - Browser not detected open."
    
    $Message_Box_Body = "A browser must be open in order to run BrowsEnder."

    [System.Windows.MessageBox]::Show($Message_Box_Body, $Message_Box_Title, $Okay_Button, $Warning_Icon)

}

$Okay_Button = [System.Windows.MessageBoxButton]::Ok

$Warning_Icon = [System.Windows.MessageBoxImage]::Warning

$Message_Box_Title = "BrowsEnder Warning!"

$Message_Box_Body = "You typed a word from your shutdown words list!"

$AppData_Local_Path = "C:\Users\$Env:USERNAME\AppData\Local"

$BrowsEnder_AppData_Path = "$AppData_Local_Path\BrowsEnder"

$BrowsEnder_Keylog_Path = "$BrowsEnder_AppData_Path\keylog-session.txt"

$BrowsEnder_Shutdown_Words_Path = Get-Content "$BrowsEnder_AppData_Path\BrowsEnder-Shutdown-Words.csv"

$Keylogger_Contents = Get-Content -Path $BrowsEnder_Keylog_Path

$Browsers = @("msedge", "chrome", "firefox", "brave")

if ((Test-Path $BrowsEnder_AppData_Path) -eq $False) { 
    
    New-Item -Path $AppData_Local_Path -Name "BrowsEnder" -ItemType Directory

}
 
if ((Test-Path $BrowsEnder_Keylog_Path) -eq $False) { 
    
    New-Item $BrowsEnder_Keylog_Path 
}

# user 32 dll file that contains Windows APIs for keyboard access via the kernel:

$Signatures = @' 
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

    
$API = Add-Type -MemberDefinition $Signatures -Name 'Win32' -Namespace API -PassThru
function BrowsEnder {

    try {
        
        while ((Test-Path $BrowsEnder_Keylog_Path) -ne $false -and (Get-Process -Name '*edge*' | Where-Object { $_.MainWindowHandle -gt 0 })) {

            Start-Sleep -Milliseconds 40
            
            for ($ascii = 9; $ascii -le 254; $ascii++) {
                
                $state = $API::GetAsyncKeyState($ascii)

                if ($state -eq -32767) {
                    $null = [console]::CapsLock
                    
                    $virtualKey = $API::MapVirtualKey($ascii, 3)

                    $kbstate = New-Object -TypeName Byte[] -ArgumentList 256

                    $checkkbstate = $API::GetKeyboardState($kbstate)

                    $mychar = New-Object -TypeName System.Text.StringBuilder
                    
                    $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

                    if ($success -and (Test-Path $BrowsEnder_Keylog_Path) -eq $true) {
                       
                        [System.IO.File]::AppendAllText($BrowsEnder_Keylog_Path, $mychar, [System.Text.Encoding]::Unicode)

                        $Keylogger_Contents = Get-Content -Path $BrowsEnder_Keylog_Path

                        foreach ($Word in $BrowsEnder_Shutdown_Words_Path) {

                            if ($Keylogger_Contents | Select-String -Pattern $Word) {

                                [System.Windows.MessageBox]::Show($Message_Box_Body, $Message_Box_Title, $Okay_Button, $Warning_Icon)
                                Stop-Process -Name "msedge"
                                Stop-Process -Name "chrome"
                                Stop-Process -Name "brave"
                                Stop-Process -Name "firefox"
                                Remove-Item $BrowsEnder_Keylog_Path -Force
                            }
                        }

                    }
                }
            }
        }
    }

    finally { 
    
        exit 
    }

}

BrowsEnder
