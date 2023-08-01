# Elevated privileges required for creating symbolic links 
#Requires -RunAsAdministrator

Set-Location $PSScriptRoot

# Make sure Oh My Posh is installed
$ompPath = (Get-Command oh-my-posh).Source
if (!(Test-Path $ompPath)) {
    winget install -e -h --id=JanDeDobbeleer.oh-my-posh 
}

# Ensure nvim & chocolatey and mingw are installed
if (!(Get-Command nvim -ErrorAction SilentlyContinue)) {
    winget install -e --id Neovim.Neovim
}
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Chocolatey.Chocolatey
}
if (!(Get-Command gcc -ErrorAction SilentlyContinue)) {
    choco install -y mingw
}

# Install NVChad
if (!(Test-Path $HOME\AppData\Local\nvim\lua\core)) {
    git clone https://github.com/NvChad/NvChad $HOME\AppData\Local\nvim --depth 1
}

# Create Symbolic link to Profile.ps1 in PowerShell profile directory
New-Item -ItemType SymbolicLink -Path $PROFILE.CurrentUserAllHosts -Target (Resolve-Path .\Profile.ps1) -Force

# Create Symbolic link to custom nvim config directory
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim\lua\custom -Target (Resolve-Path .\nvim\lua\custom) -Force

# Install Terminal-Icons module
if (!(Get-Module -Name Terminal-Icons -ErrorAction SilentlyContinue)) {
    Install-Module -Name Terminal-Icons -Repository PSGallery
}

# Get all installed font families
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families

# Check if CaskaydiaCove NF is installed
if ($fontFamilies -notcontains "CaskaydiaCove NF") {
    # Download and install CaskaydiaCove NF
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", ".\CascadiaCode.zip")

    Expand-Archive -Path ".\CascadiaCode.zip" -DestinationPath ".\CascadiaCode" -Force
    $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    Get-ChildItem -Path ".\CascadiaCode" -Recurse -Filter "*.ttf" | ForEach-Object {
        If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {        
            # Install font
            $destination.CopyHere($_.FullName, 0x10)
        }
    }

    Remove-Item -Path ".\CascadiaCode" -Recurse -Force
    Remove-Item -Path ".\CascadiaCode.zip" -Force
}

# Import Windows Terminal settings
$terminalSettings = Get-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" | ConvertFrom-Json -Depth 20

# Add font face property to terminalSettings object
$font = @{
    "face" = "CaskaydiaCove Nerd Font Mono"
}

Add-Member -InputObject $terminalSettings.profiles.defaults -MemberType NoteProperty -Name "font" -Value $font -Force

# Set Windows Terminal settings
$terminalSettings | ConvertTo-Json -Depth 20 | Set-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force
