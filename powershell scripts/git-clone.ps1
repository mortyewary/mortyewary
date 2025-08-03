<#
.SYNOPSIS
        Clone git repository
.DESCRIPTION
        This PowerShell script clones your git repository
.PARAMETER gitRepo
        Specifies the link to your git repository
.EXAMPLE
    PS> .\git-clone.ps1
    Git repository successfully cloned!
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

param([string]$gitRepo = "")

try {
        # Change directory to your Documents folder
        Set-Location $env:USERPROFILE/Documents

        # Set Variable
        if ([string]::IsNullOrWhiteSpace($gitRepo)) {
                $gitRepo = Read-Host "Enter your git repository link"
                if ([string]::IsNullOrWhiteSpace($gitRepo)) {
                        throw "Git repository link cannot be empty"
                }
        }

        # Clone your git repository 
        & git clone $gitRepo

        "Git repository successfully cloned!" # Notify you've successfully cloned your git repository
        exit 0
}
catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber)): $($Error[0])"
}