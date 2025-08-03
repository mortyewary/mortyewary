<#
.SYNOPSIS
    User Backup (MUST BE RUN AS ADMIN)
.DESCRIPTION
    This PowerShell script creates a backup of a user's files
.PARAMETER userName
    Specifies the user's name
.EXAMPLE
    PS> .\user-backup.ps1
    Backup user's files
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

param([string]$userName = "")

try {
    # Get username
    if ([string]::IsNullOrWhiteSpace($userName)) {
        $userName = Read-Host "Enter your username"
        if ([string]::IsNullOrWhiteSpace($userName)) {
            throw "Username cannot be empty"
        }
    }

    # Create backup directory
    $BackupPath = "C:\Backup\$userName"
    New-Item -ItemType Directory -Path $BackupPath -Force
    if ($lastExitCode -ne "0") { throw "'New-Item' command failed with exit code $lastExitCode" }

    # Copy user's files
    Copy-Item -Path "C:\Users\$userName\*" -Destination $BackupPath -Recurse
    if ($lastExitCode -ne "0") { throw "'Copy-Item' command failed with exit code $lastExitCode" }

    # Copy user's registry hive
    $RegPath = "C:\Users\$userName\NTUSER.DAT"
    $RegBackupPath = "$BackupPath\NTUSER.DAT"
    Copy-Item -Path $RegPath -Destination $RegBackupPath
    if ($lastExitCode -ne "0") { throw "'Copy-Item' command failed with exit code $lastExitCode" }

    # Unload user's registry hive
    reg load "HKDU" $RegPath
    reg unload "HKDU"
    if ($lastExitCode -ne "0") { throw "'reg load' command failed with exit code $lastExitCode" }

    # Compress backup directory
    $ZipPath = "$BackupPath.zip"
    Compress-Archive -Path $BackupPath -DestinationPath $ZipPath
    if ($lastExitCode -ne "0") { throw "'Compress-Archive' command failed with exit code $lastExitCode" }

    # Remove the original backup directory
    Remove-Item -Path $BackupPath -Recurse -Force

}
catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
}