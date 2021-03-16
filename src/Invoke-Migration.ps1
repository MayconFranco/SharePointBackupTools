[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $SourceTenant,

    [Parameter(Mandatory)]
    [string]
    $DestinationTenant,

    [Parameter(Mandatory)]
    [string]
    $SourceSiteName,

    [Parameter(Mandatory)]
    [string]
    $DestinationSiteName,
    
    [Parameter(Mandatory)]
    [string]
    $DestinationSiteTitle
)
    

Import-Module "$PSScriptRoot\Export-SharePointSiteTemplate.psm1";
Import-Module "$PSScriptRoot\Import-SharePointSiteTemplate.psm1";
Import-Module "$PSScriptRoot\Repair-EmbedDocumentWebParts.psm1";

Write-Verbose "[Invoke-Migration] Starting...";

Export-SharePointSiteTemplate -Tenant $SourceTenant -SiteName $SourceSiteName -Verbose;
Import-SharePointSiteTemplate -Tenant $DestinationTenant -SiteName $DestinationSiteName -SiteTitle $DestinationSiteTitle -Verbose;
Repair-EmbedDocumentWebParts -Tenant $DestinationTenant -SiteName $DestinationSiteName -Verbose;

Write-Verbose "[Invoke-Migration] Done!";
