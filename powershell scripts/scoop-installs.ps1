<#
.SYNOPSIS
    Scoop installs
.DESCRIPTION
    This PowerShell script installs Scoop, adds useful buckets, and installs a curated list of packages.
.EXAMPLE
    PS> .\scoop-installs.ps1
    Installs Scoop, sets up buckets, installs packages, and upgrades them.
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

Write-Host "`n🔧 Starting Scoop setup..." -ForegroundColor Cyan

# Ensure Scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Scoop not found. Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-Expression (Invoke-RestMethod 'https://get.scoop.sh')

    # Install Git (required for buckets)
    Write-Host "🔧 Installing Git..."
    scoop install git

    # Install aria2 (for faster downloads)
    Write-Host "🚀 Installing aria2 for accelerated downloads..."
    scoop install aria2
} else {
    Write-Host "✅ Scoop is already installed."
}

# Add useful buckets
$scoopBuckets = @("extras", "versions", "nerd-fonts", "java", "games")
foreach ($bucket in $scoopBuckets) {
    if (-not (scoop bucket list | Select-String $bucket)) {
        Write-Host "➕ Adding bucket: $bucket"
        scoop bucket add $bucket
    } else {
        Write-Host "✅ Bucket already added: $bucket"
    }
}

# Define packages to install
$scoopApps = @(
    # Essentials
    "git", "7zip", "curl", "wget", "aria2", "sudo", "fzf", "jq", "bat", "ripgrep",

    # Developer tools
    "nodejs", "python", "go", "dotnet-sdk", "neovim", "vscode", "gcc", "cmake", "make",

    # Networking & web
    "ngrok", "httpie", "postman", "wireshark",

    # System utilities
    "sysinternals", "processhacker", "concfg", "oh-my-posh",

    # Fonts
    "nerd-fonts", "cascadia-code",

    # Games & media
    "vesktop", "musikcube", "goggalaxy",

    # Browsers
    "brave"
)

# Install each package
foreach ($app in $scoopApps) {
    Write-Host "`n📦 Installing: $app"
    scoop install $app
}

# Upgrade all installed packages
Write-Host "`n🔄 Upgrading all Scoop packages..."
scoop update *
scoop status

Write-Host "`n✅ Scoop setup complete!" -ForegroundColor Green
Write-Host "You can now use Scoop to manage your software installations easily." -ForegroundColor Green