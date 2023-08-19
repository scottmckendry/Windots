# Initial Install Script to install dependencies before running Setup.ps1

# Install PowerShell 7, git & Chocolatey
if (!(Get-Command "pwsh" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Microsoft.PowerShell
}
if (!(Get-Command "git" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Git.Git
}
if (!(Get-Command "choco" -ErrorAction SilentlyContinue)) {
    winget install -e -h --id=Chocolatey.Chocolatey
}

# Reload Path to include new installs
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Clone Repo
git clone https://github.com/scottmckendry/Windots

Set-Location Windots

# Start setup Script in PowerShell 7
Start-Process pwsh -Verb runAs -WorkingDirectory $PWD -ArgumentList "-Command .\Setup.ps1"
