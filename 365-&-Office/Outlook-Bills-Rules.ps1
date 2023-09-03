#https://learn.microsoft.com/en-us/powershell/module/exchange/?view=exchange-ps

#https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell?view=exchange-ps

#https://outlook.office.com/mail/

function Create_Exchange_Folders_and_Rules {

    Connect-ExchangeOnline -UserPrincipalName $env:Outlook_Email

    New-MailBoxFolder -Parent :\Inbox -Name Bills

    $Bill_Companies = @("Breezeline", "Eversource")

    foreach ($Bill in $Bill_Companies) {

        New-MailBoxFolder -Parent :\Inbox\Bills -Name $Bill

        New-MailBoxFolder -Parent :\Inbox\Bills\$Bill -Name "$Bill-Invoices"

        New-MailBoxFolder -Parent :\Inbox\Bills\$Bill -Name "$Bill-Receipts"

    }

    $Eversource_Invoice_Params = @{
        Name              = "Eversource-Invoices"
        BodyContainsWords = "New Electric Bill from Eversource"
        MoveToFolder      = "rviglione:\Inbox\Bills\Eversource\Eversource-Invoices"
    }
  
    New-InboxRule @Eversource_Invoice_Params

    $Eversource_Receipt_Params = @{
        Name                = "Eversource-Receipts"
        HeaderContainsWords = "Eversource Payment Confirmation"
        BodyContainsWords   = "Eversource", "Confirmation Number:"
        MoveToFolder        = "rviglione:\Inbox\Bills\Eversource\Eversource-Receipts"
    }
  
    New-InboxRule @Eversource_Receipt_Params

    # Breezeline Rules:

    $Breezeline_Invoice_Params = @{
        Name              = "Breezeline-Invoices"
        BodyContainsWords = "Your Breezeline statement is ready"
        MoveToFolder      = "rviglione:\Inbox\Bills\Breezeline\Breezeline-Invoices"
    }
  
    New-InboxRule @Breezeline_Invoice_Params

    $Breezeline_Receipt_Params = @{
        Name                = "Breezeline-Receipts"
        HeaderContainsWords = "We received your Breezeline payment"
        MoveToFolder        = "rviglione:\Inbox\Bills\Breezeline\Breezeline-Receipts"
    }
  
    New-InboxRule @Breezeline_Receipt_Params

    Disconnect-ExchangeOnline

    $Mailbox_Folders = Get-MailboxFolder

    $Mailbox_Rules = Get-MailboxRules

    Write-Host "Mailbox folders for $env:Outlook_Email are: $Mailbox_Folders" -ForegroundColor Green

    Write-Host "Mailbox rules for $env:Outlook_Email are: $Mailbox_Rules" -ForegroundColor Green
}

Create_Exchange_Folders_and_Rules
