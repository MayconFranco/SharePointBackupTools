Import-Module "$PSScriptRoot\Utils.psm1";
function Repair-EmbedDocumentWebParts {
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
        # Constants
        $WebUrl = "https://{0}.sharepoint.com/sites/{1}" -f $Tenant, $SiteName;

        # Office 365 Login 
        Write-Verbose $("[Repair-EmbedDocumentWebParts] Connecting to {0}..." -f $WebUrl);
        Connect-PnPOnline -Url $WebUrl -Interactive;
    }

    process {
        Write-Verbose $("[Repair-EmbedDocumentWebParts] Repairing WebParts..." -f $WebUrl);
        $List = Get-PnPListItem -List "SitePages";
        foreach ($Item in $List) {
            $Name = $Item.FieldValues["FileLeafRef"];
            $Page = Get-PnPClientSidePage -Identity $Name;
            $Controls = $Page.Controls.Where( { $_.Type.Name -eq "PageWebPart" -and $_.Title -eq "File viewer" });

            foreach ($Control in $Controls) {
                $Url = $Control.Properties.GetProperty("file").GetString();
                $DecodedUrl = [System.Web.HttpUtility]::UrlDecode($Url);
                $Path = $([System.Uri]$DecodedUrl).LocalPath
                $File = Get-PnPFile -Url $Path -AsListItem;
                $Guid = $File.FieldValues["UniqueId"].Guid.ToString();
                $Code = $(New-EmbedIFrame -Guid $Guid);

                $Column = $Control.Column.Order;
                $Section = $Control.Section.Order;

                $Control.Delete();
                
                Add-PnPPageWebPart -Column $Column -Section $Section -Page $Page -DefaultWebPartType ContentEmbed -WebPartProperties @{
                    "embedCode" = $Code;
                };
                $Page.Save();
            }
        }
    }

    end {
        Write-Verbose "[Repair-EmbedDocumentWebParts] Done!";
    }    
}
