& (Join-Path $PSScriptRoot 'install.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
