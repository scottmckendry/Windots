# Simple install script for Arch Linux in WSL
# More info at https://github.com/scottmckendry/ps-arch-wsl

#requires -RunAsAdministrator
#requires -Modules ps-arch-wsl

Set-Location -Path $PSScriptRoot
$Credential = Get-Credential -UserName "scott"
Install-ArchWSL -Credential $Credential -PostInstallScript "./arch-post-install.sh"
