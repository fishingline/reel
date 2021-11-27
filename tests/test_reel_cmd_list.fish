source (status dirname)/includes/setup_teardown.fish
setup (realpath (status filename))

source $TEST_PROJECT_DIR/functions/_reel_cmd_list.fish

@echo "--- list with no plugins ---"
set reply (_reel_cmd_list)
set errcode $status
@test "'_reel_cmd_list' outputs nothing with no plugins" (count $reply) -eq 0
@test "'_reel_cmd_list' returns 0" $errcode -eq 0

teardown
