# Setup script for Windots
#Requires -RunAsAdministrator

# Linked Files (Destination => Source)
$symlinks = @{
    $PROFILE.CurrentUserAllHosts                                                                    = ".\Profile.ps1"
    "$HOME\AppData\Local\nvim"                                                                      = ".\nvim"
    "$HOME\AppData\Local\fastfetch"                                                                 = ".\fastfetch"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
    "$HOME\.gitconfig"                                                                              = ".\.gitconfig"
    "$HOME\AppData\Roaming\lazygit"                                                                 = ".\lazygit"
    "$HOME\AppData\Roaming\AltSnap\AltSnap.ini"                                                     = ".\altsnap\AltSnap.ini"
    "$ENV:PROGRAMFILES\WezTerm\wezterm_modules"                                                     = ".\wezterm\"
}

# Winget & choco dependencies
$wingetDeps = @(
    "chocolatey.chocolatey"
    "eza-community.eza"
    "ezwinports.make"
    "fastfetch-cli.fastfetch"
    "git.git"
    "github.cli"
    "kitware.cmake"
    "mbuilov.sed"
    "microsoft.powershell"
    "neovim.neovim"
    "openjs.nodejs"
    "starship.starship"
)
$chocoDeps = @(
    "altsnap"
    "bat"
    "fd"
    "fzf"
    "gawk"
    "lazygit"
    "mingw"
    "nerd-fonts-jetbrainsmono"
    "ripgrep"
    "sqlite"
    "wezterm"
    "zig"
    "zoxide"
)

# PS Modules
$psModules = @(
    "CompletionPredictor"
    "PSScriptAnalyzer"
    "ps-arch-wsl"
    "ps-color-scripts"
)

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch $wingetDep) {
        winget install --id $wingetDep
    }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$installedChocoDeps = (choco list --limit-output --id-only).Split("`n")
foreach ($chocoDep in $chocoDeps) {
    if ($installedChocoDeps -notcontains $chocoDep) {
        choco install $chocoDep -y
    }
}

# Install PS Modules
foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
    }
}

# Delete OOTB Nvim Shortcuts (including QT)
if (Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\") {
    Remove-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\" -Recurse -Force
}

# Persist Environment Variables
[System.Environment]::SetEnvironmentVariable('WEZTERM_CONFIG_FILE', "$PSScriptRoot\wezterm\wezterm.lua", [System.EnvironmentVariableTarget]::User)

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

# Install bat themes
bat cache --clear
bat cache --build

.\altsnap\createTask.ps1 | Out-Null
