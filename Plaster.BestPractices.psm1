# script:variable
$script:PSModuleRoot = $PSScriptRoot
$script:LibraryPath = Join-Path -Path $script:PSModuleRoot -ChildPath 'lib'
$script:BinaryPath = Join-Path -Path $script:PSModuleRoot -ChildPath 'bin'
$script:DataPath = Join-Path -Path $script:PSModuleRoot -ChildPath 'data'
$script:ClassPath = Join-Path -Path $script:PSModuleRoot -ChildPath 'class'

# load function
Get-ChildItem "$PSScriptRoot\public\*.ps1" | ForEach-Object { 
    . $_.FullName 
}

Get-ChildItem "$PSScriptRoot\private\*.ps1" | ForEach-Object { 
    . $_.FullName 
}

