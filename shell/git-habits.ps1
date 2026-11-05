# Generated runtime for git-habits. Keep command definitions in config/commands.tsv.

function cl { Clear-Host }
function gad { git add . }
function gcm {
    if ($args.Count -eq 0) {
        Write-Error 'Usage: gcm <message>'
        return
    }
    git commit -m ($args -join ' ')
}
function gps { git push @args }
function gpl { git pull @args }
function gmg { git merge @args }
function gst { git status @args }
function glg { git log @args }
function gll { git log --oneline @args }
function gcl { git clone @args }
function nrd { npm run dev @args }
function nrb { npm run build @args }
