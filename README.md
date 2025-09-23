# Andfro Dotfiles

Dotfiles for both windows and linux.

Uses method form [this](https://news.ycombinator.com/item?id=11070797) link. Basically, clone the repository to a separate folder and set the home folder as the working tree.

``` bash
git init --bare $HOME/.myconfgit init --bare $HOME/.myconf
git clone --separate-git-dir=$HOME/.myconf /path/to/repo $HOME/myconf-tmp
```

Also, add a handy `config` command for using the git config.

``` bash
alias config='/usr/bin/git --git-dir=$HOME/.myconf --work-tree=$HOME'
```
