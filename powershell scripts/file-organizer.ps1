<#
.SYNOPSIS
    File Organizer
.DESCRIPTION
    Organizes your Files
.PARAMETER SourceDirectory
    Specifies the source directory
.PARAMETER Extensions
    Specifies the extensions to organize
.EXAMPLE
    PS> .\file-organizer.ps1
    Organizes your Files
.LINK
    https://github.com/mashumelo/mashumelo
.NOTES
    Author: Waylon Neal
#>

# Function to organize files based on extensions
function Move-FilesByExtension {
    param (
        [string]$SourceDirectory,
        [hashtable]$Extensions
    )

    foreach ($ext in $Extensions.Keys) {
        # Create the destination directory path
        $destDir = Join-Path -Path $SourceDirectory -ChildPath $Extensions[$ext]
        if (-not (Test-Path -Path $destDir)) {
            # Create the destination directory if it doesn't exist
            New-Item -ItemType Directory -Path $destDir 
        }
        # Move the files to the destination directory
        Get-ChildItem -Path $SourceDirectory -Filter $ext -Recurse | Where-Object { $_.Directory.FullName -ne $destDir } | Move-Item -Destination $destDir -ErrorAction SilentlyContinue
    }
}

# Define the source directory
$rawSourceDir = Read-Host "Enter the source directory"
$sourceDir = "$($ExecutionContext.InvokeCommand.ExpandString($rawSourceDir))"

# Define the extensions to organize
$extensions = @{
    "*.exe"  = "Executables";
    "*.bat"   = "Executables";
    "*.WAD"   = "WADs";
    "*.dll"   = "DLLs";
    "*.ps1"   = "Scripts";
    "*.iso"  = "ISOs";
    "*.zip"  = "ZIPs";
    "*.rar"  = "RARs";
    "*.7z"   = "7Zs";
    "*.jar"  = "JARs";
    "*.pdf"  = "PDFs";
    "*.doc"  = "Docs";
    "*.docx" = "Docs";
    "*.txt"  = "Docs";
    "*.jpg"  = "Images";
    "*.png"  = "Images";
    "*.gif"  = "Images";
    "*.bmp"  = "Images";
    "*.mp3"  = "Music";
    "*.mp4"  = "Videos";
    "*.avi"  = "Videos";
    "*.mkv"  = "Videos";
    # Add more extensions as needed
}

# Call the function to organize files
Move-FilesByExtension -SourceDirectory $sourceDir -Extensions $extensions

Write-Host "Files organized successfully!"