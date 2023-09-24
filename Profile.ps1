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
$logPath = "$env:USERPROFILE/Profile.log"
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
"`n$($stopwatch.ElapsedMilliseconds)ms`tProfile load started" | Out-File -FilePath $logPath -Append

# Aliases & Custom Envioronment Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name su -Value Start-AdminSession
Set-Alias -Name up -Value Update-Profile
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name touch -Value New-File
Set-Alias -Name df -Value Get-Volume
# Set-Alias -Name sed -Value Set-String # Replaced by sed.exe
Set-Alias -Name which -Value Show-Command
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name tif Show-ThisIsFine

"$($stopwatch.ElapsedMilliseconds)ms`tAliases set" | Out-File -FilePath $logPath -Append

# Putting the FUN in Functions 😎
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
function Get-LatestProfile {
    <#
    .SYNOPSIS
        Checks the Github repository for the latest commit date and compares to the local version.
        If the profile is out of date, instructions are displayed on how to update it.
    #>

    Write-Verbose "Checking for updates to the profile"
    $currentWorkingDirectory = $PWD
    Set-Location $ENV:WindotsLocalRepo
    $gitStatus = git status

    if ($gitStatus -like "*Your branch is up to date with*") {
        Write-Verbose "Profile is up to date"
        Set-Location $currentWorkingDirectory
        return
    }
    else {
        Write-Verbose "Profile is out of date"
        Write-Host "Your PowerShell profile is out of date with the latest commit. To update it, run Update-Profile." -ForegroundColor Yellow
        Set-Location $currentWorkingDirectory
    }
} 
function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su 
    #>
    Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command &{Set-Location $PWD}"
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
    Start-Process pwsh -Verb runAs -WorkingDirectory $PWD -ArgumentList "-Command .\Setup.ps1"

    Write-Verbose "Reverting to previous working directory"
    Set-Location $currentWorkingDirectory
    
    Write-Verbose "Re-running profile script from $($PROFILE.CurrentUserAllHosts)"
    .$PROFILE.CurrentUserAllHosts
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

function Set-String {
    <#
    .SYNOPSIS
        Replaces a string in a file. Alias: sed (deprecated, use sed.exe instead)
    .EXAMPLE
        Set-String -File "C:\Users\Scott\Documents\test.txt" -Find "Hello" -Replace "Goodbye"
    .EXAMPLE
        sed test.txt Hello Goodbye
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$File,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Find,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Replace
    )
    Write-Verbose "Replacing '$Find' with '$Replace' in '$File'"
    (Get-Content $File).replace("$Find", $Replace) | Set-Content $File
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
        Drop in replacement for Get-ChildItem that lazy loads the Terminal-Icons Module first. This improves profile start up time dramatically.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )
    Write-Verbose "Importing Terminal-Icons module"
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    Write-Verbose "Showing children of '$Path'"
    Get-ChildItem $Path | Format-Table -AutoSize
}

function Show-ThisIsFine {
    <#
    .SYNOPSIS
        Displays the "This is fine" meme in the console. Alias: tif
    #>
    Write-Verbose "Running thisisfine.ps1"
    Invoke-Expression (Get-Content "$env:WindotsLocalRepo\art\thisisfine.ps1" -Raw)
}

"$($stopwatch.ElapsedMilliseconds)ms`tFunctions loaded" | Out-File -FilePath $logPath -Append

# Custom Environment Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$ENV:IsAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$ENV:WindotsLocalRepo = Find-WindotsRepository -ProfilePath $PSScriptRoot
$ENV:STARSHIP_CONFIG = "$ENV:WindotsLocalRepo\starship\starship.toml"

# Check for Git updates while prompt is loading
Start-ThreadJob -ScriptBlock { Set-Location $ENV:WindotsLocalRepo && git fetch --all } | Out-Null

"$($stopwatch.ElapsedMilliseconds)ms`tGit fetch job started" | Out-File -FilePath $logPath -Append

# Prompt Setup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Invoke-Expression (&starship init powershell)

"$($stopwatch.ElapsedMilliseconds)ms`tPrompt initialised" | Out-File -FilePath $logPath -Append

# Check for updates
Get-LatestProfile

$stopwatch.Stop()

"$($stopwatch.ElapsedMilliseconds)ms`tProfile load complete" | Out-File -FilePath $logPath -Append
