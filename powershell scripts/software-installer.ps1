<#
.SYNOPSIS
    Software Installer (MUST BE RUN AS ADMIN)
.DESCRIPTION
    This PowerShell script installs software
.PARAMETER DownloadDirectory
    Specifies the download directory
.PARAMETER InstallationArguments
    Specifies the installation arguments
.EXAMPLE
    PS> .\software-installer.ps1
    Install software
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# Parameters for directory location and installation arguments
param (
    [Parameter(Mandatory = $false)]
    [string]$DownloadDirectory = "$env:USERPROFILE\Downloads",
    
    [Parameter(Mandatory = $false)]
    [string[]]$InstallationArguments = @("/silent", "/norestart")
)

# Define the list of software installers
$softwareList = @(
    @{   Name     = "Software 1"
        Url       = "https://example.com/software1.exe"
        Arguments = @("/silent", "/norestart")
    },
    @{   Name     = "Software 2"
        Url       = "https://example.com/software2.exe"
        Arguments = @("/silent", "/norestart")
    },
    @{   Name     = "Software 3"
        Url       = "https://example.com/software3.exe"
        Arguments = @("/silent", "/norestart")
    }
)

# Iterate through each software and download the installer
foreach ($software in $softwareList) {
    # Define the name of the installer
    $fileName = [regex]::Match($software.Url, '([^\/]+$)').Value
    if (-not $fileName) {
        $fileName = "installer.exe"
    }
    #Define the full path to the installer
    $installerPath = Join-Path -Path $DownloadDirectory -ChildPath $fileName
    
    # Download the installer
    $downloadError = $null
    try {
        Invoke-WebRequest -Uri $software.Url -OutFile $installerPath -ErrorAction Stop
    }
    catch {   
        $downloadError = $_
        "Failed to download $($software.Name): $($downloadError.Exception.Message)"
        continue
    }
    # Install the software
    if (Test-Path $installerPath) {
        $installationError = $null
        try {
            Start-Process -FilePath $installerPath -ArgumentList $InstallationArguments -Wait -ErrorAction Stop
        }
        catch {
            $installationError = $_
            "Failed to install $($software.Name): $($installationError.Exception.Message)"
            continue
        }
    }
    else {
        "$($software.Name) installer file not found."
    }
}