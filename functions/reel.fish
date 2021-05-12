# http://github.com/mattmc3/reel
# Copyright mattmc3, 2020-2021
# MIT license, https://opensource.org/licenses/MIT

set -g reel_version 1.0.2
set -q reel_plugins_path; or set -g reel_plugins_path $__fish_config_dir/plugins
set -q reel_git_server; or set -g reel_git_server "github.com"
set -q reel_git_protocol; or set -g reel_git_protocol https

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

function __reel_is_giturl -a repo
    string match -q -r '^(https?|git|ssh):\/\/' $repo
    or string match -q -r '^git@' $repo
    or return 1
end

function __reel_parse_plugin_name_from_giturl -a url
    # In Zsh, you might do something like this: name=${${url##*/}%.git}
    # In Fish, we need to use a regex to get the plugin name from a URL
    # eg: https://github.com/mattmc3/reel.git => reel
    # Assign $name the value of the string after the last slash, sans a .git suffix
    string match -q -r '\/(?<name>[^\/]+?)(?:\.git)?$' $url || return 1
    echo $name
end

function __reel_clone -a repo
    echo "repo: $repo"

    if not __reel_is_giturl $repo
        if contains "$reel_git_protocol" git ssh
            set repo $reel_git_protocol"@"$reel_git_server":"$repo
        else
            set repo $reel_git_protocol"://"$reel_git_server"/"$repo
        end
    end

    echo "repo: $repo"
    set -l plugin_name (__reel_parse_plugin_name_from_giturl $repo)
    set -l plugin_dir "$reel_plugins_path/$plugin_name"
    if test -d $plugin_dir
        echo >&2 "reel: plugin already exists $plugin_dir" && return 1
    end
    echo "cloning repo $plugin..."
    command git clone --depth 1 --recursive --shallow-submodules $repo $plugin_dir
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
