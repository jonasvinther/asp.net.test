PUT /storage/libs-release-local/ch/qos/logback/logback-classic/0.9.9?properties=os=win,linux;qa=done&recursive=1

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

    [Parameter(Position=3)]
    [string] $username,

    [Parameter(Position=4)]
    [string] $password,

    [Parameter(Position=5)]
    [string] $artifactoryApiPath,
    
    [Parameter(Position=6)]
    [string] $repository
)

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f $username,$password)))

$url = "$artifactoryApiPath/storage/$repository/$from/package-243.zip?properties=os=linux;"

Invoke-RestMethod -Headers @{Authorization=('Basic {0}' -f $base64AuthInfo)} `
    -Method PUT -UseBasicParsing `
    -Uri $url