<#
                      7#G~
                    7BB7J#P~
                 .?BG!   .?#G!
                :B@J       .?BB7
             ::  :Y#P~        7BB?.
           ^Y#?    :J#G~        !GB?.
          !&@!       .?#G!        J@B:
       ~^  ^Y#5^       .7BB7    .PB?.  ~^
    .!GB7    :Y#5^        !GB7.  ^.    Y#5^
    7&&~       !@@G~       .P@#J.       J@B^
     :J#G~   ~P#J^?#G!   .?#G~~P#Y:  .7BB7
       .?BG7P#J.   .7BB7J#P~    ^5#Y?BG!
         .?BJ.        7#G~        ^5B!

    Author: Scott McKendry
    Description: PowersShell Profile containing aliases and functions to be loaded when a new PowerShell session is started.
#>

# Initialise logging - helpful for debugging slow profile load times
$enableLog = $false

if ($enableLog) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $logPath = "$env:USERPROFILE/Profile.log"
}
function Add-ProfileLogEntry {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message
    )

    if (!$enableLog) {
        return
    }

    "`n$($stopwatch.ElapsedMilliseconds)ms`t$Message" | Out-File -FilePath $logPath -Append
}
Add-ProfileLogEntry "Starting profile load"

# Aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name su -Value Start-AdminSession
Set-Alias -Name up -Value Update-Profile
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name touch -Value New-File
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name which -Value Show-Command
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name tif Show-ThisIsFine
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
Set-Alias -Name cat -Value bat
Set-Alias -Name us -Value Update-Software

Add-ProfileLogEntry "Aliases loaded"

# Putting the FUN in Functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Find-WindotsRepository {
    <#
    .SYNOPSIS
        Finds the local Windots repository.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProfilePath
    )

    Write-Verbose "Resolving the symbolic link for the profile"
    $profileSymbolicLink = Get-ChildItem $ProfilePath | Where-Object FullName -EQ $PROFILE.CurrentUserAllHosts
    return Split-Path $profileSymbolicLink.Target
}

function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su
    #>
    Start-Process wezterm -Verb runAs -WindowStyle Hidden -ArgumentList "start --cwd $PWD"
}

function Update-Profile {
    <#
    .SYNOPSIS
        Downloads the latest version of the PowerShell profile from Github, updates the PowerShell profile with the latest version and reruns the setup script.
        Note that functions won't be updated, this requires a full restart. Alias: up
    #>
    Write-Verbose "Storing current working directory in memory"
    $currentWorkingDirectory = $PWD

    Write-Verbose "Updating local profile from Github repository"
    Set-Location $ENV:WindotsLocalRepo
    git pull | Out-Null

    Write-Verbose "Rerunning setup script to capture any new dependencies."
    Start-Process wezterm -Verb runAs -WindowStyle Hidden -ArgumentList "start --cwd $PWD pwsh -Command .\Setup.ps1"

    Write-Verbose "Reverting to previous working directory"
    Set-Location $currentWorkingDirectory

    Write-Verbose "Re-running profile script from $($PROFILE.CurrentUserAllHosts)"
    .$PROFILE.CurrentUserAllHosts
}

function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    Write-Verbose "Updating software installed via Winget & Chocolatey"
    Start-Process wezterm -Verb runAs -WindowStyle Hidden -ArgumentList "start -- pwsh -Command &{winget upgrade --all && choco upgrade all -y}"
    $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
}

function Find-File {
    <#
    .SYNOPSIS
        Finds a file in the current directory and all subdirectories. Alias: ff
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true, Position = 0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
    $result = Get-ChildItem -Recurse -Filter "*$SearchTerm*" -ErrorAction SilentlyContinue

    Write-Verbose "Outputting results to table"
    $result | Format-Table -AutoSize
}

function Find-String {
    <#
    .SYNOPSIS
        Searches for a string in a file or directory. Alias: grep
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$SearchTerm,
        [Parameter(ValueFromPipeline, Mandatory = $false, Position = 1)]
        [string]$Directory,
        [Parameter(Mandatory = $false)]
        [switch]$Recurse
    )

    Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
    if ($Directory) {
        if ($Recurse) {
            Write-Verbose "Searching for '$SearchTerm' in '$Directory' and subdirectories"
            Get-ChildItem -Recurse $Directory | Select-String $SearchTerm
            return
        }

        Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
        Get-ChildItem $Directory | Select-String $SearchTerm
        return
    }

    if ($Recurse) {
        Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
        Get-ChildItem -Recurse | Select-String $SearchTerm
        return
    }

    Write-Verbose "Searching for '$SearchTerm' in current directory"
    Get-ChildItem | Select-String $SearchTerm
}

function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}

function Show-Command {
    <#
    .SYNOPSIS
        Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

function Get-OrCreateSecret {
    <#
    .SYNOPSIS
        Gets secret from local vault or creates it if it does not exist. Requires SecretManagement and SecretStore modules and a local vault to be created.
        Install Modules with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
        Create local vault with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
            Set-SecretStoreConfiguration -Authentication None -Confirm:$False

        https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

    .PARAMETER secretName
        Name of the secret to get or create. It is recommended to use the username or public key / client id as secret name to make it easier to identify the secret later.

    .EXAMPLE
        $password = Get-OrCreateSecret -secretName $username

    .EXAMPLE
        $clientSecret = Get-OrCreateSecret -secretName $clientId

    .OUTPUTS
        System.String
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$secretName
    )

    Write-Verbose "Getting secret $secretName"
    $secretValue = Get-Secret $secretName -AsPlainText -ErrorAction SilentlyContinue

    if (!$secretValue) {
        $createSecret = Read-Host "No secret found matching $secretName, create one? Y/N"

        if ($createSecret.ToUpper() -eq "Y") {
            $secretValue = Read-Host -Prompt "Enter secret value for ($secretName)" -AsSecureString
            Set-Secret -Name $secretName -SecureStringSecret $secretValue
            $secretValue = Get-Secret $secretName -AsPlainText
        }
        else {
            throw "Secret not found and not created, exiting"
        }
    }
    return $secretValue
}

function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Show-ThisIsFine {
    <#
    .SYNOPSIS
        Displays the "This is fine" meme in the console. Alias: tif
    #>
    Write-Verbose "Running thisisfine.ps1"
    Invoke-Expression (Get-Content "$env:WindotsLocalRepo\art\thisisfine.ps1" -Raw)
}

Add-ProfileLogEntry -Message "Functions loaded"

# Environment Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$ENV:WindotsLocalRepo = Find-WindotsRepository -ProfilePath $PSScriptRoot
$ENV:STARSHIP_CONFIG = "$ENV:WindotsLocalRepo\starship\starship.toml"
$ENV:_ZO_DATA_DIR = $ENV:WindotsLocalRepo
$ENV:OBSIDIAN_PATH = "$HOME\iCloudDrive\iCloud~md~obsidian\Obsidian"

# Check for Windots and software updates while prompt is loading
Start-ThreadJob -ScriptBlock {
    Set-Location -Path $ENV:WindotsLocalRepo
    $gitUpdates = git fetch && git status
    if ($gitUpdates -match "behind") {
        $ENV:DOTFILES_UPDATE_AVAILABLE = "`u{db86}`u{dd1b} "
    }
    else {
        $ENV:DOTFILES_UPDATE_AVAILABLE = ""
    }
} | Out-Null

Add-ProfileLogEntry -Message "Git fetch job started"

Start-ThreadJob -ScriptBlock {
    <#
        This is gross, I know. But there's a noticible lag that manifests in powershell when running the winget and choco commands
        within the main pwsh process. Running this whole block as an isolated job fails to set the environment variable correctly.
        The compromise is to run the main logic of this block within a threadjob and get the output of the winget and choco commands
        via two isolated jobs. This sets the environment variable correctly and doesn't cause any lag (that I've noticed yet).
    #>
    $wingetUpdatesString = Start-Job -ScriptBlock { winget list --upgrade-available | Out-String } | Wait-Job | Receive-Job
    $chocoUpdatesString = Start-Job -ScriptBlock { choco upgrade all --noop | Out-String } | Wait-Job | Receive-Job
    if ($wingetUpdatesString -match "upgrades available" -or $chocoUpdatesString -notmatch "can upgrade 0/") {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = "`u{eb29} "
    }
    else {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
    }
} | Out-Null

Add-ProfileLogEntry -Message "Update check job started"

# Prompt Setup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { ( zoxide init powershell --cmd cd | Out-String ) })

Add-ProfileLogEntry -Message "Prompt setup complete"

$enableLog ? $stopwatch.Stop() : $null
Add-ProfileLogEntry -Message "Profile load complete"

