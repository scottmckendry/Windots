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
- [Sudo](https://learn.microsoft.com/en-us/windows/sudo/) (Optional) - With the **Inline** option to support automatic Windots & software updates.

## 🚀 Installation

> [!WARNING]\
> Under _**active development**_, expect changes. Existing configuration files will be overwritten. Please make a backup of any files you wish to keep before proceeding.

1. Clone the repository to your preferred location.
2. Run `Setup.ps1` from an elevated PowerShell prompt.

## 🤝 Contributing

Pull requests and issues are welcome. If you have any questions or suggestions, please open an issue or reach out to me on [Twitter](https://twitter.com/scott_mckendry).

## 📸 Screenshots

![image](https://github.com/user-attachments/assets/1d00e6a3-dd20-4abb-97f5-81df0363ff38)
![image](https://github.com/user-attachments/assets/b51f1064-0e1a-4467-b308-9855ed275ed8)
![image](https://github.com/user-attachments/assets/ce120611-981b-4b2f-a307-097212200d5f)
![image](https://github.com/user-attachments/assets/bbb67965-4d95-4071-be0a-d3a58c4f1a14)
![image](https://github.com/user-attachments/assets/729cdc6c-961e-46b6-b848-cc4b8ecb923d)

---

<p align="center">
  <a href="https://scottmckendry.tech/tags/dotfiles/">
    <img alt="Static Badge" src="https://img.shields.io/badge/Blog_Posts-Go?style=for-the-badge&label=%F0%9F%92%ADRead&color=%237aa2f7">
  </a>
</p>
