# https://appuals.com/fix-general-failure-error-running-ping-commands/ - Source

# Disable IPv6:

netsh int ipv6 isatap set state disabled
netsh int ipv6 6to4 set state disabled
netsh interface teredo set state disable

#

<#

These commands reset following registry keys:

SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ 
SYSTEM\CurrentControlSet\Services\DHCP\Parameters\ 

# netsh i i r r is shorthand for netsh int ip reset resetlog.txt

#>

netsh int ip reset resetlog.txt
netsh int ip reset c:\tcp.txt
netsh winsock reset

# Flush DNS resolver cache:

ipconfig /flushdns

# Restart Computer:

Restart-Computer
