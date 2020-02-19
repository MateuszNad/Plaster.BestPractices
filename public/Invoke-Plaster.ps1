function Invoke-BP.Plaster
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${DestinationPath},

        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${TemplatePath},

        [switch]
        ${Force},

        [switch]
        ${NoLogo},

        [switch]
        ${PassThru})

    begin
    {
        try
        {
            $ASCIIText = @"
  ____            _     ____                 _   _                   
 | __ )  ___  ___| |_  |  _ \ _ __ __ _  ___| |_(_) ___ ___  ___     
 |  _ \ / _ \/ __| __| | |_) | '__/ _` |/ __| __| |/ __/ _ \/ __|    
 | |_) |  __/\__ \ |_  |  __/| | | (_| | (__| |_| | (_|  __/\__ \  _ 
 |____/ \___||___/\__| |_|   |_|  \__,_|\___|\__|_|\___\___||___/ (_)
"@

            Write-Host $ASCIIText

            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }

            if (-not $PSBoundParameters['TemplatePath'])
            {
                $PSBoundParameters.Add('TemplatePath', $($script:DataPath))
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Invoke-Plaster', [System.Management.Automation.CommandTypes]::Function)
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

.ForwardHelpTargetName Invoke-Plaster
.ForwardHelpCategory Function

#>

}