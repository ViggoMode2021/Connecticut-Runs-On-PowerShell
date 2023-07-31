function My_Own_IP{

calc

$IP = Get-NetIpAddress | Where { $_.InterfaceAlias -EQ "Wi-Fi" -and $_.AddressFamily -EQ "IPv4" } | Select -expand IPAddress

$IP_in_Binary = -join ($IP.split(".") | foreach-object {[system.convert]::tostring($_, 2).padleft(8, "0")})

$IP_in_Binary = [string]$IP_in_Binary

$Binary_Length = $IP_in_Binary.length

$Octets = $IP.Split(".")

$1st_octet = $Octets[0] = [string]([int]$Octets[0])

$2nd_octet = $Octets[1] = [string]([int]$Octets[1])

$3rd_octet = $Octets[2] = [string]([int]$Octets[2])

$4th_octet = $Octets[3] = [string]([int]$Octets[3]) 

Write-Host "Your answer needs to be $Binary_Length digits long." -ForeGroundColor "Cyan"

Write-Host "Your ip address is $IP `nPlease calculate it in binary." -ForeGroundColor "Green"

Write-Host "Here is the binary conversion chart: `n128, 64, 32, 16, 8, 4, 2, 1" -ForegroundColor "Yellow"

# FIRST OCTET PROBLEM #d

Write-Host "Write the first octet ($1st_octet) in binary." -ForeGroundColor "Cyan"

$Answer_First_Octet = Read-Host "Please type your answer"

$IP_in_Binary_First_Octet = $IP_in_Binary.substring(0,8)

if($Answer_First_Octet -eq $IP_in_Binary_First_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{
                                                                
Write-Host "Incorrect, the answer is $IP_in_Binary_First_Octet" -ForegroundColor "Red" 
                                                                

}

# SECOND OCTET PROBLEM #

Write-Host "Write the second octet ($2nd_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Second_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Second_Octet = $IP_in_Binary.substring(8,8) 

if($Answer_Second_Octet -eq $IP_in_Binary_Second_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Second_Octet" -ForegroundColor "Red"

}

# THIRD OCTET PROBLEM #

Write-Host "Write the third octet ($3rd_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Third_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Third_Octet = $IP_in_Binary.substring(16,8) 

if($Answer_Third_Octet -eq $IP_in_Binary_Third_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Third_Octet" -ForegroundColor "Red"

}

# Fourth OCTET PROBLEM #

Write-Host "Write the fourth octet ($4th_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Fourth_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Fourth_Octet = $IP_in_Binary.substring($Binary_Length - 8)

if($Answer_Fourth_Octet -eq $IP_in_Binary_Fourth_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Fourth_Octet" -ForegroundColor "Red"

}
}

function Get-Random_Website_IP{

calc

$Websites = "store.steampowered.com", "dunkindonuts.com", "github.com", "youtube.com", "ct.gov", "amazon.com"

$Website = $Websites | Get-Random

$IP = Resolve-DNSName $Website | Select -expand ipaddress -last 1

$IP_in_Binary = -join ($IP.split(".") | foreach-object {[system.convert]::tostring($_, 2).padleft(8, "0")})

$IP_in_Binary = [string]$IP_in_Binary

$Binary_Length = $IP_in_Binary.length

$Octets = $IP.Split(".")

$1st_octet = $Octets[0] = [string]([int]$Octets[0])

$2nd_octet = $Octets[1] = [string]([int]$Octets[1])

$3rd_octet = $Octets[2] = [string]([int]$Octets[2])

$4th_octet = $Octets[3] = [string]([int]$Octets[3]) 

Write-Host "Your answer needs to be $Binary_Length digits long." -ForeGroundColor "Cyan"

Write-Host "The ip address for $Website is $IP `nPlease calculate it in binary." -ForeGroundColor "Green"

Write-Host "Here is the binary conversion chart: `n128, 64, 32, 16, 8, 4, 2, 1" -ForegroundColor "Yellow"

# FIRST OCTET PROBLEM #

Write-Host "Write the first octet ($1st_octet) in binary." -ForeGroundColor "Cyan"

$Answer_First_Octet = Read-Host "Please type your answer"

$IP_in_Binary_First_Octet = $IP_in_Binary.substring(0,8)

if($Answer_First_Octet -eq $IP_in_Binary_First_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{
                                                                
Write-Host "Incorrect, the answer is $IP_in_Binary_First_Octet" -ForegroundColor "Red" 
                                                                

}

# SECOND OCTET PROBLEM #

Write-Host "Write the second octet ($2nd_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Second_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Second_Octet = $IP_in_Binary.substring(8,8) 

if($Answer_Second_Octet -eq $IP_in_Binary_Second_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Second_Octet" -ForegroundColor "Red"

}

# THIRD OCTET PROBLEM #

Write-Host "Write the third octet ($3rd_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Third_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Third_Octet = $IP_in_Binary.substring(16,8) 

if($Answer_Third_Octet -eq $IP_in_Binary_Third_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Third_Octet" -ForegroundColor "Red"

}

# Fourth OCTET PROBLEM #

Write-Host "Write the fourth octet ($4th_octet) in binary." -ForeGroundColor "Cyan"

$Answer_Fourth_Octet = Read-Host "Please type your answer"

$IP_in_Binary_Fourth_Octet = $IP_in_Binary.substring($Binary_Length - 8)

if($Answer_Fourth_Octet -eq $IP_in_Binary_Fourth_Octet){

Write-Host "Correct!!!" -ForegroundColor "Green"

}

else{

Write-Host "Incorrect, the answer is $IP_in_Binary_Fourth_Octet" -ForegroundColor "Red"

}
}

## IP BINARY GAME MAIN ##

$Date = Get-Date -Format "MM-dd-yyyy"

Write-Host "Welcome to The IP Binary Game. You will receive a few networking questions for today, $Date." -ForegroundColor Yellow

$IP_Choice = Read-Host "Would you like to practice converting your own IP to binary (press 1) or let the game ranndomly pick an IP address of a popular web server for you (press 2)?"

if($IP_Choice -eq "1"){

My_Own_IP

}

if($IP_Choice -eq "2"){

Get-Random_Website_IP

}
