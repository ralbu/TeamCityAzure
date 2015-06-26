function DeployPackage
{
    Param(
        [String]$packageLocation,
        [String]$contentPath,
        [String]$computerName,
        [String]$userName,
        [String]$password
    )

    $webDeployExePath = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\"

    $msdeploy = "$webDeployExePath\msdeploy.exe"
    if (!(Test-Path $msdeploy)) {
        throw "msdeploy.exe could not be found on this machine. MsDeploy location: $msdeploy"
    }

    "***** Start deploying the package from loction: $packageLocation *****"

    $arg1 = "-verb:sync" 
    $arg2 = "-source:contentPath=$packageLocation"
    $arg3 = "-dest:ContentPath='$contentPath',ComputerName='$computerName',UserName='$userName',Password='$password',AuthType='Basic'"

    & $msdeploy $arg1 $arg2 $arg3 $arg4
}