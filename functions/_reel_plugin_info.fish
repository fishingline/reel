function _reel_plugin_info \
    --description "Prints the plugin's fully qualified path, name, and type" \
    --argument-names plugin

    if test (count $argv) -eq 0 || test -z "$argv[1]"
        return 1
    end
    set -l plugin (string replace -r '^~/' $HOME/ $plugin)
    set -l plugin_name (string split / --max 1 --fields 2 --right /$plugin |
                        string replace -r '\.git$' '')
    set -l plugin_type giturl

    if string match -q -r '^/' $plugin
        set plugin_type local
    else if not string match -r '^(https?|git|ssh)' $plugin
        set -q reel_git_domain || set -l reel_git_domain 'github.com'
        set -q reel_git_protocol || set -l reel_git_protocol https
        if test $reel_git_protocol = git
            set plugin "git@$reel_git_domain:$plugin.git"
        else
            set plugin "$reel_git_protocol://$reel_git_domain/$plugin.git"
        end
    end
    printf "%s\n" $plugin $plugin_name $plugin_type
end
