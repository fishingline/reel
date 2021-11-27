function _reel_in \
    --description "Install or update plugins"

    # init
    set -q reel_plugins_path; or set -l reel_plugins_path $__fish_config_dir/plugins
    set -q reel_plugins_file; or set -l reel_plugins_file $__fish_config_dir/reel_plugins
    set -q reel_git_domain; or set -l reel_git_domain 'github.com'
    test -f $reel_plugins_file || echo mattmc3/reel >$reel_plugins_file

    # arguments
    argparse 'b/branch=' -- $argv

    if test (count $argv) -gt 1
        echo >&2 "reel: Invalid arguments." && return 1
    else if test (count $argv) -eq 1
        set -l repo $argv[1]
        # change input like https://github.com/mattmc3/reel.git or mattmc3/reel
        # to just 'reel'
        set -l plugin_name (string split / --max 1 --fields 2 --right /$repo |
                            string replace -r '\.git$' '')
        set -l plugin_dir $reel_plugins_path/$plugin_name
        if test -d $plugin_dir
            # the plugin exists, so let's update it
            echo "Updating plugin $repo..."
            command git -C "$plugin_dir" pull --recurse-submodules origin
        else
            set -l giturl $repo
            if not string match -r '^(https?|git|ssh)' $giturl
                set giturl "https://$reel_git_domain/$giturl"
            end
            command git clone --depth 1 --recursive --shallow-submodules $giturl $plugin_dir
            if test $status -ne 0
                echo "reel: `git clone` failed for '$repo'." >&2 && return 1
            end
            echo $repo >>$reel_plugins_file
        end
    else
        echo todo
    end
end
