param (
    [Parameter(Mandatory = $false)]
    [string]$ModuleName,
    [Parameter(Mandatory = $false)]
    [ValidateSet('Development', 'Production')]
    $Configuration = 'Development'
)

# Default 
task . ReloadModule

task tests Analyze, Test
task pub InstallDependencies, Analyze, Test, Publish
task version InstallDependencies, Analyze, Test, UpdateVersion


if (-not ($PSBoundParameters.ModuleName))
{
    $ModuleName = Split-Path -Path $BuildRoot -Leaf
}

task ReloadModule {
    if (Get-Module $ModuleName)
    {
        Remove-Module -Name $ModuleName
    }
    Import-Module $BuildRoot
}


task InstallDependencies {
    Install-Module Pester -Force
    Install-Module PSScriptAnalyzer -Force
    Install-Module platyPS -Force
}

task Analyze {
    $scriptAnalyzerParams = @{
        Path        = "$BuildRoot\public"
        Severity    = @('Error', 'Warning')
        Recurse     = $true
        Verbose     = $false
        ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $ScriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams
    # $ScriptAnalyzerResults | ConvertTo-Html | Out-File -FilePath "$BuildRoot\result.$ModuleName.scriptAnalyzer.html" -Force

    if ($ScriptAnalyzerResults)
    {
        $ScriptAnalyzerResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Test {
    $InvokePesterParams = @{
        Strict       = $true
        PassThru     = $true
        Verbose      = $false
        EnableExit   = $false
        OutputFormat = 'NUnitXml'
        OutputFile   = "$BuildRoot\result.$ModuleName.tests.xml" 
    }

    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester ".\$((($BuildFile -split '\\')[-1] -split '\.')[0] + '.Tests.ps1')" @InvokePesterParams 

    $NumberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

task UpdateVersion {
    try
    {
        $manifestPath = ".\$ModuleName.psd1"

        # Import PlatyPS.
        Import-Module -Name PlatyPS

        # Start by importing the manifest to determine the version, then add 1 to the Build
        $manifest = Test-ModuleManifest -Path $manifestPath
        [System.Version]$Version = $manifest.Version
        [String]$NewVersion = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, ($version.Build + 1))
        Write-Output ('New Module version: {0}' -f $newVersion)

        #Update Module with new version
        Update-ModuleManifest -ModuleVersion $newVersion -Path $manifestPath -ReleaseNotes $ReleaseNotes
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
        $host.SetShouldExit($LastExitCode)
    }
}