# ---- resource limits ----------------------------------------------------
# macOS defaults the open-file soft limit to 256, which floods tools that fan
# out many FDs (pulumi up, docker) with "Too many open files". Raise it — but
# only upward, so a shell that already inherited a higher limit isn't lowered.
# Runs at top level (not just interactive) so scripts get it too. Hard limit is
# `unlimited` on macOS, so no privilege needed for the soft bump.
if test (ulimit -Sn) != unlimited; and test (ulimit -Sn) -lt 10240
    ulimit -S -n 10240
end

if status is-interactive

    # ---- history --------------------------------------------------------
    # Nothing to configure. Fish defaults already match the old .zshrc:
    #   huge history, timestamps, append-per-command, one shared file that
    #   is read at startup (no live cross-session interleave), leading-space
    #   to skip, and non-destructive dedup (dups collapse in search only).
    # Run `history merge` to pull in other sessions' commands on demand.

    # ---- fzf ------------------------------------------------------------
    set -gx FZF_DEFAULT_COMMAND 'fd . --hidden --exclude ".git"'
    fzf --fish | source          # keybindings + completion (replaces ~/.fzf.zsh)

    # ---- handy aliases --------------------------------------------------
    # fish's `alias` auto-inserts `command` for self-referential ones
    # (ls/less/wget), so no recursion — these are 1:1 with the old .zshrc.
    alias now 'date +"%T"'
    alias nowtime now
    alias nowdate 'date +"%Y-%m-%d"'
    alias nowtimestamp 'date +"%Y%m%d%H%M%S"'
    alias ll 'ls -la'
    alias wget 'wget -c'
    alias c 'claude  --permission-mode auto'
    # colors (macOS /bin/ls supports --color; grep/rg/fd do too)
    alias less 'less -R'
    alias ls 'ls --color=auto'
    alias grepc 'grep --color=always'
    alias egrepc 'grep -E --color=always'   # egrep is deprecated; grep -E
    alias rgc 'rg --color=always'
    alias lsc 'ls --color=always'
    alias fdc 'fd --color=always'

    # find dirs, fuzzy-pick, preview with tree
    function dir
        find . -type d | fzf --preview='tree -C {} | head -n 50' --preview-window=70%,border-double,top
    end

    # ---- completions ----------------------------------------------------
    # No compinit/bashcompinit needed — fish autoloads completions.
    # AWS CLI v2:
    complete -c aws -f -a '(env COMP_LINE=(commandline -pc) COMP_POINT=(commandline -C) /opt/homebrew/bin/aws_completer)'

end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
