Import-Module "$PSScriptRoot\Utils.psm1";

function Import-SharePointSiteTemplate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Tenant,
        
        [Parameter(Mandatory)]
        [string]
        $SiteName,

        [Parameter(Mandatory)]
        [string]
        $SiteTitle
    )
    
    begin {
        # Constants
        $WebUrl = "https://{0}.sharepoint.com" -f $Tenant;
        $TemplatePath = ".\Result\Template.xml";

        # Office 365 Login 
        Write-Verbose $("[Import-SharePointSiteTemplate] Connecting to {0}..." -f $WebUrl);
        Connect-PnPOnline -Url $WebUrl -Interactive;
    }
    
    process {
        # Check if destination site already exists, if so, replace it.
        Write-Verbose $("[Import-SharePointSiteTemplate] Checking if site {0} already exists..." -f $SiteTitle);
        $destinationUrl = "https://{0}.sharepoint.com/sites/{1}" -f $Tenant, $SiteName;
        if (Test-SiteExists -Url $destinationUrl) {
            Write-Verbose "[Import-SharePointSiteTemplate] Site already exists, replacing it...";
            Remove-PnPTenantSite -Url $destinationUrl -Force -SkipRecycleBin;

            # Wait 1 minute because SharePoint is lazy as fuck
            Start-Sleep -Seconds 60;
        }
        else {
            Write-Verbose "[Import-SharePointSiteTemplate] Site doesn't exists, creating a new one...";   
        }

        # Create new site
        New-PnPSite -Type CommunicationSite -Title $SiteTitle -SiteDesign Blank -Url $destinationUrl -Lcid 2070 -Wait | Out-Null;

        # Wait 1 minute, again
        Start-Sleep -Seconds 60;

        # Connect to the new site
        Connect-PnPOnline -Url $destinationUrl -Interactive;

        # Apply template from backup
        Write-Verbose "[Import-SharePointSiteTemplate] Importing template...";
        Invoke-PnPSiteTemplate -Path $TemplatePath -ClearNavigation;
    }
    
    end {
        Write-Verbose "[Import-SharePointSiteTemplate] Done!";
    }
}

Export-ModuleMember -Function Import-SharePointSiteTemplate;