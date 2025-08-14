# Folder with your 'show ip route' outputs
$routeFilesPath = "C:\NetworkRoutes"
$outputCsv = "C:\NetworkRoutes\RouteOverlapDetailed.csv"

function Convert-IPToBinary {
    param ([string]$ip)
    return ($ip.Split('.') | ForEach-Object { [Convert]::ToString($_, 2).PadLeft(8, '0') }) -join ''
}

function Test-SubnetContainment {
    param (
        [string]$child,
        [string]$parent
    )
    $childIP, $childPrefix   = $child -split '/'
    $parentIP, $parentPrefix = $parent -split '/'

    if ([int]$childPrefix -lt [int]$parentPrefix) { return $false }

    $childBin  = Convert-IPToBinary $childIP
    $parentBin = Convert-IPToBinary $parentIP

    return ($childBin.Substring(0, [int]$parentPrefix) -eq $parentBin.Substring(0, [int]$parentPrefix))
}

$results = @()

Get-ChildItem -Path $routeFilesPath -Filter *.txt | ForEach-Object {
    $hostname = $_.BaseName
    $lines = Get-Content $_.FullName

    $statics = @()
    $ospfRoutes = @()

    foreach ($line in $lines) {
        # Static route
        if ($line -match "^\s*S\s+(\d+\.\d+\.\d+\.\d+)/(\d+)") {
            $statics += "$($matches[1])/$($matches[2])"
        }
        # OSPF with type (O, O IA, O E2, etc.)
        elseif ($line -match "^\s*O(\s+\w+)?\s+(\d+\.\d+\.\d+\.\d+)/(\d+)") {
            $type = "O" + ($matches[1] -replace "\s+", " ")  # Keep type string like "O IA" or "O E2"
            $ospfRoutes += [PSCustomObject]@{
                Prefix = "$($matches[2])/$($matches[3])"
                Type   = $type.Trim()
            }
        }
    }

    # Compare statics to OSPF
    foreach ($static in $statics) {
        $duplicate = $false
        $matchType = ""

        foreach ($ospf in $ospfRoutes) {
            if ($static -eq $ospf.Prefix -or (Test-SubnetContainment $ospf.Prefix $static)) {
                $duplicate = $true
                $matchType = $ospf.Type
                break
            }
        }

        $results += [PSCustomObject]@{
            Hostname        = $hostname
            StaticRoute     = $static
            DuplicateInOSPF = if ($duplicate) { "YES" } else { "NO" }
            OSPFType        = if ($duplicate) { $matchType } else { "" }
        }
    }
}

$results | Export-Csv -Path $outputCsv -NoTypeInformation
Write-Host "Detailed report saved to $outputCsv"
