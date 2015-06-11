Param (
    [Parameter(Mandatory=$false)] [String]$contentPath,
    [Parameter(Mandatory=$false)] [String]$computerName,
    [Parameter(Mandatory=$false)] [String]$userName,
    [Parameter(Mandatory=$false)] [String]$password
)

$version =  "" + (Get-Date).Month + "." + (Get-Date).Day + "." + (Get-Date).Hour  + "." + (Get-Date).Minute+ (Get-Date).Millisecond
$debugConfiguration = @{clean=$false;restorePackage=$false;updateVersion=$false;build=$true;test=$false;deployPackage=$false}

remove : and test
cls | .\run-build.ps1 -version:$version -contentPath:$contentPath -computerName:$computerName -userName:$userName -password:$password -debugConfiguration:$debugConfiguration