<#
.SYNOPSIS
    Cleanup (MUST BE RUN AS ADMIN)
.DESCRIPTION
    This PowerShell script cleans up temporary files
.EXAMPLE
    PS> .\cleanup.ps1
    Cleanup temporary files
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>


# Define the directories to clean up
$dirsToClean = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\AppData\Local\Temp",
    "$env:SystemDrive\Windows\Temp",
    "$env:SystemDrive\Windows\SoftwareDistribution\Download"
)
try {
    # Loop through each directory and perform cleanup
    foreach ($dir in $dirsToClean) {

        if ($dir -ne "$env:USERPROFILE\Downloads") {
            # Remove empty directories
            Get-ChildItem -Path $dir -Directory | Remove-Item -Force -Recurse
        }
        # Remove files older than 7 days
        Get-ChildItem -Path $dir -Recurse -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Force
    }

    # Clear the recycle bin
    Clear-RecycleBin -Force

    # Display a success message
    "Cleanup process completed for $dir at $(Get-Date)"
    Start-Sleep 10
}
catch {
    "Error cleaning up $dir $($Error[0])"
}