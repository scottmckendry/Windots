 <p align="center"> 
  <a href="https://scottmckendry.tech">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://scottmckendry.tech/img/logo/icon2transparent.png">
      <img src="https://scottmckendry.tech/img/logo/icon1transparent.png" height="100">
    </picture>
    <h1 align="center">Windots</h1>
  </a>
</p>

<p align="center">
  <a href="https://github.com/scottmckendry/Windots/commit">
    <img alt="LastCommit" src="https://img.shields.io/github/last-commit/scottmckendry/windots/main?style=for-the-badge&logo=github&color=%237dcfff">
  </a>
  <a href="https://github.com/scottmckendry/Windots/actions/workflows/sync.yml">
    <img alt="SyncStatus" src="https://img.shields.io/github/actions/workflow/status/scottmckendry/Windots/sync.yml?style=for-the-badge&logo=github&label=Sync%20to%20dots&color=%23bb9af7">
  </a>
  <a href="https://github.com/scottmckendry/Windots/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/scottmckendry/Windots?style=for-the-badge&logo=github&color=%239ece6a">
  </a>
  <a href="https://github.com/scottmckendry/Windots/stars">
    <img alt="stars" src="https://img.shields.io/github/stars/scottmckendry/windots?style=for-the-badge&logo=github&color=%23f7768e">
  </a>
</p>

My personal Windows-friendly dotfiles. Supports automatic installation of dependencies and configuration of Windows Terminal, Neovim, PowerShell Core and more!

## 🎉 Features
- **Automated Dependency Installation:** Utilises [Winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) and [Chocolatey](https://chocolatey.org/) for streamlined installation of required dependencies. Checks and notifies pending software updates with a 📦 icon in the prompt.
- **Automated Update Checks:** Regularly checks for updates using git. If updates are pending, an icon is displayed when starting a new PowerShell session.
  
  ![image](https://github.com/scottmckendry/Windots/assets/39483124/e84d0294-5662-4d7c-b1ae-88a1f26ca9fd)

- **Centralized Configuration:** Brings together scattered Windows configuration files into one organized location for easy access and management.
- **Tailored Colour Scheme:** Powered by my very own [CYBERDREAM](https://github.com/scottmckendry/cyberdream.nvim) colourscheme - high-contrast and vibrant for optimal _Eye Stimulation™_.

## ✅ Pre-requisites
- [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#install-powershell-using-winget-recommended)
- [Git](https://winget.run/pkg/Git/Git)

## 🚀 Installation
> [!WARNING]\
> Under _**active development**_, expect changes. Existing configuration files will be overwritten. Please make a backup of any files you wish to keep before proceeding.

1. Clone the repository to your preferred location.
2. Run `Setup.ps1` from an elevated PowerShell prompt. 

## 🤝 Contributing
Pull requests and issues are welcome. If you have any questions or suggestions, please open an issue or reach out to me on [Twitter](https://twitter.com/scott_mckendry).

## 📸 Screenshots
![image](https://github.com/scottmckendry/Windots/assets/39483124/e1189c49-9273-4e08-a6ce-39fa32777f7e)
![image](https://github.com/scottmckendry/Windots/assets/39483124/dd1e1a22-dc28-4b9b-ac1b-05540a7d45ae)
![image](https://github.com/scottmckendry/Windots/assets/39483124/8d22a088-45f8-4058-8ac0-ea8a675ff0c0)
![image](https://github.com/scottmckendry/Windots/assets/39483124/24ea9762-489b-43ab-86f9-03199941e7ce)

<hr>

<p align="center">
  <a href="https://scottmckendry.tech/tags/dotfiles/">
    <img alt="Static Badge" src="https://img.shields.io/badge/Blog_Posts-Go?style=for-the-badge&label=%F0%9F%92%ADRead&color=%237aa2f7">
  </a>
</p>
