using namespace System.Net
<#
.SYNOPSIS
    This Azure Function App selects a random entry from a CosmosDB
.DESCRIPTION
    A random entry is picked from a CosmosDB
    The entry is returned in an HTML output, as well as emailed
.INPUTS
    An HTTP request through a webbrowser
.OUTPUTS
    an HTML page
    a http request to a logic app to send the email
.NOTES
    This is part of an Azure Function App made for Global Azure Virtual Serbia
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $CosmosInput )

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Host "Total number of candidates: $($CosmosInput.count)"

# Select only accounts that have not won before
[array]$Candidates = $CosmosInput | Where-Object { $_.HasWon -ne $true }

# Change the output if there are not entries in the CosmosDB
if ($Candidates.Count -eq 0) {
    $noWinner = $true
    $WinnerName = "No candidates left :("
}
else {
    $Winner = ($Candidates | Get-Random -Count 1)
    $WinnerName = $Winner.FullName
}
Write-output "Winner: $WinnerName"
# Create HTML output for the results
$HTML = @"
<head>
<style>
.header {
    padding: 20px;
    text-align: center;
    background: #008AD7;
    color: white;
    font-size: 30px;
}
.Winner {
    padding: 20px;
    text-align: center;
    background: white;
    color: black;
    font-size: 30px;
}
</style>
</head><body>
<div class="header">
<h1>Global Azure Virtual: Serbia</h1>
<p>We have a winner!</p>
</div>
<div class="Winner">
Congratulations!<br><br>
<h1> $WinnerName</h1>
</div>
"@

# Change the HasWon value for the winner in the CosmosDB
$Winner.HasWon = $true
Push-OutputBinding -Name CosmosOutput -Value $Winner

if ($noWinner -ne $true) {
    # Send an email by calling a logic app that is HTTP triggered
    $emailBodyHTML = @"
    The following winner has been selected for the raffle:<p>$WinnerName<p>

"@
    $EmailBody = [PSCustomObject]@{
        To      = "$ENV:receiverEmail"
        Subject = "A winner has been selected"
        Body    = $emailBodyHTML
    }
    $URL = $ENV:LogicAppURL
    Invoke-RestMethod -Method POST -Uri $URL -Body ($EmailBody | ConvertTo-Json) -ContentType 'application/json'
}

#Give an HTML output back to the caller
Push-OutputBinding -Name Response -Value (@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $HTML
    })