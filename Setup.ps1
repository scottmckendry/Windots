# Setup script for Windots
#Requires -RunAsAdministrator

# Linked Files (Destination => Source)
$symlinks = @{
    $PROFILE.CurrentUserAllHosts = ".\Profile.ps1"
    "$HOME\AppData\Local\nvim" = ".\nvim"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
    "$HOME\.gitconfig" = ".\.gitconfig"
    "$HOME\AppData\Roaming\lazygit" = ".\lazygit"
}

# Winget & choco dependencies (cmd => package name)
$wingetDeps = @{
    "pwsh" = "Microsoft.PowerShell"
    "git" = "Git.Git"
    "starship" = "Starship.Starship"
    "npm" = "OpenJS.NodeJS"
    "eza" = "eza-community.eza"
    "java" = "Microsoft.OpenJDK.21"
    "choco" = "Chocolatey.Chocolatey"
}
$chocoDeps = @{
    "zig" = "zig"
    "rg" = "ripgrep"
    "fd" = "fd"
    "sed" = "sed"
    "lazygit" = "lazygit"
    "nvim" = "neovim"
    "bat" = "bat"
    "fzf" = "fzf"
    "zoxide" = "zoxide"
}

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing missing dependencies..."
foreach ($wingetDep in $wingetDeps.GetEnumerator()) {
    if (!(Get-Command $wingetDep.Key -ErrorAction SilentlyContinue)) {
        winget install -e --id $wingetDep.Value
    }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

foreach ($chocoDep in $chocoDeps.GetEnumerator()) {
    if (!(Get-Command $chocoDep.Key -ErrorAction SilentlyContinue)) {
        choco install -y $chocoDep.Value
    }
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
