$New_DHCP_Server = ""

Import-DhcpServer -ComputerName $New_DHCP_Server
  -File "C:\Backups\DHCPConfig.xml" `
  -BackupPath "C:\Backups" `
  -Leases -Force
