# Dotfiles

This repo contains my dot files used to configure the local Linux account and some of the installed
applications.

## Installation

The dot files are "installed" from this repo by creating a bunch of symlinks. This is done with the
help of a command-line utility [rcm](https://github.com/thoughtbot/rcm). The steps are as follows:

1. Install the dotfiles management utility [rcm](https://github.com/thoughtbot/rcm)
2. Clone the repo to your Linux home directory, `~/.`, as follows

```sh
git clone https://github.com/oshevtsov/dotfiles.git ~/.dotfiles
```

3. Go to the cloned directory, `cd ~/.dotfiles`
4. Run the following command to create the symlinks (the `-v` flag stand for "verbose" and is
   optional)

```
rcup -v
```

5. Make sure that all the necessary programs required by the dotfiles are installed

- tmux
- neovim (run `:checkhealth` to see what is missing)
- nodejs
- ripgrep
- fd-find
