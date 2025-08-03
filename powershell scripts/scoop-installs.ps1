<#
.SYNOPSIS
    Scoop installs
.DESCRIPTION
    This PowerShell script installs Scoop and packages
.PARAMETER scoopPackages
    Specifies the list of Scoop packages to install
.EXAMPLE
    PS> .\scoop-installs.ps1
    Install Scoop
    Set Scoop flag for errors
    Install Scoop packages
    Upgrade Scoop packages
    Notify you've installed Scoop and packages
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
} else {
    Write-Host "✅ Scoop is already installed."
}

# Add useful buckets
$scoopBuckets = @("extras", "versions", "nerd-fonts", "java")
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
    "nerd-fonts", "cascadia-code"
)

# Install each package
foreach ($app in $scoopApps) {
    Write-Host "`n📦 Installing: $app"
    scoop install $app
}

Write-Host "`n✅ Scoop setup complete!" -ForegroundColor Green
