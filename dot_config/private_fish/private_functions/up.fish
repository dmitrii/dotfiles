function up --description 'Upgrade Homebrew packages, then pull and apply both dotfiles repos'
    brew update; and brew upgrade; and chezmoi update
end
