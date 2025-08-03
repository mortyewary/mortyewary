<#
.SYNOPSIS
    PowerShell Profile
.DESCRIPTION
    This PowerShell Script is used to configure the PowerShell profile
.EXAMPLE
    PS> .\Microsoft.PowerShell_profile.ps1
    PowerShell Profile
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# Define a function to reload the PowerShell profile
function Invoke-ProfileReload {
    $profilePath = $PROFILE
    if (Test-Path $profilePath) {
        . $profilePath
        Write-Host "PowerShell profile reloaded successfully."
    } else {
        Write-Warning "PowerShell profile not found."
    }
}

# Import custom modules
Import-Module "$env:USERPROFILE\Documents\mashumelo\powershell scripts\powershell profile\modules\modules.psm1" -Force

# oh-my-posh
$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
oh-my-posh init pwsh --config "${env:PROGRAMFILES(x86)}\oh-my-posh\themes\dracula.omp.json" | Invoke-Expression

# komorebi environmental variable
$Env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"