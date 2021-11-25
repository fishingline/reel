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

function _reelcmd_rm -a plugin -d "Enable all plugins managed by reel"
    if test -z "$plugin"
        echo >&2 "reel: Plugin argument expected" && return 1
    end

    # if a long form plugin path is provided, just take the last part
    set plugin (string split / --max 1 --fields 2 --right /$plugin)

    if ! test -d "$reel_plugins_path/$plugin"
        echo >&2 "reel: Plugin not found '$plugin'." && return 1
    end
    if test "$plugin" = reel
        echo >&2 "reel: Reel cannot remove itself." && return 1
    end

    echo "removing plugin $plugin..."
    command rm -rf "$reel_plugins_path/$plugin"
    set -l rm_plugin_pattern '/'(string escape --style=regex $plugin)'$'
    set -l plugins (string match --all --invert -r $rm_plugin_pattern <$reel_plugins_file)
    printf "%s\n" $plugins >$reel_plugins_file
end

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
