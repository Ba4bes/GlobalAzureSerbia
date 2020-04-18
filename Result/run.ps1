using namespace System.Net
<#
.SYNOPSIS
    Collects input and puts it in a CosmosDB
.DESCRIPTION
    Based on the input from a HTML form an object is created
    The object is checked to be unique in the CosmosDB
    After that it is written to CosmosDB and HTML return is given to caller.
.INPUTS
    the output of the FrontPageFunction
.OUTPUTS
    A CosmosDB entry
    An HTML page
.NOTES
    This is part of an Azure Function App made for Global Azure Virtual Serbia
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $CosmosInput)

# The input from the form is collected from the Triggermetadata
$FirstName = $TriggerMetadata.firstName
$LastName  = $TriggerMetadata.lastName
$FullName  = $FirstName + ' ' + $LastName
Write-Output "First Name: $FirstName"
Write-Output "Last Name $LastName"
if ($null -eq $FirstName -or $null -eq $LastName) {
    $status = [HttpStatusCode]::BadRequest
    $body   = "Please enter both a first name and a last name"
}

else {
    # Create a function for the database-entry, that can be called on later

    #Create an object to write to the database.
    $Object = [PSCustomObject]@{
        id        = $FullName
        firstName = $FirstName
        LastName  = $LastName
        FullName  = $FullName
        HasWon    = $False
    }
    # Check if the fullname combination doesn't exist yet
    if (($CosmosInput.id) -contains $FullName) {
        $status = [HttpStatusCode]::BadRequest
        $body = "Someone with the name $FullName has already entered. Please enter with a different name"
    }
    else {
        # Create the output for the HTTP response
        $status = [HttpStatusCode]::OK
        $body = "Thank you $FirstName! Your entry has been added"
        # Push the object to the CosmosDB.
        Push-OutputBinding -Name CosmosOutput -Value $Object
    }
}
$HTMLBody = @"
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
$body
</font>
</div>
</body>
"@
# Give an http response to show if the push to database succeeded
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $status
        ContentType = "text/html"
        Body        = $HTMLBody
    })