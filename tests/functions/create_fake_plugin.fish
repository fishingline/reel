function create_fake_plugin \
    --description "fake plugin creator" \
    --argument-names rootdir repo


    function fake_confd_contents -a name
        echo "set -g fake_plugin_confd_loaded \$fake_plugin_confd_loaded $name"
    end

    function fake_function_contents -a name
        echo "function $name"
        echo "    echo $name"
        echo end
    end

    set plugin_name (string split / --max 1 --fields 2 --right -- /$repo)
    for dirname in $argv[2..]
        mkdir -p $rootdir/$plugin_name/$dirname
        set -l filename $rootdir/$plugin_name/$dirname/$plugin_name.fish
        switch $dirname
            case functions
                fake_function_contents $plugin_name >$filename
            case conf.d
                fake_confd_contents $plugin_name >$filename
            case *
                touch $filename
        end
    end
end
