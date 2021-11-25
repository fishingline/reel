# http://github.com/mattmc3/reel
# Copyright mattmc3, 2020-2021
# MIT license, https://opensource.org/licenses/MIT

set -g reel_version 2.0.0
set -q reel_plugins_path; or set -g reel_plugins_path $__fish_config_dir/plugins
set -q reel_plugins_file; or set -g reel_plugins_file $__fish_config_dir/fish_plugins
set -q reel_git_server; or set -g reel_git_server "github.com"
set -q reel_git_protocol; or set -g reel_git_protocol https

function _reel_usage -d "Print out reel usage information"
    echo "reel - Reel in your fish plugins"
    echo ""
    echo "Usage:"
    echo "  reel [-h|--help]"
    echo "  reel [-v|--version]"
    echo "  reel <command> [<args>...]"
    echo ""
    echo "Commands:"
    echo ""
    echo "  reel in <plugins...>    Install plugin(s)"
    echo "  reel rm <plugins...>    Remove plugin(s)"
    echo "  reel up [<plugins...>]  Update plugin(s)"
    echo "  reel ls [--style=xxx]   List plugins (styles: name, repo, path, url)"
    echo "  reel on                 Enable all plugins (usually in fish.config)"
end

function _reelcmd_ls -d "List installed plugins"
    argparse 'style=' -- $argv
    if test $status -ne 0
        echo >&2 "reel: Invalid 'ls' arguments." && return 1
    end
    for p in $reel_plugins_path/*/.git
        if [ "$_flag_style" = name ] || [ -z "$_flag_style" ]
            string replace -a "$reel_plugins_path/" "" $p |
            string replace -a "/.git" ""
        else if [ "$_flag_style" = url ]
            git -C "$p/.." remote get-url origin
        else if [ "$_flag_style" = path ]
            realpath "$p/.."
        else if [ "$_flag_style" = repo ]
            set -l giturl (git -C "$p/.." remote get-url origin)
            if set -l parsed (string match -r '[:/]([^/]+/[^/]+)(?:.git)?$' $giturl)
                echo $parsed[2]
            else
                echo $giturl
            end
        else
            echo >&2 "reel: Invalid 'ls' style '$_flag_style'."
            echo >&2 "      Valid values are: name, repo, path, url"
            echo >&2 "      For example: `reel ls --style=url`"
            return 1
        end
    end
end

function _reelcmd_up -d "Update the specified plugins, or all of them"
    # reel up can take arguments for plugins to update
    if test (count $argv) -gt 0
        for repo in $argv
            set -l plugin (string split / --max 1 --fields 2 --right /$repo)
            _reel_gitpull $plugin
        end
        return
    end

    # if no arguments given, then we update everything to match the contents
    # of our $reel_plugins_file
    set -l plugins (string match --invert -r '^(\#.*)?$' <$reel_plugins_file)
    set -l plugin_names (string split / --max 1 --fields 2 --right $plugins)

    # remove plugins that are no longer in $reel_plugins_file
    for dir in $reel_plugins_path/*/

    end



    for repo in $argv
        set -l plugin (string split / --max 1 --fields 2 --right /$repo)
        if not test -d "$reel_plugins_path/$plugin/.git"
            echo >&2 "reel: Plugin not found or not a git plugin '$plugin'" && return 1
        end
        echo "updating plugin $plugin..."
        command git -C "$reel_plugins_path/$plugin" pull --recurse-submodules origin
    end
end

function _reel_gitpull -a plugin -d "Git pull to update a plugin"
    if not test -d "$reel_plugins_path/$plugin/.git"
        echo >&2 "reel: Plugin not found or not a git plugin '$plugin'" && return 1
    end
    echo "Updating plugin $plugin..."
    command git -C "$reel_plugins_path/$plugin" pull --recurse-submodules origin
end

function _reelcmd_on -d "Enable all plugins managed by reel"
    set -l plugin_complete_path
    set -l plugin_function_path
    set -l plugin_confd_path

    # gather plugin info
    for plugin_dir in $reel_plugins_path/*
        test -d $plugin_dir || continue
        test -d $plugin_dir/completions && set plugin_complete_path $plugin_complete_path $plugin_dir/completions
        test -d $plugin_dir/functions && set plugin_function_path $plugin_function_path $plugin_dir/functions
        test -d $plugin_dir/conf.d && set plugin_confd_path $plugin_confd_path $plugin_dir/conf.d
    end

    set fish_complete_path $fish_complete_path[1] $plugin_complete_path $fish_complete_path[2..-1]
    set fish_function_path $fish_function_path[1] $plugin_function_path $fish_function_path[2..-1]
    for confd in $plugin_confd_path
        for f in $confd/*.fish
            builtin source "$f"
        end
    end
end

# function _reelcmd_in -d "Initialize plugins"
#     if [ ! -f $__fish_config_dir/fish_plugins ]
#         touch $__fish_config_dir/fish_plugins
#     end
#     set plugins (cat $__fish_config_dir/fish_plugins)
# end

# function _reelcmd_in -d "Initialize plugins"
#     if [ ! -f $__fish_config_dir/fish_plugins ]
#         touch $__fish_config_dir/fish_plugins
#     end
#     set plugins (cat $__fish_config_dir/fish_plugins)
# end

# function _reelcmd_rm -d ""
#     # reel command to remove a plugin
#     set plugin_path "$reel_plugins_path/$plugin"
#     if not test -d "$plugin_path"
#         echo >&2 "reel: plugin not found '$plugin'" && return 1
#     else if not _reel_is_safe_rm "$plugin_path"
#         echo >&2 "reel: plugin path not safe to remove '$plugin'" && return 1
#     else
#         echo "removing $plugin_path..."
#         command rm -rf "$plugin_path"
#     end
# end

# function _reel_is_giturl -a repo
#     # checks whether a repo is a proper git URL
#     string match -q -r '^(https?|git|ssh):\/\/' $repo
#     or string match -q -r '^git@' $repo
#     or return 1
# end

# function _reel_parse_plugin_parts_from_giturl -a url
#     # parse the plugin name from a git URL
#     # In Zsh, you might do something like this: reponame=${${url##*/}%.git}
#     # In Fish, we need to use a regex to get the git user and plugin name from a URL
#     # eg: https://github.com/mattmc3/reel.git => mattmc3 reel
#     # eg: git@github.com:mattmc3/reel.git => mattmc3 reel
#     string match -q -r '(?<gituser>[^\/:]+?)\/(?<reponame>[^\/]+?)(?:\.git)?$' $url || return 1
#     echo $gituser
#     echo $reponame
# end

# function _reel_clone -a repo
#     # reel command to clone a fish plugin from a git server
#     if not _reel_is_giturl $repo
#         if contains "$reel_git_protocol" git ssh
#             set repo $reel_git_protocol"@"$reel_git_server":"$repo
#         else
#             set repo $reel_git_protocol"://"$reel_git_server"/"$repo
#         end
#     end

#     set -l plugin_parts (_reel_parse_plugin_parts_from_giturl $repo)
#     set -l plugin_dir "$reel_plugins_path/$plugin_parts[1]/$plugin_parts[2]"
#     if test -d $plugin_dir
#         echo >&2 "reel: plugin already exists $plugin_dir" && return 1
#     end
#     echo "cloning repo $plugin..."
#     command git clone --depth 1 --recursive --shallow-submodules $repo $plugin_dir
# end

# function _reel_load -a plugin
#     # reel command to load a fish plugin
#     if test -d "$plugin"
#         set plugin (realpath "$plugin")
#     else if test -d "$reel_plugins_path/$plugin"
#         set plugin (realpath "$reel_plugins_path/$plugin")
#     else
#         echo >&2 "reel: plugin not found $plugin" && return 1
#     end
#     load_plugin $plugin
# end

# function load_plugin -a plugin
#     if test -d "$plugin/completions"; and not contains "$plugin/completions" $fish_complete_path
#         set fish_complete_path "$plugin/completions" $fish_complete_path
#     end
#     if test -d "$plugin/functions"; and not contains "$plugin/functions" $fish_function_path
#         set fish_function_path "$plugin/functions" $fish_function_path
#     end
#     for f in "$plugin/conf.d"/*.fish
#         builtin source "$f"
#     end
# end

# function _reel_in -a plugin
#     # initialize a reel plugin
#     if not test -d "$reel_plugins_path/$plugin"
#         _reel_clone "$plugin"
#     end
#     _reel_load "$reel_plugins_path/$plugin"
# end

# function _reel_rm -a plugin
#     # reel command to remove a plugin
#     set plugin_path "$reel_plugins_path/$plugin"
#     if not test -d "$plugin_path"
#         echo >&2 "reel: plugin not found '$plugin'" && return 1
#     else if not _reel_is_safe_rm "$plugin_path"
#         echo >&2 "reel: plugin path not safe to remove '$plugin'" && return 1
#     else
#         echo "removing $plugin_path..."
#         command rm -rf "$plugin_path"
#     end
# end

# function _reel_is_safe_rm -a plugin_path
#     # check to make sure no one is being evil and trying to access forbidden
#     # dirs using ../../../ relative paths
#     set plugin_path (realpath "$plugin_path")
#     set -l reeldir (realpath "$reel_plugins_path")
#     string match -q -- "$reeldir/*" "$plugin_path" || return 1
# end

function reel -a cmd -d 'Reel in your fish plugins'
    if test -z "$cmd"
        echo >&2 "reel: Command expected. (see `reel -h`)" && return 1
    end
    switch "$cmd"
        case -h --help
            _reel_usage && return
        case -v --version
            echo "reel, version $reel_version" && return
    end
    if functions -q _reelcmd_$cmd
        _reelcmd_$cmd $argv[2..-1]
        return $status
    else
        echo >&2 "reel: Unknown flag or command '$cmd'. (see `reel -h`)" && return 1
    end
end
