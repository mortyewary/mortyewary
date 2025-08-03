<#
.SYNOPSIS
    File Output
.DESCRIPTION
    This PowerShell script outputs files and directories in a table format
    and then allows the user to move files within the selected directory to another directory
.PARAMETER allowEmpty
    Specifies whether to allow empty directory paths
.EXAMPLE
    PS> .\file-output.ps1
    File Output
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# Function to get valid directory path
function Get-ValidDirectoryPath {
    # Allow empty directory path
    param (
        [bool]$allowEmpty = $false
    )
    do {
        $rawDirectory = Read-Host "Enter the directory path"
        $directory = "$($ExecutionContext.InvokeCommand.ExpandString($rawDirectory))"

        # Validate the directory path
        if ([string]::IsNullOrWhiteSpace($directory)) {
            Write-Error "Directory path cannot be empty."
        }
        elseif (-not (Test-Path -Path $directory -PathType Container)) {
            Write-Error "Directory does not exist or is not a valid directory."
        }
        elseif (-not $allowEmpty -and (Get-ChildItem -Path $directory -Recurse).Count -eq 0) {
            Write-Error "Directory is empty."
        }
        else {
            return $directory
        }
    } while ($true)
}

# Function to select files for moving
function Select-FilesForMove {
    $selectedFiles = @()
    $files = Get-ChildItem -Path $directory -Recurse

    Write-Host "Select the files you want to move or copy:"
    foreach ($file in $files) {
        Write-Host "$($file.Name) [Y/N]"
        $choice = Read-Host
        if ($choice -eq "Y") {
            $selectedFiles += $file
        }
        elseif ($choice -ne "Y") {
            Write-Host "Skipping $($file.Name). Not selected for moving or copying."
        }
    }

    return $selectedFiles
}

# Script to output files and directories in a table format, and then allow the user to move files within the selected directory to another directory
do {
    $directory = Get-ValidDirectoryPath

    $fileInfo = Get-ChildItem -Path $directory -Recurse | Select-Object Name, Length, Extension, @{Name = "FileType"; Expression = { $_.GetType() } }, Attributes, CreationTime, LastWriteTime

    $fileInfo | Format-Table -AutoSize

    do {
        $moveFiles = Read-Host "Do you want to move or copy files? (Y/N)"
    } while ($moveFiles -ne "Y" -and $moveFiles -ne "N")

    if ($moveFiles -eq "Y") {

        do {
            $moveOrCopy = Read-Host "Do you want to move or copy files? (M/C)"
        } while ($moveOrCopy -ne "M" -and $moveOrCopy -ne "C")

        if ($moveOrCopy -eq "M") {
            $selectedFiles = Select-FilesForMove
            if ($selectedFiles.Count -ne 0) {
                $destinationDirectory = Get-ValidDirectoryPath -allowEmpty $true

                foreach ($file in $selectedFiles) {
                    if (Test-Path -Path $file.FullName) {
                        try {
                            Move-Item -Path $file.FullName -Destination $destinationDirectory -ErrorAction Stop
                            Write-Output "File $($file.Name) moved successfully to $destinationDirectory."
                        }
                        catch {
                            Write-Error "Failed to move file $($file.Name): $_"
                        }
                    }
                    else {
                        Write-Error "File $($file.Name) not found."
                    }
                }
            }
            else {
                Write-Output "No files selected for moving or copying."
            }
        }
        elseif ($moveOrCopy -eq "C") {
            $selectedFiles = Select-FilesForMove
            if ($selectedFiles.Count -ne 0) {
                $destinationDirectory = Get-ValidDirectoryPath -allowEmpty $true

                foreach ($file in $selectedFiles) {
                    if (Test-Path -Path $file.FullName) {
                        try {
                            Copy-Item -Path $file.FullName -Destination $destinationDirectory -ErrorAction Stop
                            Write-Output "File $($file.Name) copied successfully to $destinationDirectory."
                        }
                        catch {
                            Write-Error "Failed to copy file $($file.Name): $_"
                        }
                    }
                    else {
                        Write-Error "File $($file.Name) not found."
                    }
                }
            }
        }
    }
    do {
        $continue = Read-Host "Do you want to continue? (Y/N)"
    } while ($continue -ne "Y" -and $continue -ne "N")
} while ($continue -eq "Y")
