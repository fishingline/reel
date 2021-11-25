function plugin-load -a plugin_dir -d "Load a plugin"
    if ! test -d "$plugin_dir"
        echo >&2 "plugin-load: Plugin directory not found: '$plugin_dir'."
        return 1
    end
    test -d $plugin_dir/completions && set $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
    test -d $plugin_dir/functions && set $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
    for file in $plugin_dir/conf.d/*
        builtin source "$f"
    end
end
