# Setup script for Windots
# Author: Scott McKendry
 
#Requires -RunAsAdministrator

# Required PowerShell Modules
$requiredModules = @(
    "Terminal-Icons"
)

# Set working directory
Set-Location $PSScriptRoot

Write-Host "Installing missing dependencies..."

# Install dependencies - pwsh, git, OMP, neovim, choco, zig, ripgrep, fd, sed, lazygit
if (!(Get-Command "pwsh" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Microsoft.PowerShell
}
if (!(Get-Command "git" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Git.Git
}
if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=JanDeDobbeleer.OhMyPosh
}
if (!(Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id Neovim.Neovim
}
if (!(Get-Command "choco" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Chocolatey.Chocolatey
}
# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Choco Deps
if (!(Get-Command "zig" -ErrorAction SilentlyContinue)) {
    choco install -y zig
}
if (!(Get-Command "rg" -ErrorAction SilentlyContinue)) {
    choco install -y ripgrep
}
if (!(Get-Command "fd" -ErrorAction SilentlyContinue)) {
    choco install -y fd
}
if (!(Get-Command "sed" -ErrorAction SilentlyContinue)) {
    choco install -y sed
}
if (!(Get-Command "lazygit" -ErrorAction SilentlyContinue)) {
    choco install -y lazygit
}

# Create Custom NVIM shotcut
if (!(Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nvim.lnk")) {
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nvim.lnk")
    $shortcut.TargetPath = "C:\Program Files\Neovim\bin\nvim.exe"
    $shortcut.workingDirectory = (Resolve-Path ..) # Set working directory to parent directory of this script (likely where you keep all Git Projects)
    $shortcut.IconLocation = "C:\Program Files\Neovim\bin\nvim-qt.exe,0" # Steal icon from nvim-qt.exe
    $shortcut.Save()
}

# Delete OOTB Nvim Shortcuts (including QT)
if (Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\") {
    Remove-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\" -Recurse -Force
}

# Create Symbolic Links for Profile, Neovim, Windows Terminal and gitconfig
Write-Host "Creating Symbolic Links..."

New-Item -ItemType SymbolicLink -Path "$PROFILE.CurrentUserAllHosts" -Target (Resolve-Path .\Profile.ps1) -Force | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target (Resolve-Path .\nvim) -Force | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target (Resolve-Path .\windowsterminal\settings.json) -Force | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\.gitconfig" -Target (Resolve-Path .\.gitconfig) -Force | Out-Null

# Install Required PowerShell Modules
Write-Host "Installing missing PowerShell Modules..."
foreach ($module in $requiredModules){
    if (!(Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue)) {
        Install-Module $module -Scope CurrentUser -Force
    }
}

Write-Host "Installing Fonts..."
# Get all installed font families
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families

# Check if CaskaydiaCove NF is installed
if ($fontFamilies -notcontains "JetBrainsMono NF") {
    # Download and install CaskaydiaCove NF
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip", ".\JetBrainsMono.zip")

    Expand-Archive -Path ".\JetBrainsMono.zip" -DestinationPath ".\JetBrainsMono" -Force
    $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)

    $fonts = Get-ChildItem -Path ".\JetBrainsMono" -Recurse -Filter "*.ttf"
    foreach ($font in $fonts) {
        # Only install standard fonts (16 fonts instead of 90+)
        if ($font.Name -like "JetBrainsMonoNerdFont-*.ttf"){
            $destination.CopyHere($font.FullName, 0x10)
        }
    }

    Remove-Item -Path ".\JetBrainsMono" -Recurse -Force
    Remove-Item -Path ".\JetBrainsMono.zip" -Force
}
