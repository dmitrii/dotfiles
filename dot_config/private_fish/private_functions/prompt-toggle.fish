function prompt-toggle --description 'Toggle between minimal ($ ) and default fish prompt'
    if set -q fish_minimal_prompt
        set -Ue fish_minimal_prompt
        echo 'prompt: default'
    else
        set -U fish_minimal_prompt 1
        echo 'prompt: minimal'
    end
end
