<#
.SYNOPSIS
    Scoop Import/Export Script
.DESCRIPTION
    This script backs up and restores Scoop apps and buckets intelligently.
.PARAMETER allowEmpty
    Allows backup and restore even if no apps or buckets are found.
.EXAMPLE
    PS> .\scoop-import-export.ps1 -allowEmpty
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

param (
    [switch]$allowEmpty
)

# Define backup directory
$backupDir = "$env:USERPROFILE\scoop-backup"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# Function to check if Scoop is installed
function Test-Scoop {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "🛠 Scoop not found. Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    } else {
        Write-Host "✅ Scoop is already installed."
    }
}

# Function to backup Scoop setup
function Backup-Scoop {
    Write-Host "`n📦 Backing up Scoop apps and buckets..."

    $export = scoop export | ConvertFrom-Json

    if (-not $allowEmpty -and ($export.apps.Count -eq 0 -and $export.buckets.Count -eq 0)) {
        Write-Warning "⚠️ No apps or buckets found. Use -allowEmpty to override."
        return
    }

    $export.apps | ForEach-Object { $_.Name } | Set-Content "$backupDir\apps.txt"
    Write-Host "📄 Apps backed up to $backupDir\apps.txt"

    $export.buckets | ForEach-Object {
        "$($_.name) $($_.source)"
    } | Set-Content "$backupDir\buckets.txt"
    Write-Host "📄 Buckets backed up to $backupDir\buckets.txt"

    Write-Host "✅ Backup saved to $backupDir"
}

# Function to restore Scoop setup
function Restore-Scoop {
    Write-Host "`n🔄 Restoring Scoop setup..."

    # Restore buckets
    $bucketFile = "$backupDir\buckets.txt"
    if (Test-Path $bucketFile) {
        Get-Content $bucketFile | ForEach-Object {
            $parts = $_ -split '\s+', 2
            $name = $parts[0]
            $source = $parts[1]
            if (-not (scoop bucket list | Select-String "^$name$")) {
                Write-Host "➕ Adding bucket: $name from $source"
                scoop bucket add $name $source
            } else {
                Write-Host "✔️ Bucket already added: $name"
            }
        }
    }

    # Restore apps
    $appsFile = "$backupDir\apps.txt"
    if (Test-Path $appsFile) {
        Get-Content $appsFile | ForEach-Object {
            if (-not (scoop list | Select-String "^$_\s")) {
                Write-Host "📥 Installing app: $_"
                scoop install $_
            } else {
                Write-Host "✔️ App already installed: $_"
            }
        }
    }

    Write-Host "`n✅ Restore complete!"
}

# Run everything
Test-Scoop
Backup-Scoop
Restore-Scoop
