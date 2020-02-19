function Get-BP.PlasterTemplate
{
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Path', Position = 0, HelpMessage = 'Specifies a path to a folder containing a Plaster template or multiple template folders.  Can also be a path to plasterManifest.xml.')]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Path},

        [Parameter(ParameterSetName = 'Path', HelpMessage = 'Indicates that this cmdlet gets the items in the specified locations and in all child items of the locations.')]
        [switch]
        ${Recurse},

        [Parameter(ParameterSetName = 'IncludedTemplates', Mandatory = $true, Position = 0, HelpMessage = 'Initiates a search for Plaster templates inside of installed modules.')]
        [Alias('IncludeModules')]
        [switch]
        ${IncludeInstalledModules})

    begin
    {
        try
        {
            $outBuffer = $null

            # if ($Path)
            # {
            #     $Path = $script:DataPath
            # }
            
            $PSBoundParameters['Path']
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }

            if (-not $PSBoundParameters['Path'])
            {
                $PSBoundParameters.Add('Path', $($script:DataPath))
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Get-PlasterTemplate', [System.Management.Automation.CommandTypes]::Function)
            $scriptCmd = { & $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }
    }

    process
    {
        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }
    <#

.ForwardHelpTargetName Get-PlasterTemplate
.ForwardHelpCategory Function

#>

}