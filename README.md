# Andfro Dotfiles

Dotfiles for both windows and linux. Uses bootstrap scripts and symlinks for
setting up the environment.

## Usage

Clone repo and run boostrap script. Note that the W11 version needs admin
to create the symlinks.

``` bash
git clone https://git@github.com/andfroswe/dotfiles ~/.myconf
cd ~/.myconf
./bootstrap.sh
```

If running for Arch, run in terminal before opening Hyprland, otherwise a Hyprland will lose the config until reboot.

Or for windows, do the same but run

``` pswh
./boostrap.ps1
```
