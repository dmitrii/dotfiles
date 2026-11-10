# dotfiles

fish, git, ssh, Homebrew and apt packages, and Claude Code configuration for macOS and Ubuntu, managed with [chezmoi](https://www.chezmoi.io/).

chezmoi keeps the files in this repo (the source) and writes them into `$HOME` (the target). File names carry attributes: `dot_` becomes `.`, `private_` sets mode 0600/0700, `executable_` sets the execute bit, `symlink_` makes a symlink, and `.tmpl` renders the file as a template per machine.

## Contents

| Target | Purpose |
|---|---|
| `~/.config/fish/` | fish configuration and functions, including `up` |
| `~/.gitconfig` | git settings; SSH signing and the HTTPS-to-SSH rewrite apply on macOS only |
| `~/.ssh/config` | includes `~/.ssh/config.d/*` for per-machine hosts |
| `~/.Brewfile` | Homebrew formulae (macOS) |
| `~/.Aptfile` | apt packages, one per line (Ubuntu) |
| `~/.local/bin/` | `brew-upgrade-with-cooldown`, `ssh-forward-agent` (macOS) |
| `~/.claude/` | `CLAUDE.md`, a vendored skill, and links to skills, agents and commands in Mischa's dotfiles |

Each machine supplies its own identity and hosts in files this repo leaves alone: `~/.config/git/local.gitconfig` (email), `~/.config/fish/conf.d/local-*.fish`, and `~/.ssh/config.d/*`.

## First-time setup

### macOS

```sh
# Homebrew, if missing: https://brew.sh
brew install chezmoi
chezmoi init dmitrii                    # clone github.com/dmitrii/dotfiles; changes nothing in $HOME
chezmoi diff                            # review what apply will write
chezmoi apply                           # write the files, then `brew bundle --global`
git config --file ~/.config/git/local.gitconfig user.email <email>
chsh -s /opt/homebrew/bin/fish          # needs /opt/homebrew/bin/fish in /etc/shells
```

### Ubuntu

```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply dmitrii
git config --file ~/.config/git/local.gitconfig user.email <email>
exec fish -l
```

`apply` installs `~/.Aptfile` with apt, links `fd` to Ubuntu's `fdfind`, and makes fish the login shell. It needs passwordless `sudo`.

## Daily

```fish
up
```

On macOS `up` runs `brew-upgrade-with-cooldown`, which updates Homebrew and upgrades packages whose recipes are at least 12 hours old (security fixes at once). On Ubuntu it runs `apt-get update` and `apt-get upgrade`. Then it runs `chezmoi update`, which pulls this repo and applies it. Editing `~/.Brewfile` or `~/.Aptfile` makes the next apply install the list again.

## Changing the dotfiles

Edit the live file in `$HOME`, then copy the edit back into the repo:

```fish
chezmoi status          # files whose live copy differs from the repo
chezmoi diff            # the changes `apply` would make, so live edits appear reversed
chezmoi re-add          # copy live edits into the repo and commit them
```

`re-add` skips templates without a message, and `chezmoi status` keeps listing them. Edit these four in the source instead:

```fish
chezmoi edit --apply ~/.gitconfig     # also ~/.ssh/config, ~/.config/fish/functions/up.fish
```

The `herdr` skill is generated from `herdr --skill` and needs no edits.

| Task | Command |
|---|---|
| Track a new file | `chezmoi add <file>` (`--template` to make it a template) |
| Throw away live edits | `chezmoi apply` |
| Add a package | edit `~/.Brewfile` or `~/.Aptfile`, then `chezmoi re-add` |
| Review unpushed commits | `chezmoi git -- log -p @{u}..` |
| Publish | `chezmoi git push` |
| Open the source | `chezmoi cd` |

Commits happen on `add`, `re-add` and `edit`. Pushes happen only on `chezmoi git push`.

## Remote boxes

`ssh-forward-agent` runs before each connection to a host whose `~/.ssh/config.d` entry calls it. It loads one key into a separate agent, restricted to that host and to `github.com` through that host, for 12 hours, and that agent is the one forwarded. On the remote box, `~/.ssh/rc` points `~/.ssh/agent.sock` at the newest connection's agent, and fish re-points it at a live one when a connection closes.
