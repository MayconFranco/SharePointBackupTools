[CmdletBinding()]
param (
    # Tenant of the source site.
    [Parameter(Mandatory)]
    [string]
    $SourceTenant,

    # Tenant of the destination site.
    [Parameter(Mandatory)]
    [string]
    $DestinationTenant,

    # Source site name.
    [Parameter(Mandatory)]
    [string]
    $SourceSiteName,

    # Destination site name.
    [Parameter(Mandatory)]
    [string]
    $DestinationSiteName,
    
    # Destination site title.
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
