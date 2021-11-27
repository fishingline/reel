function _reel_cmd_load \
    --description "Load any fish plugin directory" \
    --argument-names plugin_path

    if not test -d "$plugin_path"
        echo >&2 "plugin-load: Plugin path not found: '$plugin_path'."
        return 1
    end
    if test -d $plugin_path/completions && not contains $fish_complete_path $plugin_path/completions
        set fish_complete_path $fish_complete_path[1] $plugin_path/completions $fish_complete_path[2..-1]
    end
    if test -d $plugin_path/functions && not contains $fish_function_path $plugin_path/functions
        set fish_function_path $fish_function_path[1] $plugin_path/functions $fish_function_path[2..-1]
    end
    test -f $plugin_path/config.fish && builtin source "$plugin_path/config.fish"
    for file in $plugin_path/conf.d/*
        builtin source "$file"
    end
end
