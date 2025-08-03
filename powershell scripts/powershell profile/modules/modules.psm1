<#
.SYNOPSIS
    PowerShell modules for PowerShell Profile
.DESCRIPTION
    This PowerShell module contains functions for PowerShell Profile
.EXAMPLE
    PS> .\profile-module.psm1
    PowerShell modules for PowerShell Profile
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# File/Directory Functions
function touch {
    param(
        [string]$Path
    )
    New-Item -Path $Path
}

function mv {
    param(
        [string]$Source,
        [string]$Destination
    )
    Move-Item -Path $Source -Destination $Destination
}

function cf {
    param(
        [string]$Source,
        [string]$Destination
    )
    Copy-Item -Path $Source -Destination $Destination
}

function rm {
    param(
        [string]$Path
    )
    Remove-Item -Path $Path
}

function Unzip {
    param(
        [string]$SourceFile,
        [string]$Destination
    )
    Expand-Archive -Path $SourceFile -DestinationPath $Destination
}

function Zip {
    param(
        [string]$Source,
        [string]$Destination
    )
    Compress-Archive -Path $Source -DestinationPath $Destination
}

function ls {
    param(
        [string]$Path,
        [string]$Pattern = "*.*"
    )
    Get-ChildItem -Path $Path -Filter $Pattern -File
}

function lsd {
    param(
        [string]$Path,
        [string]$Pattern = "*.*"
    )
    Get-ChildItem -Path $Path -Filter $Pattern -Directory
}

function vscode {
    param([string]$File)

    if (-not (Test-Path $File)) {
        Write-Error "File not found: $File"
        return
    }

    code $File
}

# Network Functions
function NetTest {
    try {
        $null = [System.Net.Dns]::GetHostEntry("www.google.com")
        return $true
    }
    catch {
        return $false
    }
}