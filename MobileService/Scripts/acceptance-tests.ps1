$specFlowFolder = "..\Source\packages\SpecFlow.1.9.0\tools\"
$nunitRunner = "..\Source\packages\NUnit.Runners.2.6.4\tools\nunit-console.exe"

if (!(Test-Path $nunitRunner)){
    throw "nunit-console.exe does not exist. Please check $nunitRunner file."
}

$acceptanceTests = "..\Source\Specifications\bin\Release\Specifications.dll"

& $nunitRunner /nologo /labels /out=TestResult.txt /xml=TestResult.xml /framework:net-4.0 $acceptanceTests


# In order to run specflow on .net 4.0 (it was compiled for 3.5) need to copy the file specflow.exe.config to the same location as specflow.exe (https://github.com/techtalk/SpecFlow/wiki/Reporting)
Copy-Item -path "specflow.exe.config" -destination $specFlowFolder

$specFlow = "..\Source\packages\SpecFlow.1.9.0\tools\specflow.exe"

if (!(Test-Path $specflow)){
    throw "specflow.exe does not exist. Please check the $specflow file."
}

& $specFlow nunitexecutionreport "..\Source\Specifications\Specifications.csproj" /out:"..\TestResult.html"