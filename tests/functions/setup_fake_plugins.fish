function setup_fake_plugins \
    --description "fake plugin creator"

    create_fake_plugin $reel_plugins_path a/fake1 functions
    create_fake_plugin $reel_plugins_path b/fake2 functions conf.d
    create_fake_plugin $reel_plugins_path c/fake3 functions conf.d completions
    create_fake_plugin $TEST_TEMPDIR/projects myplugin functions conf.d completions
end
