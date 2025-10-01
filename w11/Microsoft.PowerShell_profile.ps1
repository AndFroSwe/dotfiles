# Stop annoying prediction
Set-PSReadlineOption -PredictionSource None

# Alias for config files
function GitConfig {git --git-dir=$HOME/.myconf --work-tree=$HOME}
Set-Alias -name config -value GitConfig

# Oh My Posh
oh-my-posh --init --shell pwsh --config ~/.config/oh-my-posh/andfro.omp.json | Invoke-Expression

