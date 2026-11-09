function custom_prompt --description 'Set this shell\'s prompt to a literal string; no args restores the default'
    if test (count $argv) -eq 0
        functions --erase fish_prompt # falls back to the autoloaded/default one
        return
    end
    set -g __custom_prompt "$argv"
    function fish_prompt --description 'Write out the prompt'
        printf '%s' $__custom_prompt
    end
end
