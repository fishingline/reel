function _reel_cmd_install \
    --description "Install or update plugins"

    set -q reel_plugins_path; or set -l reel_plugins_path $__fish_config_dir/plugins

    # arguments
    set -l orig_argv $argv
    argparse 'b/branch=' -- $argv

    if test (count $argv) -ne 1 || test -z "$argv[1]"
        echo >&2 "reel: Invalid arguments." && return 1
    end

    # if the plugin is a local path (starts with a slash), then we symlink it
    # otherwise, we assume the plugin is a git repo and we clone it
    set -l plugin_info _reel_plugin_info $argv[1]
    set -l plugin $plugin_info[1]
    set -l plugin_dir $reel_plugins_path/$plugin_info[2]
    if test -d $plugin_dir
        echo >&2 "reel: The plugin is already installed '$argv[1]'." && return 1
    end

    if $plugin_info[3] = local
        _reel_symlink_plugin $plugin $plugin_dir
    else
        _reel_gitclone_plugin $plugin $plugin_dir $_flag_branch
    end

    # set -q reel_plugins_file || set -l reel_plugins_file $__fish_config_dir/reel_plugins
    # test -f $reel_plugins_file || echo mattmc3/reel >$reel_plugins_file
    # echo $repo >>$reel_plugins_file
end
