# User defined variables
$tenant = "digitalfortytwo";
$sourceSite = "/sites/PnPDestino";
$pageName = "Pagina-de-Teste-3.aspx";

# Constants
$webUrl = "https://{0}.sharepoint.com{1}" -f $tenant, $sourceSite;

# Office 365 Login 
Write-Output $("Connecting to {0}..." -f $webUrl);
Connect-PnPOnline -Url $webUrl -Interactive;

# Get all WebParts from given page
Write-Output $("Collecting WebParts from {0}..." -f $pageName);
$page = Get-PnPClientSidePage -Identity $pageName;

#Create new WebPart
Add-PnPPageWebPart -Page $page -DefaultWebPartType DocumentEmbed -WebPartProperties @{
    "serverRelativeUrl" = "/sites/PnPDestino/Documentos Compartilhados/Diagrama-3_3872.pptx";
};
