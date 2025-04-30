#https://stackoverflow.com/questions/68434190/modifying-compare-object-output-file-content


#https://stackoverflow.com/questions/68434190/modifying-compare-object-output-file-content

Compare-Object -ReferenceObject (Get-Content ".\switch-config.txt") -DifferenceObject (Get-Content ".\switch-config-2.txt") | ForEach-Object {

    if ($_.SideIndicator -eq "<=") {

        $First_Config_File_Differences = $_.InputObject + " is in config 1"

    }

    else {

        $Second_Config_File_Differences = $_.InputObject + " is in config 2"
    
    }

    [PSCustomObject]@{
        Config_One = $First_Config_File_Differences
        Config_Two = $Second_Config_File_Differences
    }

}

#>

# Load Fortinet config from file
$fortinetConfigPath = "C:\Configs\fortinet_config.txt"
$configLines = Get-Content $fortinetConfigPath

# Parse address objects (name to IP/subnet mapping)
function Parse-FortinetAddressObjects {
    param([string[]]$Lines)
    $addresses = @{}
    $currentName = ""
    $currentSubnet = ""

    foreach ($line in $Lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^edit "(.*?)"$') {
            $currentName = $Matches[1]
        }
        elseif ($trimmed -match '^set subnet (\d{1,3}(?:\.\d{1,3}){3}) (\d{1,3}(?:\.\d{1,3}){3})$') {
            $ip = $Matches[1]
            $mask = $Matches[2]
            $addresses[$currentName] = "$ip $mask"
        }
        elseif ($trimmed -eq "next") {
            $currentName = ""
            $currentSubnet = ""
        }
    }

    return $addresses
}

# Summarize policies with optional IP resolution
function Summarize-FortinetPolicies {
    param(
        [string[]]$ConfigLines,
        [hashtable]$AddressBook
    )

    $policies = @()
    $currentPolicy = @{
        ID = ""
        SrcIntf = ""
        DstIntf = ""
        SrcAddr = ""
        DstAddr = ""
        Service = ""
        Action = ""
        NAT = ""
    }

    foreach ($line in $ConfigLines) {
        $trimmed = $line.Trim()

        if ($trimmed -match '^edit (\d+)$') {
            $currentPolicy["ID"] = $Matches[1]
        }
        elseif ($trimmed -match '^set srcintf "(.*?)"$') {
            $currentPolicy["SrcIntf"] = $Matches[1]
        }
        elseif ($trimmed -match '^set dstintf "(.*?)"$') {
            $currentPolicy["DstIntf"] = $Matches[1]
        }
        elseif ($trimmed -match '^set srcaddr "(.*?)"$') {
            $addr = $Matches[1]
            $currentPolicy["SrcAddr"] = if ($AddressBook.ContainsKey($addr)) { "$addr ($($AddressBook[$addr]))" } else { $addr }
        }
        elseif ($trimmed -match '^set dstaddr "(.*?)"$') {
            $addr = $Matches[1]
            $currentPolicy["DstAddr"] = if ($AddressBook.ContainsKey($addr)) { "$addr ($($AddressBook[$addr]))" } else { $addr }
        }
        elseif ($trimmed -match '^set service "(.*?)"$') {
            $currentPolicy["Service"] = $Matches[1]
        }
        elseif ($trimmed -match '^set action (accept|deny)$') {
            $currentPolicy["Action"] = $Matches[1]
        }
        elseif ($trimmed -match '^set nat (enable|disable)$') {
            $currentPolicy["NAT"] = $Matches[1]
        }
        elseif ($trimmed -eq "next") {
            $policies += [PSCustomObject]@{
                ID       = $currentPolicy["ID"]
                Source   = "$($currentPolicy["SrcIntf"]) / $($currentPolicy["SrcAddr"])"
                Dest     = "$($currentPolicy["DstIntf"]) / $($currentPolicy["DstAddr"])"
                Service  = $currentPolicy["Service"]
                Action   = $currentPolicy["Action"]
                NAT      = $currentPolicy["NAT"]
            }

            # Reset for next policy
            $currentPolicy = @{
                ID = ""
                SrcIntf = ""
                DstIntf = ""
                SrcAddr = ""
                DstAddr = ""
                Service = ""
                Action = ""
                NAT = ""
            }
        }
    }

    return $policies
}

# Step 1: Parse address book
$addressBook = Parse-FortinetAddressObjects -Lines $configLines

# Step 2: Summarize firewall policies
$policySummary = Summarize-FortinetPolicies -ConfigLines $configLines -AddressBook $addressBook

# Step 3: Display summary
Write-Host "`n=== Fortinet Policy Summary ===" -ForegroundColor Cyan
$policySummary | Format-Table -AutoSize

