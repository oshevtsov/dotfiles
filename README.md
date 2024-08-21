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
rcup rcrc
rcup config/nvim
```

It is important to run `rcup rcrc` first since it sets up the configuration for the `rcm` tool itself.

5. Make sure that all the necessary programs required by the dotfiles are installed

- tmux
- neovim (run `:checkhealth` to see what is missing)
- nodejs
- ripgrep
- fd-find

## Notes

### Rust

There are some behaviors of `rust-analyzer` and the way it interacts with Neovim that may make you think your
setup is broken. For example, if you are working with a cargo workspace and do not see error diagnostics
from the on-save command (`clippy`), this is most probably because it is stuck in another crate within the
workspace and didn't make it through to the file you are working with right now. The command that is run
by `rust-analyzer` is:

```shell
cargo clippy --workspace --message-format=json --all-targets --manifest-path <path-to-workspace>/Cargo.toml
```

You may run it manually and see where `clippy` got stuck. What may seem more surprising though is that using
the built-in `check` instead of `clippy` is more resilient and can show errors in the file you are working
with, while still having failed diagnostics elsewhere within the workspace.
