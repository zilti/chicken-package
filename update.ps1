function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'http://code.call-cc.org/'
    $url = $download_page.links | ? href -Match '.tar\.gz$' | select -First 1 -Expand href
    $version = $url -Split '-|.tar.gz' | select -Last 1 -Skip 1
    return @{ Version = $version; URL = $url }
}

function global:au_SearchReplace {
    @{
        "build.ps1" = @{
            "(^[$]version\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
        }
    }
}

Update-Package