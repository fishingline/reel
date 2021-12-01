source (status dirname)/includes/bootstrap.fish
setup (realpath (status filename))

source $TEST_PROJECT_DIR/functions/_reel_cmd_list.fish

@echo "--- list with no plugins ---"
set reply (_reel_cmd_list)
set errcode $status
@test "'_reel_cmd_list' returns success (0)" $errcode -eq 0
@test "'_reel_cmd_list' outputs nothing with no plugins" (count $reply) -eq 0

setup_fake_plugins
set reply (_reel_cmd_list)
set errcode $status
@echo "--- list with 3 fake plugins ---"
@test "'_reel_cmd_list' returns success (0)" $errcode -eq 0
@test "'_reel_cmd_list' outputs 3 plugins" (count $reply) -eq 3
@test "'_reel_cmd_list' outputs fake1 fake2 fake3" "$reply" = "fake1 fake2 fake3"

set reply (_reel_cmd_list --style=path)
set errcode $status
@echo "--- list --style=path with 3 fake plugins ---"
@test "'_reel_cmd_list' returns success (0)" $errcode -eq 0
@test "'_reel_cmd_list' outputs 3 plugins" (count $reply) -eq 3
@test "'_reel_cmd_list' outputs \$reel_plugins_path/fake1...fake3" "$reply" = "$reel_plugins_path/fake1 $reel_plugins_path/fake2 $reel_plugins_path/fake3"

teardown
