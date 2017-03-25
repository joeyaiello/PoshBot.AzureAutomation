
function Get-Giphy {
    <#
    .SYNOPSIS
        Search Giphy
    .EXAMPLE
        !giphy (--search 'cats' [--number 3] | --trending [--number 3])
    #>
    [PoshBot.BotCommand(CommandName = 'giphy')]
    [cmdletbinding(DefaultParameterSetName = 'search')]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'search')]
        [string]$Search,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'trending')]
        [switch]$Trending,

        [parameter(Position = 1)]
        [ValidateRange(1, 10)]
        [Alias('Count')]
        [int]$Number = 1
    )

    $apiKey = 'dc6zaTOxFJmzC'

    $params = @{
        Uri = "http://api.giphy.com/v1/gifs/search?q=$Search&limit=25&api_key=$apiKey"
        UseBasicParsing = $true
    }
    if ($PSCmdlet.ParameterSetName -eq 'trending') {
        $params.Uri = "http://api.giphy.com/v1/gifs/trending?limit=25&api_key=$apiKey"
    }
    $d = Invoke-RestMethod @params
    if ($d.data) {
        $url = ($d.data | Get-Random -Count $Number).images.downsized.url
        Write-Output $url
    } else {
        Write-Output 'No results found'
    }
}

Export-ModuleMember -Function Get-Giphy
