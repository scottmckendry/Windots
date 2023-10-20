# Setup script for Windots
# Author: Scott McKendry
 
#Requires -RunAsAdministrator

# Linked Files (Destination => Source)
$symlinks = @{
    "$PROFILE.CurrentUserAllHosts" = ".\Profile.ps1"
    "$HOME\AppData\Local\nvim" = ".\nvim"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
    "$HOME\.gitconfig" = ".\.gitconfig"
    "$HOME\AppData\Roaming\lazygit" = ".\lazygit"
}

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing missing dependencies..."

# Install dependencies - Powershell, git, starship, node, eza, choco, zig, rg, fd, sed, lazygit, nvim, bat, fzf, zoxide
if (!(Get-Command "pwsh" -ErrorAction SilentlyContinue)) {
    winget install -e --id=Microsoft.PowerShell
}
if (!(Get-Command "git" -ErrorAction SilentlyContinue)) {
    winget install -e --id=Git.Git
}
if (!(Get-Command "starship" -ErrorAction SilentlyContinue)) {
    winget install -e --id Starship.Starship
}
if (!(Get-Command "npm" -ErrorAction SilentlyContinue)) {
    winget install -e --id OpenJS.NodeJS
}
if (!(Get-Command "eza" -ErrorAction SilentlyContinue)) {
    winget install -e --id=eza-community.eza
}
if (!(Get-Command "choco" -ErrorAction SilentlyContinue)) {
    winget install -e --id=Chocolatey.Chocolatey
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
if (!(Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    choco install -y neovim
}
if (!(Get-Command "bat" -ErrorAction SilentlyContinue)) {
    choco install -y bat
}
if (!(Get-Command "fzf" -ErrorAction SilentlyContinue)) {
    choco install -y fzf
}
if (!(Get-Command "zoxide" -ErrorAction SilentlyContinue)) {
    choco install -y zoxide
}


# Create Custom NVIM shotcut
if (!(Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nvim.lnk")) {
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nvim.lnk")
    $shortcut.TargetPath = "C:\tools\neovim\nvim-win64\bin\nvim.exe"
    $shortcut.workingDirectory = (Resolve-Path ..) # Set working directory to parent directory of this script (likely where you keep all Git Projects)
    $shortcut.IconLocation = "C:\tools\neovim\nvim-win64\bin\nvim-qt.exe,0" # Steal icon from nvim-qt.exe
    $shortcut.Save()
}

# Delete OOTB Nvim Shortcuts (including QT)
if (Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\") {
    Remove-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\" -Recurse -Force
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

$currentGitEmail = (git config --global user.email)
$currentGitName = (git config --global user.name)

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
    Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}

git config --global --unset user.email | Out-Null
git config --global --unset user.name | Out-Null
git config --global user.email $currentGitEmail | Out-Null
git config --global user.name $currentGitName | Out-Null
