[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$RootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigDir = Join-Path $HOME '.git-habits'
$Start = '# >>> git-habits >>>'
$End = '# <<< git-habits <<<'
$ProfilePath = $PROFILE

function Backup-IfPresent([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
    $Backup = "$Path.git-habits.bak"
    if (Test-Path -LiteralPath $Backup) { $Backup = "$Path.git-habits.bak.$(Get-Date -Format yyyyMMddHHmmss)" }
    Copy-Item -LiteralPath $Path -Destination $Backup
    Write-Output "Backup: $Backup"
}
function Replace-ManagedBlock([string]$Path, [string]$Block) {
    $Existing = if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw } else { '' }
    $Pattern = '(?ms)^' + [regex]::Escape($Start) + '\r?\n.*?^' + [regex]::Escape($End) + '\r?\n?'
    $Clean = [regex]::Replace($Existing, $Pattern, '')
    $New = ($Clean.TrimEnd() + "`r`n$Block`r`n")
    if ($New -ne $Existing) {
        Backup-IfPresent $Path
        $Parent = Split-Path -Parent $Path
        if ($Parent) { New-Item -ItemType Directory -Path $Parent -Force | Out-Null }
        Set-Content -LiteralPath $Path -Value $New -NoNewline
        Write-Output "Updated: $Path"
    }
}
New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $RootDir 'shell/git-habits.ps1') -Destination (Join-Path $ConfigDir 'git-habits.ps1') -Force
$Block = "$Start`r`n. `"$ConfigDir\git-habits.ps1`"`r`n$End"
Replace-ManagedBlock $ProfilePath $Block
Write-Output "Installed PowerShell commands from $(Join-Path $ConfigDir 'git-habits.ps1')"
Write-Output "Profile: $ProfilePath"
Write-Output 'Open a new PowerShell session or run: . $PROFILE'
