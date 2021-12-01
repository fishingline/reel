function teardown
    set -e TEST_FILE
    set -e PROJECT_DIR
    set fish_function_path $orig_fish_function_path
    set fish_complete_path $orig_fish_complete_path

    if test -z "$TEST_TEMPDIR" || not test -d $TEST_TEMPDIR
        return
    end
    if string match -q '/var/folders/*' $TEST_TEMPDIR || string match -q '/tmp/*' $TEST_TEMPDIR
        @echo "removing $TEST_TEMPDIR"
        rm -rf "$TEST_TEMPDIR"
    else
        @echo "Unexpected location for temp dir:" $TEST_TEMPDIR
    end
    set -e TEST_TEMPDIR
end
