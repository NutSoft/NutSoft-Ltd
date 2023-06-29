function Get-MLURLCollection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    $sourceUrl = [System.Web.HttpUtility]::UrlDecode($URL)
    $components = [System.Uri]$sourceUrl
    @{
        DisplayUrl = $sourceUrl.Trim().TrimEnd("/")
        Path       = $(
            if ($components.Segments[1] -eq "sites/") {
                "/" + ($sourceUrl -split $components.Segments[2])[0].Replace("/","%2F") + ($sourceUrl -split $components.Segments[1])[1]
            } elseif ($components.Segments.Count -eq 2) {
                "/" + $sourceUrl.Replace("//","%2F%2F")
            } else {
                "/" + $sourceUrl.Replace("/","%2F")
            }
        ).Replace("/Lists/","/")
        Connection = $components.Scheme, $components.Host -join "://"
    }
}