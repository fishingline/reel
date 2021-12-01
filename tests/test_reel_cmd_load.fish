source (status dirname)/includes/bootstrap.fish
setup (realpath (status filename))
setup_fake_plugins

source $TEST_PROJECT_DIR/functions/_reel_cmd_load.fish

set -l pre_fish_function_path $fish_function_path
set -l pre_fish_complete_path $fish_complete_path

@echo "--- load 3 fake plugins ---"
@echo "fake conf.d loaded: $fake_plugin_confd_loaded (none)"
@test "fake1 function doesn't exist" (functions --query fake1) $status -ne 0

_reel_cmd_load $reel_plugins_path/fake1
@test "'_reel_cmd_load \$reel_plugins_path/fake1' returns success (0)" $status -eq 0
@test "fake1 function exists" (functions --query fake1) $status -eq 0

_reel_cmd_load $reel_plugins_path/fake2
@test "'_reel_cmd_load \$reel_plugins_path/fake2' returns success (0)" $status -eq 0

_reel_cmd_load $reel_plugins_path/fake3
@test "'_reel_cmd_load \$reel_plugins_path/fake3' returns success (0)" $status -eq 0

@test "'fish_function_path' gained 3 entries" \
    (math (count $pre_fish_function_path) + 3) -eq (count $fish_function_path)

@test "'fish_complete_path' gained 1 entry" \
    (math (count $pre_fish_complete_path) + 1) -eq (count $fish_complete_path)

@echo "fake conf.d loaded: $fake_plugin_confd_loaded"

set reply (_reel_cmd_load /invalid/path 2>&1)
@test "loading an invalid path fails" $status -ne 0
@test "loading an invalid path reports failure message" "$reply" = "reel: Plugin path not found '/invalid/path'."

teardown
