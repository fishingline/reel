function _reel_cmd_list \
    --description "List plugins"

    set -q reel_plugins_path; or set -l reel_plugins_path $__fish_config_dir/plugins
    argparse 'style=' -- $argv
    if test $status -ne 0
        echo >&2 "reel-list: Invalid 'ls' arguments." && return 1
    end

    if not contains "$_flag_style" "" name repo path url
        echo >&2 "reel-list: Invalid 'ls' style '$_flag_style'."
        echo >&2 "Valid values are: 'name', 'repo', 'path', 'url'."
        return 1
    end

    for plugin_dir in $reel_plugins_path/*
        switch "$_flag_style"
            case '' name
                _reel_list_style_name $plugin_dir
            case path
                _reel_list_style_path $plugin_dir
            case url
                _reel_list_style_url $plugin_dir
            case repo
                _reel_list_style_repo $plugin_dir
        end
    end
end

function _reel_list_style_name -a plugin_dir
    basename $plugin_dir
end

function _reel_list_style_path -a plugin_dir
    echo $plugin_dir
end

function _reel_list_style_url -a plugin_dir
    if test -d $plugin_dir/.git
        git -C "$plugin_dir" remote get-url origin
    end
end

function _reel_list_style_repo -a plugin_dir
    if test -d $plugin_dir/.git
        set -l giturl (git -C "$plugin_dir" remote get-url origin)
        if set -l parsed (string match -r '[:/]([^/]+/[^/]+)(?:.git)?$' $giturl)
            echo $parsed[2]
        else
            echo $giturl
        end
    end
end
