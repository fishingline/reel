function _reel_gitclone_plugin \
    --description "Clone a git plugin" \
    --argument-names repo destination branch

    if test -z "$repo" || test -z "$destination"
        echo "reel: Arguments expected." >&2 && return 1
    end

    set -l giturl $repo
    if not string match -r '^(https?|git|ssh)' $repo
        set -q reel_git_domain || set -l reel_git_domain github.com
        set giturl "https://$reel_git_domain/$repo"
    end
    set -l gitargs
    if test -n "$branch"
        set gitargs --branch="$branch"
    end
    command git clone $gitargs --depth 1 --recursive --shallow-submodules $giturl $destination
    set -l errcode $status
    if test $errcode -ne 0
        echo "reel: `git clone` failed for '$repo'." >&2 && return $errcode
    end
    return
end
