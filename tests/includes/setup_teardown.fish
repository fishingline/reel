function setup \
    --description "Setup tests" \
    --argument-names test_file_path

    set -g TEST_FILE (basename $test_file_path)
    set -g TEST_PROJECT_DIR (realpath (status dirname)/../..)
    set -g TEST_TEMPDIR (mktemp -d)
    set -g reel_plugins_path "$TEST_TEMPDIR/plugins"

    @echo "=== $TEST_FILE ==="
end

function teardown
    set -e TEST_FILE
    set -e PROJECT_DIR

    if test -z "$TEST_TEMPDIR" || not test -d $TEST_TEMPDIR
        return
    end
    if string match -q '/var/folders/*' $TEST_TEMPDIR || string match -q '/tmp/*' $TEST_TEMPDIR
        @echo "removing $TEST_TEMPDIR"
        rm -rf "$TEST_TEMPDIR"
    else
        @echo "Unexpected location for temp dir:" $TEST_TEMPDIR
    end
end

function setup_all_fake_plugins \
    --description "fake plugin creator"
    make_fake_plugin a/fake1 functions
    make_fake_plugin b/fake2 functions conf.d
    make_fake_plugin c/fake3 functions conf.d completions
end

function make_fake_plugin \
    --description "fake plugin creator" \
    --argument-names repo

    set plugin_name (string split / --max 1 --fields 2 --right -- /$repo)
    for dirname in $argv[2..]
        mkdir -p $reel_plugins_path/$plugin_name/$dirname
        set -l filename $reel_plugins_path/$plugin_name/$dirname/$plugin_name.fish
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

function fake_confd_contents -a name
    echo "set -g loaded_plugins \$loaded_plugins $name"
end

function fake_function_contents -a name
    echo "function $name"
    echo "    echo $name"
    echo end
end
