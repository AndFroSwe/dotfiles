# Bootstrap script for dotfiles on Windows
# Requires Administrator privileges or Developer Mode to create symlinks

Write-Output "Starting dotfile bootstrap script for Windows..."

$ConfigPath = "$HOME\.config"

# Check if the .config folder exists; create it if not
if (-not (Test-Path $ConfigPath -PathType Container)) {
    Write-Output "Config folder does not exist at $ConfigPath, creating..."
    New-Item -ItemType Directory -Path $ConfigPath | Out-Null
} else {
    Write-Output "Config folder already exists at $ConfigPath"
}

# Define dotfiles: list of [PSCustomObject]s with Source, TargetDir, TargetFile
$dotfiles = @(
    [PSCustomObject]@{
        Source     = "$PWD\shared\oh-my-posh\andfro.omp.json"
        TargetDir  = "$ConfigPath\oh-my-posh"
        TargetFile = "andfro.omp.json"
    },
    [PSCustomObject]@{
        Source     = "$PWD\shared\wezterm\wezterm.lua"
        TargetDir  = "$ConfigPath\wezterm"
        TargetFile = "wezterm.lua"
    },
    [PSCustomObject]@{
        Source     = "$PWD\shared\spotify-player\app.toml"
        TargetDir  = "$ConfigPath\spotify-player"
        TargetFile = "app.toml"
    },
    [PSCustomObject]@{
        Source     = "$PWD\w11\Microsoft.PowerShell_profile.ps1"
        TargetDir  = Split-Path $PROFILE
        TargetFile = Split-Path $PROFILE -Leaf
    }
)

# Iterate over dotfiles
foreach ($dotfile in $dotfiles) {
    Write-Output "`nSetting up $($dotfile.Source)..."

    $targetDir = $dotfile.TargetDir
    $targetFile = $dotfile.TargetFile
    $targetPath = Join-Path $targetDir $targetFile

    # Create target directory if it doesn't exist
    if (-not (Test-Path $targetDir -PathType Container)) {
        Write-Output "Target directory $targetDir does not exist. Creating..."
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    # Check if the dotfile already exists
    if (Test-Path $targetPath) {
        Write-Warning "Dotfile already exists at $targetPath. Remove it manually if you want to recreate the link. Skipping..."
        continue
    }

    # Create symbolic link
    Write-Output "Creating symlink: $targetPath -> $($dotfile.Source)"
    New-Item -ItemType SymbolicLink -Path $targetPath -Target $dotfile.Source | Out-Null
}

Write-Output "`nDotfile setup complete!"
