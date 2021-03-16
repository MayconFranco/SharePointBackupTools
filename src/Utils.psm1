function Test-SiteExists {
    param (
        [string]
        $Url
    )
    try {
        Test-PnPSite -Identity $Url -ErrorAction Stop;
        return $true;
    }
    catch {
        return $false;
    }
}

function New-EmbedIFrame {
    param (
        [string]
        $Guid,

        [string]
        $Tenant,

        [string]
        $SiteName
    )

    $code = '<iframe width="400" height="250" frameborder="0" scrolling="no" src="https://' + $Tenant + '.sharepoint.com/sites/' + $SiteName + '/_layouts/15/Doc.aspx?sourcedoc={' + $Guid + '}&action=embedview&wdAllowInteractivity=False&wdHideGridlines=True&wdHideHeaders=True&wdDownloadButton=True&wdInConfigurator=True"></iframe>';
    return $code;
}

Export-ModuleMember -Function New-EmbedIFrame;
Export-ModuleMember -Function Test-SiteExists;