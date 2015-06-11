Param 
(
    [Parameter(Mandatory=$true)] [String]$version,
    [Parameter(Mandatory=$false)] [String]$contentPath,
    [Parameter(Mandatory=$false)] [String]$computerName,
    [Parameter(Mandatory=$false)] [String]$userName,
    [Parameter(Mandatory=$false)] [String]$password,
    [Parameter(Mandatory=$false)] [Hashtable]$debugConfiguration
)

Import-Module ..\Tools\psake.psm1

Invoke-psake -buildFile .\build.ps1 `
 -parameters @{version=$version;contentPath=$contentPath;computerName=$computerName;userName=$userName;password=$password} `
 -properties @{"debugConfiguration"=$debugConfiguration}