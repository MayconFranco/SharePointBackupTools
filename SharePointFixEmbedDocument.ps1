Function Get-EmbedIFrame {
    param (
        [String]
        $Guid
    )

    $code = '<iframe width="400" height="250" frameborder="0" scrolling="no" src="https://digitalfortytwo.sharepoint.com/sites/PnPResultado20210315/_layouts/15/Doc.aspx?sourcedoc={' + $Guid + '}&action=embedview&wdAllowInteractivity=False&wdHideGridlines=True&wdHideHeaders=True&wdDownloadButton=True&wdInConfigurator=True"></iframe>';
    return $code;
}

# User defined variables
$tenant = "digitalfortytwo";
$sourceSite = "/sites/PnPResultado20210315";
$pageName = "Pagina-de-Teste-3.aspx";

# Constants
$webUrl = "https://{0}.sharepoint.com{1}" -f $tenant, $sourceSite;

# Office 365 Login 
Write-Output $("Connecting to {0}..." -f $webUrl);
Connect-PnPOnline -Url $webUrl -Interactive;

$list = Get-PnPListItem -List "SitePages";
foreach ($item in $list) {
    $name = Write-Output $item.FieldValues["FileLeafRef"];
    $page = Get-PnPClientSidePage -Identity $name;
    $controls = $page.Controls.Where({$_.Type.Name -eq "PageWebPart" -and $_.Title -eq "File viewer"});

    foreach($control in $controls) {
        $url = $control.Properties.GetProperty("file").GetString();
        $decodedUrl = [System.Web.HttpUtility]::UrlDecode($url);
        $path = $([System.Uri]$decodedUrl).LocalPath
        $file = Get-PnPFile -Url $path -AsListItem;
        $guid = $file.FieldValues["UniqueId"].Guid.ToString();
        $code = $(Get-EmbedIFrame -Guid $guid);

        $column = $control.Column.Order;
        $section = $control.Section.Order;

        $control.Delete();
        
        Add-PnPPageWebPart -Column $column -Section $section -Page $page -DefaultWebPartType ContentEmbed -WebPartProperties @{
            "embedCode" = $code;
        };
        $page.Save();
    }
}
Write-Output "Done!";
