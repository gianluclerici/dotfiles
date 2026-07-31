# Prompt Starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# Editor predefinito
$env:EDITOR = "code --wait"

# Alias e funzioni condivise concettualmente con zsh
function Git-Status {
    git status
}

function Git-LogGraph {
    git log --oneline --graph --decorate
}

function List-All {
    Get-ChildItem -Force
}

Set-Alias gs Git-Status
Set-Alias gl Git-LogGraph
Set-Alias ll List-All
