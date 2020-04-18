using namespace System.Net
<#
.SYNOPSIS
    This Function calls a html-form where the user can give an input
.DESCRIPTION
    An HTMLform is returned to the user.
    The input is then given to the second function called "Result"
.INPUTS
    a webrequest through a browser
.OUTPUTS
    an HTML page with a form
.NOTES
    This is part of an Azure Function App made for Global Azure Virtual Serbia
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."

# Get the FunctionAppURL for the resultFunction
Write-Host $TriggerMetadata.request.url
$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "FrontPage", "Result"

# To get the input from the user, a simple HTMLform is used.
$Form = @"
<html>
<head>
<style>
.header {
    padding: 20px;
    text-align: center;
    background: #008AD7;
    color: white;
    font-size: 30px;
}
.form {
    padding: 20px;
    text-align: center;
    background: white;
    color: black;
    font-size: 24px;
}
</style>
</head><body>
<div class="header">
<h1>Global Azure Virtual: Serbia</h1>
<p>Enter the raffle!</p>
</div>
<div class="form">

Enter your name to win!<br><br>
<form action='$FunctionAppUrl'>
First name: <input type='text' name='firstName'><br>
Last name: <input type='text' name='lastName'><br><br>
<input type='submit' value='Submit'>
</form>
<p>
</div>
</body>
"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $Form
    })
