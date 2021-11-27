function _reel_list \
    --description "List installed plugins"

    argparse 'style=' -- $argv
    if test $status -ne 0
        echo >&2 "reel-list: Invalid 'ls' arguments." && return 1
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
            echo >&2 "reel-list: Invalid 'ls' style '$_flag_style'."
            echo >&2 "Valid values are: 'name', 'repo', 'path', 'url'."
            return 1
        end
    end
end
