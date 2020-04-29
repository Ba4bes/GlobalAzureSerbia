# GlobalAzureSerbia

This app is created for Global Azure Virtual: Serbia

## Functions

- **Frontpage**  
  The front page of the app with a HTML web form. Output is send to the result page
- **Result**  
  The input from front page is collected and written to a CosmosDB
- **GetWinner**  
  The data from the CosmosDB is called and given as output in an HTML output.
  It is also send to a logic app so it can be mailed.

## Calling the app

Open <https://globalazurevirtualserbia.azurewebsites.net/FrontPage> in a browser to enter.  
The winner page can only be opened with a function code.

## Try it yourself

The function app can be deployed as is. To make it functional, some settings need to be completed:

- A Connection with CosmosDB needs to be made
- The following environment variables need to be set:
  - receiverEmail: the email address that needs the updates
  - LogicAppURL: The URL of the logic app that needs to be called

## Other services

### CosmosDB

A CosmosDB is used to store the data  
<https://azure.microsoft.com/nl-nl/services/cosmos-db/>

### Logic App

A logic app is used to make it possible to send an email.  
[More information here](https://4bes.nl/2020/01/05/send-email-from-powershell-with-a-logic-app/)

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/category/serverless/')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
