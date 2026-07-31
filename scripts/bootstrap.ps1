param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$DotfilesDirectory = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDirectory = Join-Path $HOME ".dotfiles-backup\$Timestamp"

function Invoke-DotfilesAction {
    param(
        [scriptblock]$Action,
        [string]$Description
    )

    if ($DryRun) {
        Write-Host "[Anteprima] $Description" -ForegroundColor Yellow
    }
    else {
        & $Action
    }
}

function New-DotfileLink {
    param(
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination
    )

    $Source = [System.IO.Path]::GetFullPath($Source)
    $Destination = [System.IO.Path]::GetFullPath($Destination)

    if (Test-Path -LiteralPath $Destination) {
        $ExistingItem = Get-Item -LiteralPath $Destination -Force

        if (
            $ExistingItem.LinkType -eq "SymbolicLink" -and
            $ExistingItem.Target -eq $Source
        ) {
            Write-Host "Già collegato: $Destination"
            return
        }

        $RelativePath = $Destination.Substring($HOME.Length)
        $RelativePath = $RelativePath.TrimStart("\", "/")
        $BackupPath = Join-Path $BackupDirectory $RelativePath
        $BackupParent = Split-Path -Parent $BackupPath

        Write-Host "Backup: $Destination"

        Invoke-DotfilesAction {
            New-Item -ItemType Directory `
                -Path $BackupParent `
                -Force | Out-Null

            Move-Item `
                -LiteralPath $Destination `
                -Destination $BackupPath
        } "Sposta $Destination in $BackupPath"
    }

    $DestinationParent = Split-Path -Parent $Destination

    Write-Host "Collegamento: $Destination -> $Source"

    Invoke-DotfilesAction {
        New-Item -ItemType Directory `
            -Path $DestinationParent `
            -Force | Out-Null

        New-Item -ItemType SymbolicLink `
            -Path $Destination `
            -Target $Source | Out-Null
    } "Crea il collegamento $Destination -> $Source"
}

Write-Host "Repository: $DotfilesDirectory"
Write-Host "PowerShell: $($PSVersionTable.PSVersion)"

New-DotfileLink `
    -Source "$DotfilesDirectory\home\.gitconfig" `
    -Destination "$HOME\.gitconfig"

New-DotfileLink `
    -Source "$DotfilesDirectory\home\.config\starship.toml" `
    -Destination "$HOME\.config\starship.toml"

New-DotfileLink `
    -Source "$DotfilesDirectory\home\.config\wezterm" `
    -Destination "$HOME\.config\wezterm"

New-DotfileLink `
    -Source "$DotfilesDirectory\platform\windows\Microsoft.PowerShell_profile.ps1" `
    -Destination $PROFILE.CurrentUserCurrentHost

if ($DryRun) {
    Write-Host "Anteprima completata: nessun file è stato modificato."
}
else {
    Write-Host "Configurazione Windows completata."
    Write-Host "Backup: $BackupDirectory"
}
