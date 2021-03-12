﻿# User defined variables
$tenant = "digitalfortytwo";
$sourceSite = "/sites/PnPFonte";
$templateName = "Template de Testes";

# Constants
$webUrl = "https://{0}.sharepoint.com{1}" -f $tenant, $sourceSite;
$resultFolder = ".\Result"
$templatePath = $("{0}\Template.xml" -f $resultFolder);

# Remove old templates
if (Test-Path $resultFolder) {
    Remove-Item $resultFolder -Force  -Recurse -ErrorAction SilentlyContinue;
}

# Office 365 Login 
Write-Output $("Connecting to {0}..." -f $webUrl);
Connect-PnPOnline -Url $webUrl -Interactive;
     
# Save Template
Write-Output $("Saving PnP template to {0}..." -f $templatePath);
Get-PnPSiteTemplate `
    -Out $templatePath `
    -IncludeAllTermGroups `
    -IncludeSiteCollectionTermGroup `
    -IncludeSiteGroups `
    -PersistBrandingFiles `
    -PersistPublishingFiles `
    -IncludeNativePublishingFiles `
    -IncludeAllPages `
    -TemplateDisplayName $templateName `
    -Handlers All `
    -Schema LATEST `
    -Force;