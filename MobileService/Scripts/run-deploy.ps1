param (
    [Parameter(Mandatory=$true)] [String]$packageLocation,
    [Parameter(Mandatory=$true)] [String]$contentPath,
    [Parameter(Mandatory=$true)] [String]$computerName,
    [Parameter(Mandatory=$true)] [String]$userName,
    [Parameter(Mandatory=$true)] [String]$password
)

. "$PSScriptRoot\deploy-package.ps1"
DeployPackage -PackageLocation $packageLocation -ContentPath $contentPath -ComputerName $computerName -UserName $userName -Password $password