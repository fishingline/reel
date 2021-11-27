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

function fake_confd_contents -a name
    echo "set -g loaded_plugins \$loaded_plugins $name"
end

function fake_function_contents -a name
    echo "function $name"
    echo "    echo $name"
    echo "end"
end
