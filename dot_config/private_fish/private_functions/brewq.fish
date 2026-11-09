# brew install, but refuse formulae whose current version landed in homebrew-core
# less than $brewq_min_age_days ago (default 7).
function brewq
    set -q brewq_min_age_days; or set -l brewq_min_age_days 7
    for f in $argv
        set -l letter (string sub -l 1 -- $f)
        set -l date (curl -sf "https://api.github.com/repos/Homebrew/homebrew-core/commits?path=Formula/$letter/$f.rb&per_page=1" |
            python3 -c 'import json,sys; c=json.load(sys.stdin); print(c[0]["commit"]["committer"]["date"] if c else "")')
        if test -z "$date"
            echo "brewq: no homebrew-core history for $f (cask? tap? renamed?)" >&2
            return 1
        end
        set -l age (math (math (date +%s) - (date -jf %Y-%m-%dT%H:%M:%SZ $date +%s)) / 86400)
        if test (math "floor($age)") -lt $brewq_min_age_days
            printf "brewq: %s last bumped %.1f days ago (< %d) — skipping\n" $f $age $brewq_min_age_days >&2
            return 1
        end
        printf "brewq: %s last bumped %.1f days ago — ok\n" $f $age
    end
    brew install $argv
end
