Properties {
    $workingDirectory = $null
    $verbosity = "n"
    $config = "Release"
    $version
    $contentPath
    $computerName
    $userName
    $password
    $debugConfiguration = $null
}

if (!$workingDirectory){
    $workingDirectory = Resolve-Path ..\
    "[Debug] Working directory is null. Set root directory as working directory: $workingDirectory"
}

$sourceDirectory = Join-Path $workingDirectory "Source"
$solutionToBuild = Join-Path $workingDirectory "Source\UserManagement.sln"
$projectToBuild = Join-Path $workingDirectory "Source\UserManagement\UserManagement.csproj"
$artifactDirectory = Join-Path $workingDirectory "Artifacts"
$xunitConsole = Join-Path $workingDirectory "Source\packages\xunit.runner.console.2.0.0\tools\xunit.console.exe"
$nugetExe = Join-Path $workingDirectory "Tools\nuget.exe"

FormatTaskName "$([Environment]::NewLine)==================== $(Get-Date -format T) - Executing {0} ===================="

Task Default -Depends DeployPackage

Task DeployPackage -Depends Test {
    if ($debugConfiguration.deployPackage -eq $false) {
        return
    }

  . "$PSScriptRoot\deploy-package.ps1"
  DeployPackage -PackageLocation $artifactDirectory -ContentPath $contentPath -ComputerName $computerName -UserName $userName -Password $password
}

Task Test -Depends Build {
  if ($debugConfiguration.test -eq $false) {
    return
  }

  if (!(Test-Path $xunitConsole))
  {
    throw "xunit.console.exe does not exist. Please check $xunitConsole file."
  }

   "************* Build solution [$solutionToBuild] for Unit Testing *************"
  # Need to run the solution to build all the tests. The Build Task run only the csproj file
  exec {
    msbuild $solutionToBuild /verbosity:m /p:Configuration=$config /p:VisualStudioVersion=12.0 /nologo
  }

  $assembliesToTest = (Get-ChildItem "$sourceDirectory" -Recurse -Include "*Test*.dll" -Name | Select-String "bin")

  $atLeastOneTestRun = $false

  "************* Running Unit Tests *************"
  foreach ($testFile in $assembliesToTest){
    "*************** Testing $testFile ***************"
    $fullNameTestFile = Join-Path $sourceDirectory $testFile
    
    & $xunitConsole $fullNameTestFile
    $atLeastOneTestRun = $true
  }

  if ($atLeastOneTestRun -eq $false){
    Write-Output "Unit Tests didn't run!"
    exit(1)
  }
}

Task Build -Depends RestoreNuGetPackages, UpdateVersion {
  if ($debugConfiguration.build -eq $false) {
    return
  }

    $publishProfile = GetPublishProfile 

    Exec {
        msbuild $projectToBuild /p:DeployOnBuild=true /p:PublishProfile=$publishProfile /verbosity:$verbosity /nologo /p:Configuration=$config /p:VisualStudioVersion=12.0
    }
}

Task RestoreNuGetPackages -Depends Clean -Precondition { return $debugConfiguration -eq $null -or $debugConfiguration.restorePackage } {
    if (!(Test-Path $nugetExe)){
        throw "nuget.exe could not be found on this machine. Please check: $nugetExe"
    }
    Exec {
      & $nugetExe restore $solutionToBuild
    }
}

Task UpdateVersion -Precondition { return $debugConfiguration -eq $null -or $debugConfiguration.updateVersion } {
    (Get-ChildItem -Path $sourceDirectory -Filter AssemblyInfo.cs -Recurse) |
    ForEach-Object {
      (Get-Content $_.FullName) |
        ForEach-Object {
          $_ -replace 'AssemblyVersion.+$',"AssemblyVersion(`"$version`")]" `
          -replace 'AssemblyFileVersion.+$',"AssemblyFileVersion(`"$version`")]"
        } |
        Out-File $_.FullName
    }
}

Task Clean -Precondition { return $debugConfiguration -eq $null -or $debugConfiguration.clean } {
 Exec {
        msbuild $solutionToBuild /t:Clean /verbosity:$verbosity /nologo /p:Configuration=$config /p:VisualStudioVersion=12.0
    }

   "******************** Remove Packages folder ********************"
  if (Test-Path "..\Source\packages") {
     Remove-Item "..\Source\packages" -Recurse -Force -ErrorAction Stop
  }
  else {
    "Didn't find the 'packages' folder."
  }
}

function GetPublishProfile() {
    # Get the publish xml template and generate the .pubxml file
    $scriptPath = Split-Path -parent $PSCommandPath

    if (Test-Path $artifactDirectory) {
        Remove-Item $artifactDirectory -Recurse -Force -ErrorAction Stop
    }

    [String]$template = Get-Content $scriptPath\pubxml.template

    mkdir $artifactDirectory | Out-Null
    $xml = $template -f $artifactDirectory
    $outputPublishProfile = Join-Path $artifactDirectory "PublishProfile.pubxml"
    $xml | Out-File -Encoding utf8 -FilePath $outputPublishProfile

    return $outputPublishProfile
}