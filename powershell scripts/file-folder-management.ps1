<#
.SYNOPSIS
    File/Folder Management
.DESCRIPTION
    This PowerShell script manages files and folders
.PARAMETER allowEmpty
    Specifies whether to allow empty directory paths
.EXAMPLE
    PS> .\file-folder-management.ps1
    File/Folder Management
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# Prompt the user for the source and destination paths
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

do {

    $directory = Get-ValidDirectoryPath

    # Prompt the user for the desired operation
    $operation = Read-Host "Enter the operation number (1-5): 1: Copy, 2: Move, 3: Rename, 4: Delete, 5: Zip, 6: Unzip, 7: Exit"

    $destinationDirectory = Get-ValidDirectoryPath -allowEmpty $true

    # Validate the operation number
    if ($operation -notmatch '^[1-7]$') {
        throw "Invalid operation number. Please enter a number between 1 and 7."
    }

    try {
        # Perform the selected operation
        switch ($operation) {
            1 {
                Copy-Item -Path $directory -Destination $destinationDirectory -Recurse
                "Files copied successfully."
            }
            2 {
                Move-Item -Path $directory -Destination $destinationDirectory -Recurse
                "Files moved successfully."
            }
            3 {
                $newName = Read-Host "Enter the new name"
                Rename-Item -Path $directory -NewName $newName
                "File or folder renamed successfully."
            }
            4 {
                Remove-Item -Path $directory -Recurse -Confirm:$false
                "Files or folder deleted successfully."
            }
            5 {
                # Prompt the user for the zip file name
                $rawZipFileName = Read-Host "Enter the ZIP file name"
                $zipFileName = "$($ExecutionContext.InvokeCommand.ExpandString($rawZipFileName))"
                $zipFilePath = "$destinationDirectory\$zipFileName.zip"
                Compress-Archive -Path $directory -DestinationPath $zipFilePath
                "Files compressed into archive successfully."
            }
            6 {
                # Prompt the user for the zip file path
                $rawZipFilePath = Read-Host "Enter the path to the ZIP archive"
                $zipFilePath = "$($ExecutionContext.InvokeCommand.ExpandString($rawZipFilePath))"
                Expand-Archive -Path $zipFilePath -DestinationPath $destinationDirectory
                "Files extracted from archive successfully."
            }
            7 {
                "Exiting..."
                return
            }
            default {
                "Invalid operation number. Exiting..."
                return
            }
        }
    }
    catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    }

    do {
        # Prompt the user for additional operations
        $continue = Read-Host "Do you want to perform another operation? (Y/N)"
    } while ($continue -ne "Y" -and $continue -ne "N")
} while ($continue -eq "Y")