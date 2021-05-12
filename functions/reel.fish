# http://github.com/mattmc3/reel
# Copyright mattmc3, 2020-2021
# MIT license, https://opensource.org/licenses/MIT

set -g reel_version 1.0.2
set -q reel_plugins_path; or set -g reel_plugins_path $__fish_config_dir/plugins
set -q reel_git_default_domain; or set -g reel_git_default_domain "github.com"

function __reel_usage
    echo "reel - manage your fish plugins"
    echo ""
    echo "Comands:"
    echo "ls               List installed plugins"
    echo "in <plugins...>  Initialize plugins by cloning if neccesary, and loading"
    echo "rm <plugins...>  Remove an existing plugin"
    echo "up <plugins...>  Update the specified plugins"
    echo "up               Update all plugins"
    echo "load <paths...>  Load a plugin from a directory"
    echo "clone <plugin>   git clone the specified plugin"
    echo ""
    echo "Options:"
    echo "       -v or --version  Print version"
    echo "       -h or --help     Print this help message"
end

function __reel_ls
    for p in $reel_plugins_path/*/*
        string replace -a "$reel_plugins_path/" "" $p
    end
end

function __reel_up -a plugin
    if not test -d "$reel_plugins_path/$plugin"
        echo >&2 "reel: plugin not found $plugin" && return 1
    end
    echo "updating plugin $plugin..."
    command git -C "$reel_plugins_path/$plugin" pull --recurse-submodules origin
end

function __reel_parse_giturl
    # try to parse a git URL
    set -l parsed (string match -r '^((?:https?|git|ssh):\/\/)(.+)\/([^\/]+)\/([^\/]+?)(?:.git)?$' $argv)
    or set -l parsed (string match -r '^(git@)(.+):([^\/]+)\/([^\/]+?)(?:.git)?$' $argv)
    or set -l parsed (string match -r '^([^\/]+)\/([^\/]+)$' $argv)

    if test (count $parsed) -eq 3
        set parsed "https://$reel_git_default_domain/$parsed[2]/$parsed[3]" "https://" "$reel_git_default_domain" $parsed[2..-1]
    else if test (count $parsed) -ne 5
        echo >&2 "reel: unable to parse git URL $argv" && return 1
    end

    # return the parsed URL as url, protocol, domain, user, and repo
    for item in $parsed
        echo $item
    end
end

function __reel_clone -a plugin
    set -l urlparts (__reel_parse_giturl $plugin)
    if test $status -ne 0
        echo >&2 "reel: invalid plugin $plugin" && return 1
    end
    set -l plugindir "$reel_plugins_path/$urlparts[4]/$urlparts[5]"
    if test -d $plugindir
        echo >&2 "reel: plugin already exists" && return 1
    end
    echo "cloning repo $plugin..."
    command git clone --recursive --depth 1 $urlparts[1] $plugindir
end

function __reel_load -a plugin
    if test -d "$plugin"
        set plugin (realpath "$plugin")
    else if test -d "$reel_plugins_path/$plugin"
        set plugin (realpath "$reel_plugins_path/$plugin")
    else
        echo >&2 "reel: plugin not found $plugin" && return 1
    end
    load_plugin $plugin
end

function load_plugin -a plugin
    if test -d "$plugin/completions"; and not contains "$plugin/completions" $fish_complete_path
        set fish_complete_path "$plugin/completions" $fish_complete_path
    end
    if test -d "$plugin/functions"; and not contains "$plugin/functions" $fish_function_path
        set fish_function_path "$plugin/functions" $fish_function_path
    end
    for f in "$plugin/conf.d"/*.fish
        builtin source "$f"
    end
end

function __reel_in -a plugin
    if not test -d "$reel_plugins_path/$plugin"
        __reel_clone "$plugin"
    end
    __reel_load "$reel_plugins_path/$plugin"
end

function __reel_rm -a plugin
    set plugin_path "$reel_plugins_path/$plugin"
    if not test -d "$plugin_path"
        echo >&2 "reel: plugin not found '$plugin'" && return 1
    else if not __reel_is_safe_rm "$plugin_path"
        echo >&2 "reel: plugin path not safe to remove '$plugin'" && return 1
    else
        echo "removing $plugin_path..."
        command rm -rf "$plugin_path"
    end
end

function __reel_is_safe_rm -a plugin_path
    # quick check to make sure no one is being evil ../ relative paths
    set plugin_path (realpath "$plugin_path")
    set -l reeldir (realpath "$reel_plugins_path")
    string match -q -- "$reeldir/*" "$plugin_path" || return 1
end

function reel -a cmd --description 'Manage your fish plugins'
    set argv $argv[2..-1]
    switch "$cmd"
        case -v --version
            echo "reel, version $reel_version"
        case "" -h --help
            __reel_usage
            test "$cmd" != "" || return 1
        case ls list
            __reel_ls
        case up update
            test (count $argv) -gt 0; or set argv (__reel_ls)
            for p in $argv
                __reel_up $p
            end
        case in clone load rm
            if test (count $argv) -eq 0
                echo >&2 "reel: argument expected" && return 1
            end
            for p in $argv
                __reel_$cmd $p
            end
        case \*
            echo >&2 "reel: unknown flag or command \"$cmd\" (see `reel -h`)" && return 1
    end
end
