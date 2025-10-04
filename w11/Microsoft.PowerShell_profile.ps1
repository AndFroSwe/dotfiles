# Stop annoying prediction
Set-PSReadlineOption -PredictionSource None

# Oh My Posh
oh-my-posh --init --shell pwsh --config ~/.config/oh-my-posh/andfro.omp.json | Invoke-Expression
