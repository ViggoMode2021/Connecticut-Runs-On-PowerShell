New-NetFirewallRule -DisplayName "TFTP inbound" -Direction Inbound -LocalPort 69 -Protocol UDP -Action Allow

New-NetFirewallRule -DisplayName "TFTP outbound" -Direction Outbound -LocalPort 69 -Protocol UDP -Action Allow
