Function Test-PnPSiteExists {
    param (
        [String]
        $Url
    )
    try {
        Test-PnPSite -Identity $url -ErrorAction Stop;
        return $true;
    }
    catch {
        return $false;
    }
}


# User defined variables
$tenant = "digitalfortytwo";

# Constants
$destinationName = "PnP Destino";
$destinationSite = "PnPDestino";
$webUrl = "https://{0}.sharepoint.com" -f $tenant;
$templatePath = ".\Result\Backup.xml";

# Office 365 Login 
Write-Output $("Connecting to {0}..." -f $webUrl);
Connect-PnPOnline -Url $webUrl -Interactive;

# Check if destination site already exists, if so, replace it.
Write-Output $("Checking if site {0} already exists..." -f $destinationName);
$destinationUrl = "https://{0}.sharepoint.com/sites/{1}" -f $tenant, $destinationSite;
if (Test-PnPSiteExists -Url $destinationUrl) {
    Write-Output "Site already exists, replacing it...";
    Remove-PnPTenantSite -Url $destinationUrl -Force -SkipRecycleBin;
}
else {
    Write-Output "Site doesn't exists, creating a new one...";   
}

# Create new site
New-PnPSite -Type CommunicationSite -Title $destinationName -SiteDesign Blank -Url $destinationUrl -Lcid 2070 -Wait | Out-Null;

# Connect to the new site
Connect-PnPOnline -Url $destinationUrl -Interactive;

# Apply template from backup
Write-Output "Applying template...";
Invoke-PnPSiteTemplate -Path $templatePath;