source (status dirname)/includes/bootstrap.fish
setup (realpath (status filename))

source $TEST_PROJECT_DIR/functions/_reel_cmd_version.fish
set reply (_reel_cmd_version)
set errcode $status
set ver_pattern '^'(string escape --style=regex 'reel, version ')'\d+\.\d+\.\d+(\-.+)?$'

@echo "version results: $reply"
@test "'_reel_cmd_version' outputs correct version format" \
    (string match --quiet --regex "$ver_pattern" $reply) \
    $status -eq 0
@test "'_reel_cmd_version' returns 0" $errcode -eq 0

teardown
