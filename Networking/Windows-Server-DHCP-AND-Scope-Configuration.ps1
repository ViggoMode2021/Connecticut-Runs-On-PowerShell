# DHCP Server & Scope Configuration #

$DHCP_Server_IP = Get-DhcpServerInDC | Select-Object -ExpandProperty IPAddress

$DHCP_Server_DNS_Hostname = Get-DhcpServerInDC | Select-Object -ExpandProperty DnsName

Write-Host "The IP for $DHCP_Server_DNS_Hostname is $DHCP_Server_IP." -ForegroundColor Yellow

Get-DhcpServerv4Scope

Write-Host "Here is your client information:"

Get-DHCPserverv4Scope | Get-DhcpServerv4Lease

############################################################################################

# Creating scope for VLAN 10

$Scope_Params = @{
  Name = "VLAN 10"
  StartRange = "192.168.10.2" # Class A ip address range
  EndRange = "192.168.10.4"
  SubnetMask = "255.255.255.0" # /24 Cidr 
  State = "Active"
}

Add-DHCPServerv4Scope @Scope_Params

# Adding router for VLAN 10

$Scope_Id = "192.168.10.0"
$Router = "192.168.10.1" # Default Gateway for VLAN 10 DHCP scope

Set-DHCPServerv4OptionValue -ScopeId $Scope_Id -Router $Router

Write-Host "Created VLAN 10" -ForegroundColor Green

############################################################################################

# Creating scope for VLAN 20

$Scope_Params = @{
  Name = "VLAN 20"
  StartRange = "192.168.20.2" # Class A ip address range
  EndRange = "192.168.20.4"
  SubnetMask = "255.255.255.0" # /24 Cidr 
  State = "Active"
}

Add-DHCPServerv4Scope @Scope_Params

# Adding router for VLAN 20

$Scope_Id = "192.168.20.0"
$Router = "192.168.20.1" # Default Gateway for VLAN 20 DHCP scope

Set-DHCPServerv4OptionValue -ScopeId $Scope_Id -Router $Router

Write-Host "Created VLAN 20" -ForegroundColor Green