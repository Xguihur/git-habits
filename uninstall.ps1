[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$Start = '# >>> git-habits >>>'
$End = '# <<< git-habits <<<'
$ConfigDir = Join-Path $HOME '.git-habits'
$ProfilePath = $PROFILE
if (Test-Path -LiteralPath $ProfilePath -PathType Leaf) {
    $Existing = Get-Content -LiteralPath $ProfilePath -Raw
    $Pattern = '(?ms)^' + [regex]::Escape($Start) + '\r?\n.*?^' + [regex]::Escape($End) + '\r?\n?'
    $Clean = [regex]::Replace($Existing, $Pattern, '')
    if ($Clean -ne $Existing) {
        $Backup = "$ProfilePath.git-habits.bak.$(Get-Date -Format yyyyMMddHHmmss)"
        Copy-Item -LiteralPath $ProfilePath -Destination $Backup
        Set-Content -LiteralPath $ProfilePath -Value $Clean -NoNewline
        Write-Output "Removed git-habits block from: $ProfilePath"
        Write-Output "Backup: $Backup"
    } else { Write-Output "No git-habits block found in: $ProfilePath" }
}
if (Test-Path -LiteralPath $ConfigDir) {
    Remove-Item -LiteralPath $ConfigDir -Recurse -Force
    Write-Output "Removed generated configuration: $ConfigDir"
} else { Write-Output "Generated configuration not found: $ConfigDir" }
Write-Output 'Existing user configuration and backups were preserved.'
