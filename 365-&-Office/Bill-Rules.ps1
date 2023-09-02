function Bill_Rules{
Connect-ExchangeOnline -UserPrincipalName $env:Outlook_Email

#https://learn.microsoft.com/en-us/powershell/module/exchange/?view=exchange-ps

#https://outlook.office.com/mail/

New-MailBoxFolder -Parent :\Inbox -Name Bills

New-MailBoxFolder -Parent :\Inbox\Bills -Name Eversource

New-MailBoxFolder -Parent :\Inbox\Bills\Eversource -Name Eversource-Invoices

New-MailBoxFolder -Parent :\Inbox\Bills\Eversource -Name Eversource-Receipts

New-InboxRule -Name "Eversource-Receipts" -HeaderContainsWords "Eversource Payment Confirmation" -BodyContainsWords "Eversource", "Confirmation Number:" -MoveToFolder "rviglione:\Inbox\Bills\Eversource\Eversource-Receipts"

New-InboxRule -Name "Eversource-Invoices" -HeaderContainsWords "New Electric Bill from Eversource" -MoveToFolder "rviglione:\Inbox\Bills\Eversource\Eversource-Invoices"

Disconnect-ExchangeOnline

}

Bill_Rules
