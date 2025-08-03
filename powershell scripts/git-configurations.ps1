<#
.SYNOPSIS
    Git Configurations
.DESCRIPTION
    This PowerShell script sets Git configurations
.PARAMETER userName
	Specifies the user's full name
.PARAMETER email
	Specifies the user's email address
.PARAMETER textEditor
	Specifies the user's favorite text editor
.EXAMPLE
    PS> .\git-configurations.ps1
    Set Variables
    Set Git Configurations
    Set Git username
    Set Git email
    Set Git editor
    List current configurations
    Notify you've set your username and email
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# region Parameters
param([string]$userName = "", [string]$email = "", [string]$textEditor = "")
#endregion Parameters

#region Functions
function Set-GitConfiguration {
    <#
        .SYNOPSIS
            Sets a Git configuration
        .PARAMETER name
            The name of the configuration
        .PARAMETER value
            The value of the configuration
        #>
    param([string]$name, [string]$value)
    
    git config --global $name $value
}
#endregion Functions

#region Main Script
try {
    # Set Variables
    if ([string]::IsNullOrWhiteSpace($userName)) {
        $userName = Read-Host "Enter your full name"
        if ([string]::IsNullOrWhiteSpace($userName)) {
            throw "User name cannot be empty"
        }
    }
        
    if ([string]::IsNullOrWhiteSpace($email)) {
        $email = Read-Host "Enter your email"
        if ([string]::IsNullOrWhiteSpace($email)) {
            throw "Email cannot be empty"
        }
    }
        
    if ([string]::IsNullOrWhiteSpace($textEditor)) {
        $textEditor = Read-Host "Enter your favorite code editor"
        if ([string]::IsNullOrWhiteSpace($textEditor)) {
            throw "Text editor cannot be empty"
        }
    }
        
    $stopWatch = [system.diagnostics.stopwatch]::startNew()

    # Set Git Configurations
    Set-GitConfiguration core.autocrlf false          # configure Git to ensure line endings in files you checkout are correct for Windows
    Set-GitConfiguration core.symlinks true           # enable support for symbolic link files
    Set-GitConfiguration core.longpaths true          # enable support for long file paths
    Set-GitConfiguration init.defaultBranch main      # set the default branch name to 'main'
    Set-GitConfiguration merge.renamelimit 99999      # raise the rename limit
    Set-GitConfiguration pull.rebase false
    Set-GitConfiguration fetch.parallel 0             # enable parallel fetching to improve the speed

    # Set Git username
    git config --global user.name $userName

    # Set Git email
    git config --global user.email $email

    # Set Git editor
    git config --global core.editor $textEditor

    # List current configurations
    & git config --list
    if ($lastExitCode -ne "0") { throw "'git config --list' command failed with exit code $lastExitCode" }

    [int]$elapsed = $stopWatch.Elapsed.TotalSeconds
    "Saved your Git configuration in $elapsed sec"
    exit 0 # success
}
catch {
    Write-Error "Error in line $($_.InvocationInfo.ScriptLineNumber)): $($Error[0])"
    exit 1
}
#endregion Main Script