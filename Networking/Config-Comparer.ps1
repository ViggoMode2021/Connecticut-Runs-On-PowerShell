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
