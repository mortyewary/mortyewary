<#
.SYNOPSIS
    Run all install scripts in one place
.DESCRIPTION
    This PowerShell script runs all install scripts in one place
.PARAMETER MainFolderPath
    Specifies the main folder path
.EXAMPLE
    PS> .\run-install-scripts.ps1
    Run all install scripts
.LINK   
    https://github.com/mashumelo/mashumelo
.NOTES
    Author: Waylon Neal
#>

param(
    [string]$MainFolderPath
)

# Check if the MainFolderPath parameter is provided
if ($MainFolderPath) {
    # Use the provided MainFolderPath
    $mainFolderPath = $MainFolderPath
}
else {
    # Prompt the user to enter the main folder path
    $rawMainFolderPath = Read-Host "Enter the main folder path where all scripts are located"
    $mainFolderPath = "$($ExecutionContext.InvokeCommand.ExpandString($rawMainFolderPath))"
}

# Construct the full paths to the scripts based on the main folder path
$scoopScriptPath = Join-Path $mainFolderPath "scoop-installs.ps1"
$gitConfigScriptPath = Join-Path $mainFolderPath "git-configurations.ps1"
$gitCloneScriptPath = Join-Path $mainFolderPath "git-clone.ps1"

try {
    # Run scoop-install.ps1
    & $scoopScriptPath

    # Run git-configurations.ps1
    & $gitConfigScriptPath

    # Run git-clone.ps1
    & $gitCloneScriptPath

}
catch {
    Write-Error "Error in line $($_.InvocationInfo.ScriptLineNumber)): $($Error[0])"
    exit 1
}