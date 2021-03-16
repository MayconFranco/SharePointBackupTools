function Test-SiteExists {
    param (
        [String]
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
        [String]
        $Guid
    )

    $code = '<iframe width="400" height="250" frameborder="0" scrolling="no" src="https://digitalfortytwo.sharepoint.com/sites/PnPResultado20210315/_layouts/15/Doc.aspx?sourcedoc={' + $Guid + '}&action=embedview&wdAllowInteractivity=False&wdHideGridlines=True&wdHideHeaders=True&wdDownloadButton=True&wdInConfigurator=True"></iframe>';
    return $code;
}

Export-ModuleMember -Function New-EmbedIFrame;
Export-ModuleMember -Function Test-SiteExists;