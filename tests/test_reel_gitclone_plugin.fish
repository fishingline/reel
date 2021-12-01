source (status dirname)/includes/bootstrap.fish
setup (realpath (status filename))
setup_fake_plugins

source $TEST_PROJECT_DIR/functions/_reel_gitclone_plugin.fish

@echo "--- clone with no args ---"
set reply (_reel_gitclone_plugin 2>&1)
@test "'_reel_gitclone_plugin' (no args) reports failure" $status -ne 0
@test "'_reel_gitclone_plugin' prints arg expected" "$reply" = "reel: Arguments expected."

@echo "--- clone non-existent plugin ---"
set reply (_reel_gitclone_plugin mattmc3/doesnotexist . 2>&1)
@test "'_reel_gitclone_plugin mattmc3/doesnotexist .' reports failure" $status -ne 0
@test "'_reel_gitclone_plugin' prints that clone failed" \
    "$reply[-1]" = "reel: `git clone` failed for 'mattmc3/doesnotexist'."

@echo "--- clone test plugin ---"
@test "'reel-test-repo' dir not exists" ! -d $reel_plugins_path/reel-test-repo
set reply (_reel_gitclone_plugin mattmc3/reel-test-repo $reel_plugins_path/reel-test-repo 2>&1)
@test "'_reel_gitclone_plugin mattmc3/reel-test-repo' reports success" $status -eq 0
@test "'reel-test-repo' dir exists" -d $reel_plugins_path/reel-test-repo
set reply (git -C "$reel_plugins_path/reel-test-repo" branch --show-current)
@test "'reel-test-repo' is on the main branch" $reply = main

# clean up from last test
test -d $reel_plugins_path/reel-test-repo && rm -rf $reel_plugins_path/reel-test-repo

@echo "--- clone test plugin @test-plugin2 branch ---"
@test "'reel-test-repo' dir not exists" ! -d $reel_plugins_path/reel-test-repo
set reply (_reel_gitclone_plugin mattmc3/reel-test-repo $reel_plugins_path/reel-test-repo test-plugin2 2>&1)
@echo $reply
@test "'_reel_gitclone_plugin @test-plugin2 branch' reports success" $status -eq 0
@test "'reel-test-repo' dir exists" -d $reel_plugins_path/reel-test-repo
set reply (git -C "$reel_plugins_path/reel-test-repo" branch --show-current)
@test "'reel-test-repo' is on the test-plugin2 branch" $reply = test-plugin2

teardown
