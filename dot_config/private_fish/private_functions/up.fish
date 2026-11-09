function up --description 'Upgrade Homebrew packages past their cooldown, then pull and apply both dotfiles repos'
    brew-upgrade-with-cooldown; and chezmoi update
end
