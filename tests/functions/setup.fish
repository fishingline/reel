function setup \
    --description "Setup tests" \
    --argument-names test_file_path

    set -g TEST_FILE (basename $test_file_path)
    set -g TEST_PROJECT_DIR (realpath (status dirname)/../..)
    set -g TEST_TEMPDIR (mktemp -d)
    set -g reel_plugins_path "$TEST_TEMPDIR/plugins"
    set -g reel_plugins_file "$TEST_TEMPDIR/reel_plugins"
    set -g orig_fish_function_path $fish_function_path
    set -g orig_fish_complete_path $fish_complete_path

    @echo "=== $TEST_FILE ==="
end
