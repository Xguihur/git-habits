[CmdletBinding()]
param()
$ErrorActionPreference = 'Continue'
$Start = '# >>> git-habits >>>'
$End = '# <<< git-habits <<<'
$ConfigDir = Join-Path $HOME '.git-habits'
Write-Output "OS: $([System.Environment]::OSVersion.VersionString)"
Write-Output "Shell: PowerShell $($PSVersionTable.PSVersion)"
Write-Output "Profile: $PROFILE"
foreach ($Name in @('git', 'npm')) {
    if (Get-Command $Name -ErrorAction SilentlyContinue) { Write-Output "OK: $Name ($((Get-Command $Name).Source))" }
    else { Write-Output "MISSING: $Name" }
}
if (Test-Path -LiteralPath $PROFILE) {
    $ProfileText = Get-Content -LiteralPath $PROFILE -Raw
    if ($ProfileText.Contains($Start) -and $ProfileText.Contains($End)) { Write-Output 'OK: loading block found' }
    else { Write-Output 'MISSING: loading block in profile' }
} else { Write-Output "MISSING: profile file $PROFILE" }
$Generated = Join-Path $ConfigDir 'git-habits.ps1'
if (Test-Path -LiteralPath $Generated) { Write-Output "OK: generated PowerShell config: $Generated" }
else { Write-Output "MISSING: generated PowerShell config: $Generated" }
foreach ($Name in @('cl','gad','gcm','gps','gpl','gmg','gst','glg','gll','gcl','nrd','nrb')) {
    if (Get-Command $Name -ErrorAction SilentlyContinue) { Write-Output "OK: command $Name" }
    else { Write-Output "NOTE: command $Name is unavailable in this session (reload profile?)" }
}
