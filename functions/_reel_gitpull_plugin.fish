function _reel_cmd_update \
    --description "Update a plugin"

    echo TODO
    # # reel up can take arguments for plugins to update
    # if test (count $argv) -gt 0
    #     for repo in $argv
    #         set -l plugin (string split / --max 1 --fields 2 --right /$repo)
    #         _reel_gitpull $plugin
    #     end
    #     return
    # end

    # # if no arguments given, then we update everything to match the contents
    # # of our $reel_plugins_file
    # set -l plugins (string match --invert -r '^(\#.*)?$' <$reel_plugins_file)
    # set -l plugin_names (string split / --max 1 --fields 2 --right $plugins)

    # # remove plugins that are no longer in $reel_plugins_file
    # for dir in $reel_plugins_path/*/

    # end



    # for repo in $argv
    #     set -l plugin (string split / --max 1 --fields 2 --right /$repo)
    #     if not test -d "$reel_plugins_path/$plugin/.git"
    #         echo >&2 "reel: Plugin not found or not a git plugin '$plugin'" && return 1
    #     end
    #     echo "updating plugin $plugin..."
    #     command git -C "$reel_plugins_path/$plugin" pull --recurse-submodules origin
    # end
end
