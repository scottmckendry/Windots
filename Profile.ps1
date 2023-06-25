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

# Imports
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import Terminal-Icons module - This makes ls (Get-ChildItem) display icons for files and folders
Import-Module Terminal-Icons


# Aliases & Custom Envioronment Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name su -Value Start-AdminSession
Set-Alias -Name up -Value Update-Profile
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name touch -Value New-File
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name sed -Value Set-String
Set-Alias -Name which -Value Show-Command
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name l -Value Get-ChildItem

# Custom Environment Variables
$ENV:IsAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Putting the FUN in Functions 😎
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su 
    #>
    Start-Process wt -Verb runAs
}

function Update-Profile {
    <#
    .SYNOPSIS
        Updates the PowerShell profile with the latest version.Alternative to completely restarting the action session. 
        Note that functions won't be updated, this requires a full restart. Alias: up
    #>
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
        Replaces a string in a file. Alias: sed
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

# Prompt Setup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Oh-My-Posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression