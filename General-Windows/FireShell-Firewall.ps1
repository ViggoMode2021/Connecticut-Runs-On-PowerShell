# FireShell

# This script will recursively block all IP addresses associated with the websites below. 

# You can view and alter these settings via Windows Defender Firewall with Advanced Security.

$Adult_Websites = "pornhub.com", "xvideos.com", "xnxx.com", "youporn.com", "xhamster.com", "hqporner.com",  "pornpics.com"

foreach ($Website in $Adult_Websites){

$IP_Addresses = Resolve-DnsName $Website | Select -Expand IPAddress

$IP_Count = $IP_Addresses | Measure-Object | Select -expand Count

Write-Host "Blocking all $IP_Count IP addresses associated with $Website." -ForeGroundColor "Cyan"

foreach ($IP in $IP_Addresses){

New-NetFirewallRule -DisplayName "Block $Website HTTPS" -Direction Outbound -RemotePort 443 -Protocol TCP -Action Block -RemoteAddress $IP

Write-Host "Successfully blocked $Website" -ForeGroundColor "Green"

}

}

$Social_Media_Webistes = "facebook.com", "instagram.com", "myspace.com", "linkedin.com", "discord.com", "reddit.com", "4chan.com"

foreach ($Website in $Social_Media_Webistes){

$IP_Addresses = Resolve-DnsName $Website | Select -Expand IPAddress

$IP_Count = $IP_Addresses | Measure-Object | Select -expand Count

Write-Host "Blocking all $IP_Count IP addresses associated with $Website." -ForeGroundColor "Cyan"

foreach ($IP in $IP_Addresses){

New-NetFirewallRule -DisplayName "Block $Website HTTPS" -Direction Outbound -RemotePort 443 -Protocol TCP -Action Block -RemoteAddress $IP

Write-Host "Successfully blocked $Website" -ForeGroundColor "Green"

}

}
