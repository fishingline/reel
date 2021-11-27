function _reel_remove \
    --description "Remove a plugin managed by reel" \
    --argument-names plugin

    if test -z "$plugin"
        echo >&2 "reel-remove: Plugin argument expected" && return 1
    end

    # if a long form plugin path is provided, just take the last part
    set plugin (string split / --max 1 --fields 2 --right /$plugin)

    if ! test -d "$reel_plugins_path/$plugin"
        echo >&2 "reel-remove: Plugin not found '$plugin'." && return 1
    end
    if test "$plugin" = reel
        echo >&2 "reel-remove: Reel cannot remove itself." && return 1
    end

    echo "Removing plugin $plugin..."
    command rm -rf "$reel_plugins_path/$plugin"
    set -l rm_plugin_pattern '/'(string escape --style=regex $plugin)'$'
    set -l plugins (string match --all --invert -r $rm_plugin_pattern <$reel_plugins_file)
    printf "%s\n" $plugins >$reel_plugins_file
end
