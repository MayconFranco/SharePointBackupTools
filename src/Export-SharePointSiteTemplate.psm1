function Export-SharePointSiteTemplate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Tenant,
        
        [Parameter(Mandatory)]
        [string]
        $SiteName
    )
    
    begin {
        Write-Verbose ("[Export-SharePointSiteTemplate] Initializing...");
        # Constants
        $WebUrl = "https://{0}.sharepoint.com/sites/{1}" -f $Tenant, $SiteName;
        $ResultFolder = ".\Result"
        $TemplatePath = $("{0}\Template.xml" -f $ResultFolder);

        # Remove old templates in result folder
        if (Test-Path $ResultFolder) {
            Remove-Item $ResultFolder -Force  -Recurse -ErrorAction SilentlyContinue;
        }

        # Office 365 Login 
        Write-Verbose $("[Export-SharePointSiteTemplate] Connecting to {0}..." -f $WebUrl);
        Connect-PnPOnline -Url $WebUrl -Interactive;
    }
    
    process {
        # Save Template
        Write-Verbose $("[Export-SharePointSiteTemplate] Exporting PnP template to {0}..." -f $TemplatePath);
        Get-PnPSiteTemplate `
            -Out $TemplatePath `
            -IncludeAllTermGroups `
            -IncludeSiteCollectionTermGroup `
            -IncludeSiteGroups `
            -PersistBrandingFiles `
            -PersistPublishingFiles `
            -IncludeNativePublishingFiles `
            -IncludeAllPages `
            -Handlers All `
            -Schema LATEST `
            -Force;
    }
    
    end {
        Write-Verbose "   [Export-SharePointSiteTemplate] Done!"
    }
}

Export-ModuleMember -Function Export-SharePointSiteTemplate;