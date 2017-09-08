param(
    [Parameter(Position=0)]
    [ValidateRange(0,[int]::MaxValue)]
    [int] $build_number = $(Throw "Please specify build number"),
    
   [Parameter(Position=1)]
    [ValidateSet('P','S','T')]
    [string] $from,
    
   [Parameter(Position=2)]
    [ValidateSet('P','S','T')]
    [string] $to,

    [string] $username,
    [string] $password,
    [string] $artifactoryApiPath,
    [string] $repository
)

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f $username,$password)))
$url = "$artifactoryApiPath/move/$repository/$from/package-$build_number.zip?to=/$repository/$to/package-$build_number.zip"

Invoke-RestMethod -Headers @{Authorization=('Basic {0}' -f $base64AuthInfo)} `
    -Method POST -UseBasicParsing `
    -Uri $url