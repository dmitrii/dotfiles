function chezmoi-private --wraps chezmoi --description 'chezmoi for the private dotfiles repo'
    chezmoi --config ~/.config/chezmoi-private/chezmoi.toml $argv
end
