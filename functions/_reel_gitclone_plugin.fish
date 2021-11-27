function _reel_gitclone \
    --description "Clone a git plugin" \
    --argument-names repo

    set -l giturl $repo
    if not string match -r '^(https?|git|ssh)' $giturl
        set giturl "https://$reel_git_domain/$giturl"
    end
    command git clone --depth 1 --recursive --shallow-submodules $giturl $plugin_dir
    set -l errcode $status
    if test $errcode -ne 0
        echo "reel: `git clone` failed for '$repo'." >&2 && return $errcode
    end

    set -q reel_plugins_file; or set -l reel_plugins_file $__fish_config_dir/reel_plugins
    test -f $reel_plugins_file || echo mattmc3/reel >$reel_plugins_file
    echo $repo >>$reel_plugins_file
end
